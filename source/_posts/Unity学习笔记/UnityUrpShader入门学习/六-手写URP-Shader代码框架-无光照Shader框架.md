---
title: UnityUrpShader入门学习-（六）手写URP-Shader代码框架-无光照Shader框架
date: 2026-10-11 23:18:08
tags: Unity Shader
categories: Unity学习笔记
---


手写URP-Shader代码框架-无光照Shader框架
<!--more-->

# 一、Unlit Shader Framework（书写整体框架）
一个框架需要有下面的整体框架外，还需要支持：
1. 透明剔除
2. 提出模式选择
3. 阴影渲染
4. 支持Depth Priming选项

## 1.1 整体代码结构如下
1. 创建一个unity新场景basic (URP)
2. 创建一个unlit shader (命名为ShaderFramework)
3. 写好shader后右键create->material
4. 然后拖拽到场景中的某个物体上
![](./六-手写URP-Shader代码框架-无光照Shader框架/1.%20整体代码结构.png)
```c
Shader "UrpFramework/Unlit"
{
    Properties
    {
        _BaseMap("Base Map",2d) = "white"{} //基本贴图
        _BaseColor("Base Color",Color) = (1,1,1,1) //固有色
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque" //给渲染网格物体分类用的字段
            "Queue" = "Geometry"
        }

        //一些公用的内容
        HLSLINCLUDE
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl" //urp管线的一些基本的函数功能都在Core.hlsl中
            //写入需要被共享的变量
            CBUFFER_START(UnityPerMaterial)
                TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap); float4 _BaseMap_ST;//定义2d纹理、筛选器、ST

                float4  _BaseColor;
            CBUFFER_END
        ENDHLSL

        Pass
        {
            Name "Unlit" //pass名字

            // 不写Tags表示放在SRPDefaultUnlit里

            HLSLPROGRAM

                #pragma vertex UnlitPassVertex //声明顶点着色器 （函数）
                #pragma fragment UnlitPassFragment //声明片元着色器 （函数）

                struct Attributes {//声明传入的顶点数据
                    // 命名规则：pos+（所处坐标空间的）后缀：1. OS - 对象空间 Object Space ；2. WS - 世界空间 World Space；3. VS - 视图空间 View Space；4. CS - 裁剪空间 Clip Space
                    float4 positionOS   :POSITION;//位置  （  :POSITION 表示标记传入位置信息 
                    float2 uv           :TEXCOORD0;//用于确定贴图跟立方体每个面上每个点之间的映射关系 。 TEXCOORD0 会随着版本的不同支持的通道数也会不一样
                    float4 color        :COLOR; //顶点颜色
                };

                struct Varyings { //声明顶点转换到片元着色器的一些像素信息数据（在内置管线中称为 v2f，在urp管线中称为 Varying）
                    float4 positionCS   :SV_POSITION; //因为包含投影信息，所以是float4。 （: SV_POSITION表示输出位置
                    float2 uv           :TEXCOORD0;
                    float4 color        :COLOR; //顶点颜色
                };

                //顶点着色器，传入数据声明变量名为IN
                Varyings UnlitPassVertex(Attributes IN) 
                {
                    Varyings OUT = (Varyings)0; //初始化输出数据为0

                    //计算在各个坐标下顶点位置的函数
                    VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS.xyz);

                    OUT.positionCS = positionInputs.positionCS;
                    OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap); //顶点数据，传到片元数据中
                    OUT.color = IN.color;

                    return OUT;
                }

                //片元着色器 （作用在目标缓冲器，所以定义返回值的语义为SV_TARGET，大小写不敏感）
                half4 UnlitPassFragment(Varyings IN) :SV_TARGET
                {
                    //获取颜色
                    half4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);

                    return baseMap * _BaseColor * IN.color;
                }
            ENDHLSL
        }
            
    }
}

```

# 二、Alpha Test(透明剔除)
1. ShaderFramework创建一个material 命名为Leaf
2. unity场景中新建一个quad
3. 将Leaf拖拽到quad上

## 2.1 透明剔除及代码（⭐）
未进行透明剔除时
![](./六-手写URP-Shader代码框架-无光照Shader框架/6.2%20透明剔除-未剔除.png)
1. 剔除代码：
```c 
if xx 
    discard; //丢弃（剔除）待渲染的片元
```
或
```c
clip(para) //如果para小于零则剔除
```

