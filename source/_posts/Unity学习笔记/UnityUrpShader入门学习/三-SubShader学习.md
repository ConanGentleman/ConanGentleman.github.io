---
title: UnityUrpShader入门学习-（三）SubShader学习
date: 2026-03-07 21:26:58
tags: Unity Shader
categories: Unity学习笔记
---


SubShader学习

<!--more-->
# 一、什么是Tags
- 用于Unity读取以便知道该subshader的主要目的是什么
- tag的格式 "tag名称" = "tag的值"
# 二、SubShader Tag: RenderPipeline渲染管线
用途：让subshader以何种渲染管线渲染。

## 2.1 格式
```c
Subshader // 子着色器 (高配，红色）
{
    Tags
    {
        "RenderPipeline" = "xxx"
    }
}
```

## 2.2 RenderPipeline类型
- 对于内置管线的shader可以不填该项
- urp的话需填写UniversalPipeline
- 高清渲染管线则为HDRenderPipeline

## 2.3 Unity的RenderPipeline设置
设置在Project Setting/Graphics/ScriptableRenderPipelineSettings 和 Project Setting/QualityRendering/RenderPipelineAsset(点击Levels切换) 当后者不为None时，会覆盖前者的设置

## 2.4 不同RenderPipeline类型的SubShader
当有多个不同的subshader时，按顺序从上到下执行subshader，如果subshader的tag的renderpipeline与当前Unity的RenderPipeline设置匹配则执行该subshader，且后面的subshader就不再执行了。
一般可以把不设置 RenderPipeline的subshader作为备选（内置管线）写在最后

# 三、SubShader Tag: Queue 队列

## 3.1 介绍
- 用途：引擎用于确定对象何时渲染
- 可以在材质上重载（材质>属性面板>渲染队列）

## 3.2 值大小渲染规则
- 队列值 <= 2500 
  - 为不透明队列
  - 从前到后渲染（教靠近相机的对象首先渲染）
- 队列值 > 2500
  - 透明队列
  - 从后到前渲染（首先渲染较远的对象）
  - 由于透明着色器往往不适用深度测试/写入，因此更改队列将更改着色器与其他透明对象的排序方式
  
## 3.3 一些Unity引擎约定的queue类型
- Background(1000) 背景层对象
- Geometry(2000) 完全不透明物体
- AlphaTest(2450) 物体表面贴图有部分透明的  （如叶子贴图，有部分就是透明的）
- Transparent(3000) 半透明对象（窗户、玻璃瓶
- Overlay(4000)

## 3.4 格式
- "Queue" = "queue类型+增量"
```c
Subshader // 子着色器 (高配，红色）
{
    Tags
    {
        "Queue" = "Geometry+1" //设置后 材质上的RenderQueue设置为了2000 + 1 = 2001
    }
}
```

## 3.5 如何查看渲染顺序
运行Unity->Unity菜单栏->Window->analysis->Frame Debug
- DrawOpequeObjects 不透明物体
- DrawTransparentObjects 半透明物体
![](./三-SubShader学习/3.3%20tag中的Queue.png)