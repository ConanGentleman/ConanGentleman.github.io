---
title: Unity编辑器拓展（六）-Event公共类
date: 2025-04-26 23:03:00
tags: Unity编辑器拓展
categories: Unity学习笔记
---

Event公共类相关内容
<!--more-->

# 一、Event公共类是用来做什么的？
- 它提供了许多属性和方法，允许你检查和处理用户输入
- 主要用于在Unity编辑器拓展开发中
- 因为**Input相关内容需要在运行时才能监听输入**
- 而**Event专门提供给编辑模式下使用，可以帮助我们检测鼠标键盘输入等事件相关操作**
- 在 **OnGUI 和 OnSceneView 中都能使用**

# 二、 重要API
1. 获取当前输入事件
```cs
    Event.current
```
2. alt键是否按下
```cs
    Event.current.alt
```
3. shift键是否按下
```cs
    Event.current.shift
```
4. ctrl键是否按下
```cs    
    Event.current.control
```
5. 是否是鼠标事件
```cs
    Event.current.isMouse
```
6. 判断鼠标左中右键
```cs
    Evnet.current.button (0,1,2 分别代表 左,右,中 如果大于2可能是其他鼠标按键)
```

7. 鼠标位置
```cs
    Event.curretn.mousePosition
```
8. 判断是否是键盘输入
```cs
    Event.current.isKey
```
9. 获取键盘输入的字符
```cs
  Event.current.character
```
10. 获取键盘输入对应的KeyCode
```cs
    Event.current.keyCode
```
11. 判断输入类型
```cs
    Event.current.type
    EventType枚举和它比较即可
    EventType中有常用的 鼠标按下抬起拖拽，键盘按下抬起等等类型
```
12. 是否锁定大写 对应键盘上caps键是否开启
```cs
    Event.current.capsLock
```
13. Windows键或Command键是否按下
```cs
    Event.current.command
```
14. 键盘事件 字符串
```cs
    Event.current.commandName
```
- 可以用来判断是否触发了对应的键盘事件
- 返回值：
    - Copy:拷贝
    - Paste:粘贴
    - Cut:剪切

15. 鼠标间隔移动距离
```cs
    Event.current.delta
```
16. 是否是功能键输入
- 功能键指小键盘中的 方向键, page up, page down, backspace等等
```cs
    Event.current.functionKey
```

17. 小键盘是否开启
```cs
    Event.current.numeric
```
18. 避免组合键冲突
- 在处理完对应输入事件后，调用该方法，可以阻止事件继续派发，放置和Unity其他编辑器事件逻辑冲突
```cs
    Event.current.Use()
```
# 三、 API使用示例
```cs
    //1.获取当前事件
    //  Event.current
    Event eve = Event.current;

    //2.alt键是否按下
    //  Event.current.alt
    if (eve.alt)
        Debug.Log("alt键按下了");

    //3.shift键是否按下
    //  Event.current.shift
    if (eve.shift)
        Debug.Log("shift键按下了");

    //4.ctrl键是否按下
    //  Event.current.control
    if (eve.control)
        Debug.Log("control键按下了");

    //5.是否是鼠标事件
    //  Event.current.isMouse
    if (eve.isMouse)
    {
        Debug.Log("鼠标相关事件");
        //6.判断鼠标左中右键
        //  Event.current.button (0,1,2 分别代表 左,右,中 如果大于2可能是其他鼠标按键)
        Debug.Log(eve.button);
        //7.鼠标位置
        //  Event.current.mousePosition
        Debug.Log("鼠标位置" + eve.mousePosition);
    }

    //8.判断是否是键盘输入
    //  Event.current.isKey
    if(eve.isKey)
    {
        Debug.Log("键盘相关事件");
        //9.获取键盘输入的字符
        //  Event.current.character
        Debug.Log(eve.character);
        //10.获取键盘输入对应的KeyCode
        //  Event.current.keyCode
        //Debug.Log(eve.keyCode);
        switch (eve.keyCode)
        {
            case KeyCode.Space:
                Debug.Log("空格键输入");
                break;
        }
    }

    //11.判断输入类型
    //  Event.current.type
    //  EventType枚举和它比较即可
    //  EventType中有常用的 鼠标按下抬起拖拽，键盘按下抬起等等类型
    //  一般会配合它 来判断 比如 键盘 鼠标的抬起按下相关的操作

    //12.是否锁定大写 对应键盘上caps键是否开启
    //  Event.current.capsLock
    if (eve.capsLock)
        Debug.Log("大小写锁定开启");
    else
        Debug.Log("大小写锁定关闭");

    //13.Windows键或Command键是否按下
    //  Event.current.command
    if (eve.command)
        Debug.Log("PC win键按下 或 Mac Command键按下");

    //14.键盘事件 字符串
    //  Event.current.commandName
    //  可以用来判断是否触发了对应的键盘事件
    //  返回值：
    //  Copy:拷贝
    //  Paste:粘贴
    //  Cut:剪切
    if(eve.commandName == "Copy")
    {
        Debug.Log("按下了ctrl + c");
    }
    if (eve.commandName == "Paste")
    {
        Debug.Log("按下了ctrl + v");
    }
    if (eve.commandName == "Cut")
    {
        Debug.Log("按下了ctrl + x");
    }

    //15.鼠标间隔移动距离
    //  Event.current.delta

    //Debug.Log(eve.delta);

    //16.是否是功能键输入
    //  Event.current.functionKey
    //  功能键指小键盘中的 方向键, page up, page down, backspace等等
    if (eve.functionKey)
        Debug.Log("有功能按键输入");

    //17.小键盘是否开启
    //  Event.current.numeric
    if(eve.numeric)
        Debug.Log("小键盘是否开启");

    //18.避免组合键冲突
    //  Event.current.Use()
    //  在处理完对应输入事件后，调用该方法，可以阻止事件继续派发，防止和Unity其他编辑器事件逻辑冲突
    eve.Use();
```

# 五、 更多内容
https://docs.unity3d.com/ScriptReference/Event.html