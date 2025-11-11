---
title: Unity编辑器拓展（七）-Scene窗口拓展
date: 2025-11-11 22:03:13
tags: Unity编辑器拓展
categories: Unity学习笔记
---

# 一、 Handles类是什么及响应函数
## 1.1 知识点一 Handles公共类的作用
Handles类提供了很多API
- 让我们可以在Scene窗口中绘制我们的自定义内容
- 它和GUI、EditorGUI类似，只不过它专门提供给Scene窗口使用

- 想要在Scene窗口中显示自定义内容，我们**需要在对应的响应函数中进行处理**


## 1.2 知识点二 Scene窗口更新响应函数
关键点：
前两个步骤 和自定义Inspector窗口显示内容 一致
1. 单独为某一个脚本实现一个自定义脚本，并且脚本需要继承Editor
    - 一般该脚本命名为 自定义脚本名 + Editor
2. 在该脚本前加上特性
    - 命名空间：UnityEditor
    - 特性名：CustomEditor(想要自定义脚本类名的Type)

3. 在该脚本中实现void OnSceneGUI()方法
    - **该方法会在我们选中挂载自定义脚本的对象时自动更新**
    - **注意：只有选中时才会执行，没有选中不执行**

## 1.3 知识点三 自定义窗口中监听Scene窗口更新响应函数
可以在自定义窗口显示时
- 监听更新事件
```cs
    SceneView.duringSceneGui += 事件函数
```
- 窗口隐藏或销毁时移除事件
```cs  
    SceneView.duringSceneGui -= 事件函数
```
## 1.4 总结
Scene窗口拓展功能
主要是提供给自定义脚本和自定义窗口的
我们采用对应的规则进行处理
便可以在之后的章节中利用场景更新响应函数来自定义一些Scene窗口的显示内容

## 1.5 代码示例
1. scene窗口更新响应函数
```cs
//lesson26.cs
public class Lesson26 : MonoBehaviour
{
}
//lesson26Editor
[CustomEditor(typeof(Lesson26))]
public class Lesson26Editor : Editor
{
    private void OnSceneGUI() //选中挂载了Lesson26的对象时会调用该函数
    {
        Debug.Log("Scene窗口拓展相关逻辑");
    }
}
```
2. 自定义窗口监听scene窗口更新响应函数
```cs
public class Lesson26Window : EditorWindow
{
    [MenuItem("Unity编辑器拓展/Lesson26/打开Scene拓展窗口")]
    private static void OpenLesson26()
    {
        Lesson26Window win = EditorWindow.GetWindow<Lesson26Window>();
        win.Show();
    }

    private void OnEnable()
    {
        SceneView.duringSceneGui += SceneUpdate; //Scene视图每次调用 OnGUI 方法时会触发一次duringSceneGui
    }

    private void OnDestroy()
    {
        SceneView.duringSceneGui -= SceneUpdate;
    }

    private void SceneUpdate(SceneView view)
    {
        Debug.Log("自定义窗口拓展Scene相关内容");
    }
}
```

## 1.6 效果
包含函数和自定义窗口监听scene更新
![](./八-Scene窗口拓展/L26Handles类是什么及响应函数.gif)