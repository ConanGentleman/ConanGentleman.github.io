---
title: UGUI源码学习-一、UIBehaviour
date: 2026-10-25 22:53:10
tags: Unity UGUI源码
categories: Unity学习笔记
---

UIBehaviour
<!--more-->

这是所有UGUI组件的共同基类，继承自MonoBehaviour。定义了一些基本的生命周期函数以及回调函数
# 一、源码
```cs
namespace UnityEngine.EventSystems
{
    /// <summary>
    /// Base behaviour that has protected implementations of Unity lifecycle functions.
    /// </summary>
    public abstract class UIBehaviour : MonoBehaviour
    {
        protected virtual void Awake()
        {}

        protected virtual void OnEnable()
        {}

        protected virtual void Start()
        {}

        protected virtual void OnDisable()
        {}

        protected virtual void OnDestroy()
        {}

        /// <summary>
        /// Returns true if the GameObject and the Component are active.
        /// </summary>
        public virtual bool IsActive()
        {
            return isActiveAndEnabled;
        }

#if UNITY_EDITOR
        protected virtual void OnValidate()
        {}

        protected virtual void Reset()
        {}
#endif
        /// <summary>
        /// This callback is called when the dimensions of an associated RectTransform change. It is always called before Awake, OnEnable, or Start. The call is also made to all child RectTransforms, regardless of whether their dimensions change (which depends on how they are anchored).
        /// </summary>
        protected virtual void OnRectTransformDimensionsChange()
        {}

        protected virtual void OnBeforeTransformParentChanged()
        {}

        protected virtual void OnTransformParentChanged()
        {}

        protected virtual void OnDidApplyAnimationProperties()
        {}

        protected virtual void OnCanvasGroupChanged()
        {}

        /// <summary>
        /// Called when the state of the parent Canvas is changed.
        /// </summary>
        protected virtual void OnCanvasHierarchyChanged()
        {}

        /// <summary>
        /// Returns true if the native representation of the behaviour has been destroyed.
        /// </summary>
        /// <remarks>
        /// When a parent canvas is either enabled, disabled or a nested canvas's OverrideSorting is changed this function is called. You can for example use this to modify objects below a canvas that may depend on a parent canvas - for example, if a canvas is disabled you may want to halt some processing of a UI element.
        /// </remarks>
        public bool IsDestroyed()
        {
            // Workaround for Unity native side of the object
            // having been destroyed but accessing via interface
            // won't call the overloaded ==
            return this == null;
        }
    }
}

```
# 二、源码分析
## 2.1 声明周期函数
1. 首先继承自MonoBehaviour的Awake、OnEnable、Start、OnDisable、OnDestroy都比较熟悉了

## 2.2 仅在编辑器调用的方法
  - OnValidate：**当脚本被加载或 Inspector 面板中的值发生变化时被调用**。一般用于验证和约束序列化字段（Serialized Fields）的数据
  - Reset：**当在 Inspector 中首次添加该组件 或者 用户通过 Inspector 右上角的上下文菜单手动点击 “Reset” 时被调用**。一般用于为组件设置合理的默认值

## 2.2 UIBehaviour的方法
### 2.2.1 提供的生命周期钩子
1. OnRectTransformDimensionsChange()
- 触发时机：关联的 RectTransform 尺寸发生变化时（包括 width/height、anchor、pivot、offset 等导致最终矩形变化的属性）。
  - 总是**先于 Awake、OnEnable、Start 被调用**
  - **会向所有子 RectTransform 广播，无论子物体自身尺寸是否真的变了**
2. OnBeforeTransformParentChanged()
- 触发时机：Transform.parent 即将被改变之前
- 用途：给组件一个机会，在父子关系断裂前做清理工作。例如从旧的 Canvas 或父级系统中注销自己，避免留下悬空引用。
3. OnTransformParentChanged()
- 触发时机：Transform.parent 已经改变之后。
- 用途：在新父级下重新注册自己。例如：
  - 向新的父 Canvas 注册，以参与正确的合批和更新。
  - 重新计算自己在新的层级中的位置、裁剪关系。
  - Graphic 会重写它来重新查找所属的 Canvas，并更新 canvas 引用
4. OnDidApplyAnimationProperties()
- 触发时机：Animation / Animator 系统应用完动画属性之后。
  - **当动画驱动了组件的序列化属性（比如 Image.color、RectTransform 的尺寸）时**，这个回调让组件有机会在动画写入值之后做出反应。Graphic 重写它会重新标记脏标记，确保动画改变的颜色或位置能正确反映到渲染上。
5. OnCanvasGroupChanged()
- 触发时机：父级链上的 CanvasGroup 的 interactable、blocksRaycasts 或 ignoreParentGroups 属性发生变化时。
- 用途：让组件响应“可交互性/射线阻挡”的继承变化。Selectable（Button、Toggle 等的基类）会重写它，根据 CanvasGroup 的状态更新自己的可交互状态（比如变灰、不可点击）。
- UGUI 中“CanvasGroup 控制整组 UI 交互”的底层机制——**不是轮询，而是通过这个回调通知每个子组件**。
6. OnCanvasHierarchyChanged()
- 触发时机：父 Canvas 的状态改变时——包括 Canvas 被启用/禁用，或嵌套 Canvas 的 OverrideSorting 改变。
- 用途：让组件感知自己所属的 Canvas 是否“生效”。注释里给了一个典型场景：如果 Canvas 被禁用，你可能想暂停某个 UI 元素的处理逻辑。Graphic 重写它来更新自己的可见性和注册状态。
### 2.2.2 其他方法
1. IsActive()
- 判断组件是否生效
  - 组件自身的enabled为true
  - 所有父级GameObject处于激活状态
2. IsDestroyed()
- 判断是否已经被销毁
  - 注意：当返回true时，说明C++原生对象被销毁了，原生内存已释放。但 **C# 那层包装壳**不会立刻消失——因为 C# 有垃圾回收（GC），而且可能还有其他 C# 变量持有这个引用。