2. 具体代码
- 方案一 if语句+discard 
  - 缺点：会使渲染流水线产生中断
```c
//片元着色器
half4 UnlitPassFragment(Varyings IN) :SV_TARGET
{
    //获取颜色
    half4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);

    //透明剔除
    if (baseMap.a < 0.5)
        discard;


    return baseMap * _BaseColor * IN.color;
}
```
- 方案二： clip(param) -当param值小于0 则剔除
```c
//片元着色器
half4 UnlitPassFragment(Varyings IN) :SV_TARGET
{
    //获取颜色
    half4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);

    //透明剔除 
    clip(baseMap.a-0.5)

    return baseMap * _BaseColor * IN.color;
}
```
3. 剔除效果
![](./六-手写URP-Shader代码框架-无光照Shader框架/6.2%20透明剔除-已剔除.png)

## 2.2 增加剔除代码开关（变体）
避免同一个shader的不同材质都同时剔除或者不剔除
1. 方法： 变体 配合 #ifdef #endif 使用
```c
Properties
{
    [Toggle(_ALPHATEST_ON)] _AlphaTestToggle("Alhpa Clipping", Float) = 0
    _Cutoff("Alpha Cutoff", Float) = 0.5 //方便剔除的阈值自定义
}

shader
{

    HLSLINCLUDE
        float _Cutoff;
    ENDHLSL

    Pass
    {
        #pragma shader_feature _ALPHATEST_ON //变体开关=> 定义开关后，shader编辑器内部会生成两个版本的代码（一个是定义了_ALPHATEST_ON开关的代码 一个是没定义_ALPHATEST_ON开关的代码），然后Unity打包的时候就会打包两个版本的

        //片元着色器
        half4 UnlitPassFragment(Varyings IN) :SV_TARGET
        {
            //获取颜色
            half4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);

            //透明剔除 两个方法 discard 或者clip
            /*if (baseMap.a < 0.5)
                discard;*/

            #ifdef _ALPHATEST_ON // 是如果定义了 _ALPHATEST_ON 的代码版本，则调用clip
                clip(baseMap.a - _Cutoff);
            #endif

            return baseMap * _BaseColor * IN.color;
        }
    }
}

```
2. 效果
![](./六-手写URP-Shader代码框架-无光照Shader框架/6.2%20剔除变体+自定义阈值.gif)

# 三、Cull Mode(剔除模式)
- 目前树叶背面不可见
![](./六-手写URP-Shader代码框架-无光照Shader框架/6.3%20背面不可见.gif)
## 3.1 设置Cull Mode
方案： Cull xxx
- 使用变量来控制剔除模式
```
Properties
{
    [Enum(Off,0,Front,1,Back,2)]_Cull("Cull Mode", Float) = 2.0 //设置枚举类型。不剔除、正面剔除、背面剔除
}

Pass
{
    Cull [_Cull]
}
```

## 3.2 效果
![](./六-手写URP-Shader代码框架-无光照Shader框架/6.3%20剔除模式.gif)

# 四、阴影渲染
先在unity场景中新建一个Plane
## 4.1 方法1：简单方法
- 最简单的方法就是**直接使用Unity写好阴影的pass**
  - 但是会导致SRP batcher 合批优化失效
```
shader
{
    UsePass "Universal Render Pipeline/Lit/ShadowCaster"
}

```

## 4.2 方法2：新增pass
- 阴影计算比较复杂，作为框架的展示，可以调用unity写好的阴影的顶点着色器和片元着色器
![](./六-手写URP-Shader代码框架-无光照Shader框架/6.3%20shadowcasterpass路径.png)
- 注意
由于之前的代码将下面的内容写入到了HLSLINCLUDE中，但新增的pass中也定义了TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap);，所以不能放到HLSLINCLUDE了。需要单独放到使用该变量的具体pass中，或者换名也可以
```c
TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap); 
```

