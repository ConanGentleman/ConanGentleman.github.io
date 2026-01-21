---
title: Unity编辑器拓展（九）-EditorUtility公共类
date: 2025-12-09 22:03:53
tags: Unity编辑器拓展
categories: Unity学习笔记
---

Unity编辑器拓展（九）-EditorUtility公共类 学习笔记

<!--more-->
# 一、EditorUtility是什么
## 1.0 之前知识
1. 自定义菜单栏拓展
2. 自定义窗口拓展
3. EditorGUI、EditorGUIUtility相关
4. Selection公共类
5. Event公共类
6. Inspector窗口拓展
7. Scene窗口拓展（Handles公共类、HandleUtility公共类、Gizmos公共类）
## 1.1 知识点一 EditorUtility公共类是用来做什么的？
- 它是 Unity 编辑器中的一个实用工具类
- 提供了一系列用于编辑器脚本和自定义编辑器的实用功能

## 1.2 #region 知识点二 在哪里使用EditorUtility公共类中的相关内容
- 在编辑器相关处都可以使用EditorUtility公共类中的相关内容
- 它主要提供的是一些辅助功能，可以在编辑器拓展开发的任意地方使用
- 但一定注意，**它属于编辑器功能，无法被打包出去**，只能在Unity编辑器中使用

## 1.3 #region 知识点三 准备工作
- EditorUtility可以在任何编辑器功能开发时使用
- 但是为了之后的知识点理解更方便
- 下文通过一个自定义窗口来进行举例（代码对应Lesson38.cs-继承了EditorWindow）
```cs
public class Lesson38 : EditorWindow
{
    [MenuItem("Unity编辑器拓展/Lesson38/EditorUtility知识讲解")]
    private static void OpenLesson38Win()
    {
        Lesson38 win = EditorWindow.GetWindow<Lesson38>("EditorUtility知识讲解");
        win.Show();
    }
}
```

# 二、 EditorUtility类中的 编辑器默认窗口相关
## 2.1 知识点一 显示提示窗口
- 注意：窗口显示会阻塞逻辑
```cs
EditorUtility.DisplayDialog("标题", "显示信息", "确定键名");
```

## 2.2 知识点二 显示三键提示面板
- 注意：窗口显示会阻塞逻辑
- 返回值 0-按钮1按下 1-按钮3按下 2-按钮2按下
```cs
int EditorUtility.DisplayDialogComplex("标题", "显示信息", "按钮1名字", "按钮3名字", "按钮2名字");
```
#endregion

## 2.3 知识点三 进度条相关
- 显示进度条
EditorUtility.DisplayProgressBar("进度条", "显示信息", 进制值0~1);
- 关闭进度条
EditorUtility.ClearProgressBar();

- 注意：进度条窗口不会卡逻辑，但是需要配合关闭进度条使用

## 2.4 代码示例
```cs
    private float value;
    private void OnGUI()
    {
        #region Lesson39 编辑器默认窗口相关
        if (GUILayout.Button("显示提示窗口"))
        {
            if (EditorUtility.DisplayDialog("测试窗口", "确定一定要做这件事情吗", "一定要做"))
            {
                Debug.Log("确定要做，在这里去处理逻辑");
            }
            else
            {
                Debug.Log("点击了叉叉，不去做");
            }

            Debug.Log("窗口显示完毕");
        }

        if (GUILayout.Button("显示三键提示窗口"))
        {
            int result = EditorUtility.DisplayDialogComplex("三键提示", "显示信息", "选项1", "关闭", "选项2");
            switch (result)
            {
                case 0:
                    Debug.Log("选项1按下了");
                    break;
                case 1:
                    Debug.Log("关闭键按下了");
                    break;
                case 2:
                    Debug.Log("选项2按下了");
                    break;
                default:
                    break;
            }

            Debug.Log("三键窗口显示完毕");
        }

        if (GUILayout.Button("显示更新进度条"))
        {
            value += 0.1f;
            EditorUtility.DisplayProgressBar("进度条标题", "进度条窗口显示内容", value);
            Debug.Log("进度条窗口显示完毕");
        }

        if (GUILayout.Button("关闭进度条"))
        {
            value = 0;
            EditorUtility.ClearProgressBar();
        }

        #endregion
```

## 2.5 效果
1. 显示提示窗口
![](./九-EditorUtility公共类/L39EditorUtility类中的编辑器默认窗口相关-显示提示窗口.png)
2. 显示三键提示窗口
![](./九-EditorUtility公共类/L39EditorUtility类中的编辑器默认窗口相关-三键提示.png)
3. 显示更新进度条
![](./九-EditorUtility公共类/L39EditorUtility类中的编辑器默认窗口相关-进度条.png)


