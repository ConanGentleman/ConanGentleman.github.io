---
title: Unity编辑器拓展（三）-EditorGUI相关
date: 2025-03-04 21:02:36
tags: Unity编辑器拓展
categories: Unity学习笔记
---

EditorGUI相关的内容

<!--more-->

# 一、EditorGUI是什么
## 1.1 知识回顾

1. GUILayout 是一个GUI自动布局的公共类
2. 它其中的方法和GUI基本一模一样，都是用来绘制、响应各种UI控件的
3. 只不过它在**GUI的基础上加入了自动布局功能**
4. 我们无需过多的去关心UI控件的位置和大小

5. guilayoutoption 布局选项
- 方法 ：GUILayout.Button("文本",[guilayoutoption])
- 使用示例：
```cs
GUILayout.Button("确定",guilayout.width(300),guilayout.height(200),...)
```
- 更多：
```cs
    //方法 ：GUILayout.Button("确定",[guilayoutoption])
    //
    //控件的固定宽高
    guilayout.width(300);
    guilayout.height(200);
    //允许控件的最小宽高
    guilayout.minwidth(50);
    guilayout.minheight(50);
    //允许控件的最大宽高
    guilayout.maxwidth(100);
    guilayout.maxheight(100);
    //允许或禁止水平拓展
    guilayout.expandwidth(true);//允许
    guilayout.expandheight(false);//禁止
    guilayout.expandheight(true);//允许
    guilayout.expandheight(false);//禁止
```

6. 创建一个GUI窗口
```cs
    [MenuItem("Unity编辑器拓展/Lesson3/EditorGUI窗口")]
    private static void OpenLesson3()
    {
        Lesson3 win = EditorWindow.GetWindow<Lesson3>("EditorGUI窗口");
        //win.titleContent = new GUIContent("EditorGUI窗口"); 
        win.Show();
    }
```

## 1.2 EditorGUI是什么？
1. EditorGUI 类似 GUI，是一个主要用于绘制编辑器拓展 UI 的工具类
   - 它提供了一些 GUI 中没有的API，主要是 编辑器功能中会用到的一些特殊控件
2. 而EditorGUILayout 类似于 GUILayout，是一个**带有自动布局功能的** EditorGUI 绘制工具类

3. 我们经常会将 EditorGUI 和 GUI 混合使用 来制作一些编辑器拓展功能
    - 但是由于更多时候我们会用到自动布局功能
    - 因此着重学习 EditorGUILayout 中的功能
4. EditorGUI和EditorGUILayout的区别仅仅是需要自己设置位置而已

5. 更多详细内容：https://docs.unity.cn/cn/2022.3/ScriptReference/EditorGUILayout.html