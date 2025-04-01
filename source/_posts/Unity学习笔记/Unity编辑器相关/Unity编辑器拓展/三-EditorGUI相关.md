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


# 二、文本、层级和标签、颜色拾取控件
## 2.1 EditorGUILayout中的文本控件
1. 方法
```CS
    EditorGUILayout.LabelField("文本标题", "文本内容");
```
2. 示例
```CS
    int layer;
    string tag;
    Color color;
    //文本控件
    EditorGUILayout.LabelField("文本标题", "测试内容");
    EditorGUILayout.LabelField("文本内容");
```
## 2.2 EditorGUILayout中的层级、标签选择
1. 方法
```CS
//Layer
    int变量 = EditorGUILayout.LayerField("层级选择", int变量);
//Tag
    string变量 = EditorGUILayout.TagField("标签选择", string变量);
```
2. 示例
```cs
    //层级标签控件
    //layer = EditorGUILayout.LayerField(layer); //这样写就只会有个下拉框,没有说明文本
    layer = EditorGUILayout.LayerField("层级选择", layer);
    //tag = EditorGUILayout.TagField(tag); //这样写就只会有个下拉框,没有说明文本
    tag = EditorGUILayout.TagField("标签选择", tag);
```
## 2.3 EditorGUILayout中的颜色获取
1. 方法
```CS
    color变量 = EditorGUILayout.ColorField(new GUIContent("标题"),color变量, 是否显示拾色器, 是否显示透明度通道, 是否支持HDR);
```
2. 示例
```cs
    //颜色获取控件
    color = EditorGUILayout.ColorField(new GUIContent("自定义颜色获取"), color, true, false, false);
```

# 2.4 效果展示

![](./三-EditorGUI相关/文本、层级和标签、颜色拾取控件%20效果.png)


# 三、枚举选择、整数选择、按下就触发的按钮

## 3.1 枚举选择控件
1. 枚举选择（方法）
```cs
//  枚举变量 = (枚举类型)EditorGUILayout.EnumPopup("枚举选择", 枚举变量);
```
2. 多选枚举（方法）
注意：**多选枚举进行的是或运算**，声明枚举时一定注意其中的赋值，并且一定要有多种情况的搭配值）,**即如果是多选枚举，需要给每个不同的枚举要赋值为2的次方**
```cs
//  枚举变量 = (枚举类型)EditorGUILayout.EnumFlagsField("枚举多选", 枚举变量);
```
3. 示例
```cs
public enum E_TestType
{
    One = 1,
    Two = 2,
    Three = 4,
    One_and_Two = 1 | 2,
}
E_TestType type;
E_TestType type2;

string[] strs = { "选择123", "选择234", "选择345" };
int[] ints = { 123, 234, 345 };
int num = 0;

 //枚举选择
type = (E_TestType)EditorGUILayout.EnumPopup("枚举选择", type);

type2 = (E_TestType)EditorGUILayout.EnumFlagsField("枚举多选", type2);
```
## 3.2 整数选择控件
1. 方法
```cs
int变量 = EditorGUILayout.IntPopup("整数单选框", int变量, 字符串数组, int数组);
```
2. 示例
```cs
//整数选择控件
//返回值 其实是整数数组当中的某一个值
num = EditorGUILayout.IntPopup("整数单选框", num, strs, ints);
EditorGUILayout.LabelField(num.ToString());
```
## 3.3 按下就触发的按钮控件

1. 方法
```cs
//EditorGUILayout.DropdownButton(new GUIContent("按钮上文字"), FocusType.Passive)
```
2. 参数的类型：
- FocusType枚举时告诉UI系统能够获得键盘焦点 当用户按Tab键时在控件之间进行切换
- Keyboard	该控件可接收键盘焦点。
- Passive 该控件不能接收键盘焦点。

3. 示例
```cs
//按下就响应的按钮
if (EditorGUILayout.DropdownButton(new GUIContent("按钮上文字"), FocusType.Passive))
    Debug.Log("按下就响应");
```
## 3.4 效果

![](./三-EditorGUI相关/L5枚举选择、整数选择、按下就触发的按钮.png)