# 三、EditorUtility类中的 文件面板相关
## 3.1 知识点一 显示 文件 存储面板
- 通常用于在编辑器中保存新创建的文件或选择文件的保存路径
```cs
string path = EditorUtility.SaveFilePanel("窗口标题", "打开的目录", "保存的文件的名称", "文后缀格式")
```
## 3.2 显示 文件 存储面板(默认指定在Asset文件夹中)
- 与 SaveFilePanel 类似，但是它将保存路径限制在项目目录中，只允许用户选择项目内的文件夹作为保存路径。“在对话框窗口中显示的文本摘要”，window下可能无法显示，其他操作系统下可能显示
```cs
string path = EditorUtility.SaveFilePanelInProject("窗口标题", "保存的文件的名称", "后缀格式", "在对话框窗口中显示的文本摘要");
```

## 3.3 知识点三 显示 文件夹 存储面板
- 通常用于在编辑器中选择文件夹作为保存路径，用于保存文件或执行其他与文件夹相关的操作
```cs
string path = EditorUtility.SaveFolderPanel("窗口标题", "文件夹", "默认名称");
```

## 3.4 知识点四 显示打开 文件 面板
- 通常用于在编辑器中选择文件进行打开或执行其他与文件相关的操作
```cs
string path = EditorUtility.OpenFilePanel("窗口标题", "文件路径", "后缀格式");
```

## 3.5 知识点五 显示打开 文件夹 面板
- 通常用于在编辑器中选择文件夹进行打开或执行其他与文件夹相关的操作
```cs
string path = EditorUtility.OpenFolderPanel("窗口标题", "文件夹", "默认名称");
```

## 3.6 代码
```cs
using System.IO;
private void OnGUI()
{
    //1.显示文件存储面板
    if (GUILayout.Button("打开文件存储面板"))
    {
        string str = EditorUtility.SaveFilePanel("保存我的文件", Application.dataPath, "Test", "txt");
        Debug.Log(str);
        if (str != "")
            File.WriteAllText(str, "123123123123123");
    }
    //2.显示文件存储面板（默认为工程目录中）
    if (GUILayout.Button("打开文件存储面板（仅限工程文件夹下）"))
    {
        //最后一个 “自定义文件”字符串表示保存文件后的提示，window下可能无法显示，其他操作系统下可能显示
        string str2 = EditorUtility.SaveFilePanelInProject("保存项目内的文件", "Test2", "png", "自定义文件");
        Debug.Log(str2);
    }
    //3.显示文件夹存储面板
    if (GUILayout.Button("显示文件夹存储面板"))
    {
        string str3 = EditorUtility.SaveFolderPanel("得到一个存储路径（文件夹）", Application.dataPath, "");
        Debug.Log(str3);
    }

    //4.显示打开文件面板
    if (GUILayout.Button("显示打开文件面板"))
    {
        string str4 = EditorUtility.OpenFilePanel("得到一个文件路径", Application.dataPath, "txt");
        if (str4 != "")
        {
            string txt = File.ReadAllText(str4);
            Debug.Log(txt);
        }
    }

    //5.显示打开文件夹面板
    if (GUILayout.Button("显示打开文件夹面板"))
    {
        string str4 = EditorUtility.OpenFolderPanel("得到一个文件路径", Application.dataPath, "");
        if (str4 != "")
        {
            Debug.Log(str4);
        }
    }
}
```


## 3.7 效果
![](./九-EditorUtility公共类/L40EditorUtility类中的%20文件面板相关1.png)
![](./九-EditorUtility公共类/L40EditorUtility类中的%20文件面板相关2.png)
![](./九-EditorUtility公共类/L40EditorUtility类中的%20文件面板相关3.png)
![](./九-EditorUtility公共类/L40EditorUtility类中的%20文件面板相关4.png)
![](./九-EditorUtility公共类/L40EditorUtility类中的%20文件面板相关5.png)



# 四、EditorGUILayout中的 其他内容
## 4.1 知识点一 压缩纹理
- 可以将纹理显式压缩为指定的格式
- 该知识点会配合之后的资源导入相关知识点使用
```cs
void EditorUtility.CompressTexture(Texture2D texture, TextureFormat format, TextureCompressionQuality quality);
```
## 4.2  知识点二 查找对象依赖项
```cs
object[] EditorUtility.CollectDependencies(Object[] roots);
```

## 4.3 代码
```cs
private GameObject objTest1;
private void OnGUI()
{
    objTest1 = EditorGUILayout.ObjectField("想要查找关联资源的对象", objTest1, typeof(GameObject), true) as GameObject;
    if (GUILayout.Button("检索依赖资源"))
    {
        Object[] objs = EditorUtility.CollectDependencies(new Object[] { objTest1 });
        Selection.objects = objs;
    }
}
```
## 4.4 效果
![](./九-EditorUtility公共类/L41EditorGUILayout中的%20其他内容.png)
![](./九-EditorUtility公共类/L41EditorGUILayout中的%20其他内容1.png)

## 4.5 知识点三 更多内容
https://docs.unity3d.com/ScriptReference/EditorUtility.html