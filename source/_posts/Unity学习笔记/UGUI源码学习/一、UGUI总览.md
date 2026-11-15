---
title: UGUI源码学习-总览
date: 2026-10-22 23:48:41
tags: Unity UGUI源码
categories: Unity学习笔记
---

UGUI源码学习-总览
<!--more-->
<!--hexo new post -p Unity学习笔记\UGUI源码学习\-->

# 前言
Unity UGUI（Unity User Interface，也称 Unity UI 软件包）是 Unity 引擎中一个基于游戏对象（GameObject）的、用于开发运行时游戏界面（UI）的成熟系统。你游戏里的血条、按钮、菜单、背包界面等，绝大多数都是用 UGUI 制作的。 虽然UGUI使用简单，但是作为一名游戏开发者来说，更应该了解其原理，方便对其进行拓展和优化

本文将深入UGUI底层，从源码角度分析其实现

# 参考资料
- 本文章使用的UGUI源码来自2022.3.1unity版本中的Package Manager->Unity UI。
  - 当然你也可以使用官方的开源地址独立的UGUI：https://github.com/Unity-Technologies/uGUI 但写该帖子时发现其版本较新目前应该是到Unity 6+了，目前网上的UGUI资料
  - 因此 推荐直接在你使用的 Unity 2021 或 2022 LTS 编辑器的 Packages 目录下，找到 Unity UI (即 com.unity.ugui) 包来阅读
- 本系列文章也参考了许多已有的 UGUI 源码解析文章，如：
  - https://blog.csdn.net/qq_28820675/article/details/105619250。
  - https://qlipphoth.github.io/2024/08/05/2024-8-5-1/index.html 这个对上面的链接文章做了一定的汇总，总结的非常到位
- 还有官方的文档来进行学习
  - UGUI: https://docs.unity.cn/Packages/com.unity.ugui@1.0/manual/index.html
  - Unity 手册：https://docs.unity.cn/cn/2021.3/Manual/com.unity.ugui.html

# 总览
找AI帮忙生成了一张UGUI整体的总览图
![](./一、UGUI总览/1.1%20源码总览.png)
但我感觉按上面文章提供总览图，源码看起来会更加的清晰
![](./一、UGUI总览/1.1%20源码总览-结构.png)
从宏观上看，源码大致可以划分为几个部分。
- **基础框架——UIBehaviour**
  - 所有UGUI的公共基类
- **渲染更新系统：Graphic & CanvasUpdateSystem**
  - Graphic 标脏，脏标记（Dirty）的发起者
  - CanvasUpdateSystem 处理脏元素，委会布局重建和图形重建
- **事件处理系统： EventSystem & 输入模块**
  - EventSystem：每帧处理输入和射线检测
  - 输入与射线模块
  - 事件数据与派发
- **布局系统：LayoutSystem**
  - 负责UI元素的自适应排列
- **交互组件：Selectable 及具体实现**
  - 基于事件系统构建的可交互UI组件层。
  
# 文章索引
1. [UIBehaviour](/2026/10/25/Unity学习笔记-UGUI源码学习-一、UIBehaviour)
2. EventSystem
- [EventSystem]()