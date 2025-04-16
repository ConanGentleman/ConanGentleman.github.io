---
title: Unity编辑器拓展（四）--EditorGUIUtility公共类
date: 2025-04-15 22:44:03
tags: Unity编辑器拓展
categories: Unity学习笔记
---

EditorGUIUtility公共类相关内容
 
<!--more-->

# 一、EditorGUIUtility公共类的作用是什么
- Utility是实用的意思，EditorGUIUtility 是 EditorGUI 中的一个实用工具类
- 提供了一些 EditorGUI 相关的其他辅助API
- 本文只学习其中的相对常用的内容
官方文档：https://docs.unity3d.com/ScriptReference/EditorGUIUtility.html

# 二、资源加载
## 2.1 Editor Default Resources文件夹
- **Editor Default Resources** 也是Unity当中的一个特殊文件夹，**它的主要作用是放置提供给 EditorGUIUtility 加载的资源**
- 想要使用EditorGUIUtility公共类来加载资源
- **我们需要将资源放置在 Editor Default Resources 文件夹中**
  
## 2.2 加载资源（如果资源不存在返回null）
1. 方法
**注意事项：**
- 只能加载Assets/Editor Default Resources/文件夹下的资源
- 加载资源时，**需要填写资源后缀名**
```cs
//对应API：
EditorGUIUtility.Load
```
2. 示例
```cs
    //加载资源（如果资源不存在返回null)
    if (GUILayout.Button("加载编辑器图片资源"))
        img = EditorGUIUtility.Load("EditorTeach.png") as Texture;
    if (img != null)
        GUI.DrawTexture(new Rect(0, 50, 160, 90), img); //显示图片
```

## 2.3 加载资源（如果资源不存在会直接报错）
1. 方法

**注意事项：**
- 只能加载Assets/Editor Default Resources/文件夹下的资源
- 加载资源时，需要填写资源后缀名

```cs
//对应API：
EditorGUIUtility.LoadRequired
```

2. 示例
```cs
    //加载资源（如果资源不存在会直接报错）
    if (GUILayout.Button("加载编辑器图片资源"))
        img2 = EditorGUIUtility.LoadRequired("EditorTeach.png") as Texture;
    if (img2 != null)
        GUI.DrawTexture(new Rect(0, 150, 160, 90), img2); //显示图片
```

## 2.3 效果
![](./四-EditorGUIUtility公共类/L13加载资源.png)