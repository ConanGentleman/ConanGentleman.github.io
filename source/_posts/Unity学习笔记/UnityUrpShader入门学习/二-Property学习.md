---
title: UnityUrpShader入门学习-（二）Property学习
date: 2026-03-07 21:26:41
tags: Unity Shader
categories: Unity学习笔记
---

Property学习

<!--more-->

# 一、Property属性块的基本用法

## 1.1 先声明
1. 现在Properties中声明变量
```c
Properties  //通过材质面板传入的属性 
	{
		_MainColor("Main Color",Color) = (1,1,1, 1) //声明 Color类型变量并初始化
		_ColorIntensity("Color Intensity",Range(0,1)) = 1 //声明float类型变量并初始化为1 ,"Color Intensity"代表在unity面板中的显示名字
		_MainTex("Main Texture",2d) = "white"{} //声明 贴图类型并初始化为白色的纯色贴图
	}
```
## 1.2 再定义
```c
Subshader{
    pass{
        float _ColorIntensity;//先定义，才能使用Properties中的属性（由Unity引擎传入）
        float4 _MainColor; //先定义，才能使用Properties中的属性（由Unity引擎传入,同事也会负责将Color类型的变量转换为HLSL中的float4类型的变量）
		TEXTURE2D(_MainTex); //定义2d纹理，处理2D纹理以外 还有3d和立方体纹理
		SAMPLER(sampler_MainRex); //纹理采样器
    }
}
```

## 1.3 再使用
```c
Subshader{
    pass{
        //顶点着色器的输出结果就是片元着色器的输入信息
        float4 frag(v2f IN) :SV_TARGET//片元着色器，返回一个RGBA颜色结果
        {
            float4 mainTexColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex,IN.uv);//取得每个点的纹理坐标颜色
            return mainTexColor * _MainColor * _ColorIntensity;
        }
    }
}
```

## 1.4 整体代码
```C
Shader "StudyShader/BasicShader" //shaders中所在路径
{
	Properties  //通过材质面板传入的属性 
	{
		_MainColor("Main Color",Color) = (1,1,1, 1) //声明 Color类型变量并初始化
		_ColorIntensity("Color Intensity",Range(0,1)) = 1 //声明float类型变量并初始化为1 ,"Color Intensity"代表在unity面板中的显示名字
		_MainTex("Main Texture",2d) = "white"{} //声明 贴图类型并初始化为白色的纯色贴图
	}

	//Subshader 表示 子着色器 不同的电脑有不同的配置，也需要有相应版本的着色器，因此不同配置就可以基于不同的子着色器

	Subshader // 子着色器 (高配，红色）
	{
		LOD 600
		pass //一个着色器一般是多次渲染构成的（如二次元渲染，先渲染轮廓，然后渲染本体），pass则代表每次渲染
		{
			HLSLPROGRAM//基于URP管线的编程语言HLSL编写需要加上宏定义，不然会报错

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl" //urp管线的一些基本的函数功能都在Core.hlsl中

			//所有发给引擎的提示信息通过#pragma指令来发出通知的，因此需要加上 #pragma
			#pragma vertex vert //声明顶点着色器 (函数），将顶点从三维空间转换到投影空间
			#pragma fragment frag //声明片元着色器 (函数）：顶点构成的三角形内部的每个显示在屏幕上的像素的着色

			float _ColorIntensity;//先定义，才能使用Properties中的属性（由Unity引擎传入）
			float4 _MainColor; //先定义，才能使用Properties中的属性（由Unity引擎传入,同事也会负责将Color类型的变量转换为HLSL中的float4类型的变量）
			TEXTURE2D(_MainTex); //定义2d纹理，处理2D纹理以外 还有3d和立方体纹理
			SAMPLER(sampler_MainTex); //纹理采样器

			struct appdata {//声明传入的顶点数据
				// 字段类型 字段名称 : 字段语义
				float3 pos : POSITION;//位置  (  :POSITION 表示标记传入位置信息
				float2 uv:TEXCOORD0;//用于确定贴图跟立方体每个面上每个点之间的映射关系
			}; 

			struct v2f { //声明顶点转换到片元着色器的一些像素信息数据
				float4 pos : SV_POSITION; //因为包含投影信息，所以是float4。 （: SV_POSITION表示输出位置
				float2 uv:TEXCOORD0;
			};

			v2f vert(appdata IN) //顶点着色器，传入数据声明变量名为IN
			{
				v2f OUT = (v2f)0; //初始化输出数据为0

				OUT.pos = mul(UNITY_MATRIX_MVP, float4(IN.pos, 1)); //使用Core.hlsl中的矩阵运算，将传入顶点的位置（先拓展到4维向量float4(IN.pos,1)）信息变换到处于投影空间中的位置信息

				OUT.uv = IN.uv; //顶点数据，传到片元数据中

				return OUT;
			}

			//顶点着色器的输出结果就是片元着色器的输入信息
			float4 frag(v2f IN) :SV_TARGET//片元着色器，返回一个RGBA颜色结果
			{
				float4 mainTexColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex,IN.uv);//取得每个点的纹理坐标颜色
				return mainTexColor * _MainColor * _ColorIntensity;
			}

			 ENDHLSL//基于URP管线的编程语言HLSL编写需要加上宏定义，不然会报错
		}
	}

    Fallback "Hidden/Universal Render Pipeline/FallbackError"
}
```