直接看代码和注释
```c
Pass
{
    Name "ShadowCaster"
    Tags{"LightMode"="ShadowCaster"}

    ZWrite On
    ZTest LEqual

    ColorMask 0 //设置为0表示，在pass执行的过程中，对于计算出的颜色不写入。（只写入深度信息 ZTest LEqual）
    Cull [_Cull] //正面和背面都应该生成阴影 不然默认是背面剔除的话 从背面就看不到阴影了

    HLSLPROGRAM
        
        //材质相关的（一般是加在编写的每一个pass里）
        //加入透明剔除的变体开关,否则不透明的地方也会有阴影
        #pragma shader_feature _ALPHATEST_ON//源码里面也用了同名变体，所以会生效
        #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A //将ALBEDO的通道的a作为一个平滑通道来使用

        #pragma multi_compile_instancing //支持GPU实例化（变体开关，只用在GPU实例化）

        // 阴影相关
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW//仅用在ShadowCaster这个pass中。处理（支持）局部光（点光源/聚光灯）的。变体开关，只用在顶点着色器

        //阴影计算比较复杂，作为框架的展示，可以调用unity写好的阴影的顶点着色器和片元着色器
        #pragma vertex ShadowPassVertex
        #pragma fragment ShadowPassFragment

        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl" //这个要配合ShadowCasterPass使用，也需要引入（SRP的库）
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"//表面着色器输入的库
        #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl" //使用unity写好的顶点/片元着色器需要引入的HLSL（URP的库）

    ENDHLSL
}
```
## 4.3 两种方法的最终效果一致
![](./六-手写URP-Shader代码框架-无光照Shader框架/6.4%20阴影.gif)


# 五、Depth Priming （支持Depth Priming选项）
- Depth Priming本身用于优化物体渲染的性能。
![](./六-手写URP-Shader代码框架-无光照Shader框架/6.5%20depth%20priming提示.png)
- 如果编写的shader不支持Depth Priming选项，在设置选择时，则会导致物体看不见
![](./六-手写URP-Shader代码框架-无光照Shader框架/6.5%20未支持depth%20priming的表现.gif)

## 5.1 Depth Priming 需要新建一个pass(DepthOnly)
```c
Pass
{
    Name "DepthOnly"
    Tags{"LightMode"="DepthOnly"}

    ZWrite On
    ZTest LEqual

    ColorMask 0 //设置为0表示，在pass执行的过程中，对于计算出的颜色不写入。（只写入深度信息 ZTest LEqual）

    HLSLPROGRAM
        //调用unity写好的顶点着色器和片元着色器
        #pragma vertex DepthOnlyVertex
        #pragma fragment DepthOnlyFragment

        //材质相关的（一般是加在编写的每一个pass里）
        //加入透明剔除的变体开关,否则不透明的地方也会有阴影
        #pragma shader_feature _ALPHATEST_ON//源码里面也用了同名变体，所以会生效
        #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A //将ALBEDO的通道的a作为一个平滑通道来使用

        #pragma multi_compile_instancing //支持GPU实例化（变体开关，只用在GPU实例化）

        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl" //这个要配合ShadowCasterPass使用，也需要引入（SRP的库）
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"//表面着色器输入的库
        #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl" //使用unity写好的顶点/片元着色器需要引入的HLSL（URP的库）
    ENDHLSL
}
```
- 效果
![](./六-手写URP-Shader代码框架-无光照Shader框架/6.5%20支持Depth%20Priming选项.gif)
## 5.2 支持MSAA等一些复杂的效果 新建一个pass -DepthNormals

```c
Pass
{
    Name "DepthNormals"
    Tags{"LightMode"="DepthNormals"}

    ZWrite On
    ZTest LEqual

    //需要写入深度和法线信息所需不需要关闭ColorMask
    //ColorMask 0 //设置为0表示，在pass执行的过程中，对于计算出的颜色不写入。（只写入深度信息 ZTest LEqual）

    HLSLPROGRAM
        //调用unity写好的顶点着色器和片元着色器
        #pragma vertex DepthNormalsVertex
        #pragma fragment DepthNormalsFragment

        //材质相关的（一般是加在编写的每一个pass里）
        //加入透明剔除的变体开关,否则不透明的地方也会有阴影
        #pragma shader_feature_local _NORMAL_MAP  //DepthNormals 需要纹理贴图
        #pragma shader_feature _ALPHATEST_ON//源码里面也用了同名变体，所以会生效
        #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A //将ALBEDO的通道的a作为一个平滑通道来使用

        #pragma multi_compile_instancing //支持GPU实例化（变体开关，只用在GPU实例化）

        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl" //这个要配合ShadowCasterPass使用，也需要引入（SRP的库）
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"//表面着色器输入的库
        #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthNormalsPass.hlsl" //使用unity写好的顶点/片元着色器需要引入的HLSL（URP的库）
    ENDHLSL
}
```