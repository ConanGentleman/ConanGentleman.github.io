---
title: Unity编辑器拓展（七）-Inspector窗口拓展
date: 2025-04-27 22:23:20
tags: Unity编辑器拓展
categories: Unity学习笔记
---
Inspector窗口拓展相关内容
<!--more-->

# 一、Inspector窗口拓展 基础知识

## 1.1 Inspector窗口自定义显示指什么？
- 我可以完全自定义某一个脚本在Inspector窗口的相关显示
## 1.2 SerializedObject和SerializedProperty的作用
- SerializedObject 和 SerializedProperty
    - 主要用于在 Unity 编辑器中操作和修改序列化对象的属性。
    - 它们通常在自定义编辑器中使用，以创建更灵活、可定制的属性面板

- 我们只需要记住简单的规则
    - **SerializedObject 代表脚本对象** ⭐⭐⭐
    - **SerializedProperty 代表脚本对象中的属性** ⭐⭐⭐

SerializedObject: https://docs.unity.cn/cn/2022.1/ScriptReference/SerializedObject.html
SerializedProperty: https://docs.unity.cn/cn/2022.1/ScriptReference/SerializedProperty.html

## 1.3 自定义 脚本在Inspector窗口中显示的内容
关键步骤：
1. 单独为某一个脚本实现一个自定义脚本，并且脚本需要继承Editor。**一般该脚本命名为 自定义脚本名 + Editor**
2. 在该脚本前加上特性
    - 命名空间：UnityEditor
    - 特性名：CustomEditor(想要自定义脚本类名的Type)
3. 声明对应SerializedProperty序列化属性 对象
    - 主要通过它和自定义脚本中的成员进行关联
    - 可以利用继承Editor后的成员serializedObject中的FindProperty("成员变量名")方法关联对应成员;
        - 例如：
        ```cs
        SerializedProperty mySerializedProperty;
        mySerializedProperty = serializedObject.FindProperty("自定义脚本中的成员名");
        ```
        - 一般在OnEnable函数中初始化
4. 重写OnInspectorGUI函数
    - 该函数控制了Inspector窗口中显示的内容
    - 只需要在其中重写内容便可以自定义窗口
    - 注意：其中的逻辑需要包裹在这两句代码之间
    ```cs
        //  更新序列化对象的表示形式
        serializedObject.Update();
        //  之间应用属性修改
        serializedObject.ApplyModifiedProperties();
    ```

## 1.4 获取脚本依附的对象
   - 通过Editor中的target成员变量获取，**获取到的是依附在对象上的Lesson22组件对象并不是依附的GameObject**
## 1.5 总结
   - 为继承Editor的脚本添加[CustomEditor(typeof(想要自定义Inspector窗口的脚本))]特性
   - 在该脚本中按照一定的规则进行编写
   - 便可为Inspector窗口中的某个脚本自定义窗口布局
## 1.6 代码示例
1. Lesson22.cs（不能放在Editor文件夹下）
```cs
    //攻击力
    public int atk;
    //防御力
    public float def;
    //敌对目标对象依附的Gameobject
    public GameObject obj;
    void Start()
    {}

    void Update()
    {}
```

2. Lesson22Editor.cs(放在Editor文件夹下)
```cs
//通过这个特性，我们就可以为Lesson22脚本自定义Inspector窗口中的显示了
[CustomEditor(typeof(Lesson22))]
public class Lesson22Editor : Editor
{
    private SerializedProperty atk;
    private SerializedProperty def;
    private SerializedProperty obj;

    private bool foldOut;

    private void OnEnable()
    {
        atk = serializedObject.FindProperty("atk"); //关联Lesson22中的对应变量，serializedObject代表的就是Lesson22.cs
        def = serializedObject.FindProperty("def");
        obj = serializedObject.FindProperty("obj");
    }

    //  该函数控制了Inspector窗口中显示的内容
    //  只需要在其中重写内容便可以自定义窗口
    public override void OnInspectorGUI()
    {
        //base.OnInspectorGUI();
        serializedObject.Update(); //需要用Update()和ApplyModifiedProperties()进行包裹
        //自定义Inspector窗口的内容
        foldOut = EditorGUILayout.BeginFoldoutHeaderGroup(foldOut, "基础属性"); //折叠控件（头）
        if(foldOut)
        {
            if(GUILayout.Button("测试自定义Inspector窗口"))
            {
                Debug.Log(target.name);
            }
            EditorGUILayout.IntSlider(atk, 0, 100, "攻击力");
            def.floatValue = EditorGUILayout.FloatField("防御力", def.floatValue);
            EditorGUILayout.ObjectField(obj, new GUIContent("敌对对象"));
        }
        EditorGUILayout.EndFoldoutHeaderGroup(); //折叠控件（尾）
        serializedObject.ApplyModifiedProperties();
    }
}

```