## 1.4 效果
![](./二-Property学习/2.1%20Property基本用法.png)


# 二、Property属性块的脚本传参方式
## 1.1 material 字段
- 只改变挂载的物体的shader属性，且只在运行时有用
- 因此如果两个物体都挂载此脚本，则互不干扰其材质
```cs
Material mat = GetComponent<MeshRenderer>().material; //只改变挂载的物体的shader属性，且只在运行时修改
mat.SetColor("_MainColor", Color.red);
```

## 1.2 sharedMaterial 字段
- 改变所有使用该shader的物体的shader属性，且是永久性的修改，运行结束后，shader也被修改了
- 因此如果两个物体都使用了相同的shader，则运行时及运行后，两个物体的材质属性都修改为了运行时的状态
```cs
Material mat = GetComponent<MeshRenderer>().sharedMaterial; //改变所有使用该shader的物体的shader属性,且是永久性的修改（运行结束后，shader也被修改了）
mat.SetColor("_MainColor", Color.red);
```

## 1.3 多个不同颜色的shader手动处理方式
如果不想通过代码修改不用物体的材质颜色，则复制一份材质，将物体修改为复制后的材质，修改材质颜色

## 1.4 动态修改纹理图
1. 创建一个渲染纹理（这里用相机拍的照片） ，资源文件夹右键->Create->Render Texture，命名为MainSceneRT
2. 场景新建一个Camera，命名为MainSceneRTCamera，将MainSceneRT拖拽到MainSceneRTCamera下的Output的Output Texture上
3. 修改代码
```cs
    public Texture mainSceneRT;
    // Start is called before the first frame update
    void Start()
    {
        Material mat = GetComponent<MeshRenderer>().material; //只改变挂载的物体的shader属性，且只在运行时修改
        mat.SetTexture("_MainTex", mainSceneRT);
    }
```
4. MainSceneRT资源拖拽到脚本上mainSceneRT处

## 1.5 同时改变不同shader的属性，且不用将脚本挂载在物体上
- 使用 Shader.SetGlobalFloat("属性名",数值)
- 使用时需要将shader中原有的在property中定义的属性名给删掉，不然会报错
- **运行结束后，不会恢复原本的属性，保持运行时的属性**
![](./二-Property学习/2.2%20Property脚本传参方法全局设置.png)


## 1.5 效果
1. 使用material字段，两个物体颜色互补影响
![](./二-Property学习/2.2%20Property脚本传参方法.png)
2. 使用sharedMaterial字段，两个物体颜色被统一了，并且结束运行后，材质的颜色也被修改了
![](./二-Property学习/2.2%20Property脚本传参方法shared.png)
![](./二-Property学习/2.2%20Property脚本传参方法shared1.png)
3. 动态修改纹理图效果
![](./二-Property学习/2.2%20Property脚本传参方法纹理传参.png)