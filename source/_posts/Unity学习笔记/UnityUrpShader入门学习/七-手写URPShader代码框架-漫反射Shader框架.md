---
title: UnityUrpShader入门学习-（七）手写URP-Shader代码框架-漫反射Shader框架
date: 2026-10-14 22:24:17
tags: Unity Shader
categories: Unity学习笔记
---


手写URP-Shader代码框架-漫反射Shader框架
<!--more-->

# 一、前期准备
- 新建一个shader文件
- 场景中新建一个cube
- 从shader中创建一个material
- 将material拖拽到cube上
![](./七-手写URPShader代码框架-漫反射Shader框架/7.1%20前期准备-给cube加上漫反射材质.png)
- 场景中新建一个plane
- 右键新建一个material，拖到plane上，设置BaseMap的颜色为红色，并且设置Emission为相同颜色。
![](./七-手写URPShader代码框架-漫反射Shader框架/7.1%20前期准备-给plane加上一个普通材质.png)

# 二、关键代码
部分代码内容沿用无光照模型的代码内容:
具体新增的内容为：
```c
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"//使用DECLARE_LIGHTMAP_OR_SH需要用到的库

#pragma multi_compile LIGHTMAP_ON //变体开关=> 打开生成光照贴图版本的shader代码
 #pragma multi_compile _MAIN_LIGHT_SHADOWS //变体开关=> 打开光照模型阴影版本

float4 normalOS     :NORMAL; //漫反射法线
float2 lightmapUV   :TEXCOORD01; //光照贴图uv坐标。光照贴图可用于实现 光打到地面上会漫反射到物体表面（unity会主动计算）

//URP 中用于处理全局光照（GI） 的关键宏
//参数1：当使用光照贴图时，你希望声明的光照贴图 UV 变量名。通常约定俗成命名为 lightmapUV 或 staticLightmapUV
//参数2：当使用光照探针时，你希望声明的顶点球谐光照变量名。
//参数3：指定这个变量占用哪个 TEXCOORD 语义槽
DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 1);
//每个片元世界坐标中的法线，用于计算漫反射
float3 normalWS     :TEXCOORD2;
//每个片元世界坐标
float3 positionWS   :TEXCOORD3;




OUT.positionWS = positionInputs.positionWS;
VertexNormalInputs normalInputs = GetVertexNormalInputs(IN.normalOS);
OUT.normalWS = normalInputs.normalWS;
//计算lightmap的,算出的结果存到OUT.lightmapUV中
//unity_LightmapST 是Unity 自动传入的 float4 uniform，表示光照贴图的 缩放和偏移（ST 即 Scale/Translate）。
OUTPUT_LIGHTMAP_UV(IN.lightmapUV, unity_LightmapST, OUT.lightmapUV);
/*
用于计算并输出顶点球谐光照（Vertex SH） 的宏
光照探针的数据以球谐函数（Spherical Harmonics, SH） 的形式存储，OUTPUT_SH 就是根据顶点的世界空间法线，在顶点着色器里采样这些球谐系数，把结果写入 vertexSH 变量，供片元着色器使用
*/
OUTPUT_SH(OUT.normalWS, OUT.vertexSH);

 // 烘焙GI（全局光照）信息
half3 bakedGI = SAMPLE_GI(IN.lightmapUV, IN.vertexSH, IN.normalWS);

 //实时光
// 世界坐标转阴影坐标
float4 shadowCoord = TransformWorldToShadowCoord(IN.positionWS);
//获得场景中主灯的信息
Light mainLight = GetMainLight(shadowCoord);
//获得衰减灯光颜色 = 灯光颜色 * 灯光距离衰减 * 阴影衰减
half3 attLightColor = mainLight.color * mainLight.distanceAttenuation * mainLight.shadowAttenuation;

// Lambert 漫反射光照模型 光照计算函数
// attLightColor衰减灯光颜色 （通常已包含强度衰减，如阴影、距离衰减）
// mainLight.direction光源方向 从表面指向光源的方向向量（世界空间）
// IN.normalWS表面法线
half3 realtimeLight = LightingLambert(attLightColor, mainLight.direction, IN.normalWS);

//烘培光+实时光
half3 shading = float4(bakedGI + realtimeLight, 1);
// 固有色（即无光照的返回结果）
half3 albedo = baseMap * _BaseColor * IN.color;
return float4(albedo * shading, 1);
//return baseMap * _BaseColor * IN.color; //无光照的返回结果
```
# 三、完整代码
```c
// 无光照模型shader框架 
//1. 透明剔除
//2. 剔除模式选择
//3. 阴影渲染
//4. 支持Depth Priming选项
Shader "UrpFramework/Diffuse"
{
    Properties
    {
        _BaseMap("Base Map",2d) = "white"{} //基本贴图
        _BaseColor("Base Color",Color) = (1,1,1,1) //固有色
        [Toggle(_ALPHATEST_ON)] _AlphaTestToggle("Alhpa Clipping", Float) = 0 // 增加剔除代码开关（变体）
        _Cutoff("Alpha Cutoff", Float) = 0.5 //方便剔除的阈值自定义
        [Enum(Off,0,Front,1,Back,2)]_Cull("Cull Mode", Float) = 2.0 //设置枚举类型。不剔除、正面剔除、背面剔除
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
                //TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap); float4 _BaseMap_ST;//定义2d纹理、筛选器、ST
                
                //定义ST。由于下面的pass引用了 "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl" 库，里面也定义了TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap);，所以不能放到HLSLINCLUDE了
                float4 _BaseMap_ST;

                float4  _BaseColor;
                float _Cutoff;

            CBUFFER_END
        ENDHLSL

        Pass
        {
            Name "ForwardLit" //pass名字

            Tags{"LightMode" = "UniversalForward"}

            Cull [_Cull]

            // 不写Tags表示放在SRPDefaultUnlit里

            HLSLPROGRAM
                 #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"//使用DECLARE_LIGHTMAP_OR_SH需要用到的库

                #pragma vertex UnlitPassVertex //声明顶点着色器 (函数）
                #pragma fragment UnlitPassFragment //声明片元着色器 (函数）

                #pragma shader_feature _ALPHATEST_ON //变体开关=> 定义开关后，shader编辑器内部会生成两个版本的代码（一个是定义了_ALPHATEST_ON开关的代码 一个是没定义_ALPHATEST_ON开关的代码）
                #pragma multi_compile LIGHTMAP_ON //变体开关=> 打开生成光照贴图版本的shader代码。
                #pragma multi_compile _MAIN_LIGHT_SHADOWS //变体开关=> 打开光照模型阴影版本

                //由于下面的pass引用了 "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl" 库，里面也定义了TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap);，所以不能放到HLSLINCLUDE了
                TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap);//定义2d纹理、筛选器

                struct Attributes {//声明传入的顶点数据
                    // 命名规则：pos+（所处坐标空间的）后缀：1. OS - 对象空间 Object Space ；2. WS - 世界空间 World Space；3. VS - 视图空间 View Space；4. CS - 裁剪空间 Clip Space
                    float4 positionOS   :POSITION;//位置  (  :POSITION 表示标记传入位置信息 
                    float4 normalOS     :NORMAL; //漫反射法线
                    float2 uv           :TEXCOORD0;//用于确定贴图跟立方体每个面上每个点之间的映射关系 。 TEXCOORD0 会随着版本的不同支持的通道数也会不一样
                    float2 lightmapUV   :TEXCOORD1; //光照贴图uv坐标。光照贴图可用于实现 光打到地面上会漫反射到物体表面（unity会主动计算）
                    float4 color        :COLOR; //顶点颜色
                };

                struct Varyings { //声明顶点转换到片元着色器的一些像素信息数据（在内置管线中称为 v2f，在urp管线中称为 Varying）
                    float4 positionCS   :SV_POSITION; //因为包含投影信息，所以是float4。 （: SV_POSITION表示输出位置
                    float2 uv           :TEXCOORD0;
                    // 定义lightmapUV 和 vertexSH
                    // URP 中用于处理全局光照（GI） 的关键宏
                    //参数1：当使用光照贴图时，你希望声明的光照贴图 UV 变量名。通常约定俗成命名为 lightmapUV 或 staticLightmapUV
                    //参数2：当使用光照探针时，你希望声明的顶点球谐光照变量名。
                    //参数3：指定这个变量占用哪个 TEXCOORD 语义槽
                    DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 1);
                    //每个片元世界坐标中的法线，用于计算漫反射
                    float3 normalWS     :TEXCOORD2;
                    //每个片元世界坐标
                    float3 positionWS   :TEXCOORD3;
                    float4 color        :COLOR; //顶点颜色
                };

                //顶点着色器，传入数据声明变量名为IN
                Varyings UnlitPassVertex(Attributes IN) 
                {
                    Varyings OUT = (Varyings)0; //初始化输出数据为0

                    //计算在各个坐标下顶点位置的函数
                    VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS.xyz);

                    OUT.positionCS = positionInputs.positionCS;
                    OUT.positionWS = positionInputs.positionWS;


                    VertexNormalInputs normalInputs = GetVertexNormalInputs(IN.normalOS);
                    OUT.normalWS = normalInputs.normalWS;
                    //计算lightmap的,算出的结果存到OUT.lightmapUV中
                    //unity_LightmapST 是Unity 自动传入的 float4 uniform，表示光照贴图的 缩放和偏移（ST 即 Scale/Translate）。
                    OUTPUT_LIGHTMAP_UV(IN.lightmapUV, unity_LightmapST, OUT.lightmapUV);
                    /*
                    用于计算并输出顶点球谐光照（Vertex SH） 的宏
                    光照探针的数据以球谐函数（Spherical Harmonics, SH） 的形式存储，OUTPUT_SH 就是根据顶点的世界空间法线，在顶点着色器里采样这些球谐系数，把结果写入 vertexSH 变量，供片元着色器使用
                    */
                    OUTPUT_SH(OUT.normalWS, OUT.vertexSH);

                    OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap); //顶点数据，传到片元数据中
                    OUT.color = IN.color;

                    return OUT;
                }

                //片元着色器 (作用在目标缓冲器，所以定义返回值的语义为SV_TARGET，大小写不敏感）
                half4 UnlitPassFragment(Varyings IN) :SV_TARGET
                {
                    //获取颜色
                    half4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);

                    //透明剔除 两个方法 discard 或者clip
                    /*if (baseMap.a < 0.5)
                        discard;*/

                    #ifdef _ALPHATEST_ON // 是如果定义了 _ALPHATEST_ON 的代码版本
                        clip(baseMap.a - _Cutoff);
                    #endif

                    // 烘焙GI（全局光照）信息 ——烘焙光 
                    // 注意：物体要设置为static，烘焙光才能对其生效
                    // 来源：1、球谐vertexSH；2、光照贴图lightmapUV；3、光照探针
                    half3 bakedGI = SAMPLE_GI(IN.lightmapUV, IN.vertexSH, IN.normalWS);
                    //return float4(bakedGI,1);
                    
                    //实时光
                    // 世界坐标转阴影坐标
                    float4 shadowCoord = TransformWorldToShadowCoord(IN.positionWS);
                    //获得场景中主灯的信息
                    Light mainLight = GetMainLight(shadowCoord);
                    //获得衰减灯光颜色 = 灯光颜色 * 灯光距离衰减 * 阴影衰减
                    half3 attLightColor = mainLight.color * mainLight.distanceAttenuation * mainLight.shadowAttenuation;

                    // Lambert 漫反射光照模型 光照计算函数
                    // attLightColor衰减灯光颜色 （通常已包含强度衰减，如阴影、距离衰减）
                    // mainLight.direction光源方向 从表面指向光源的方向向量（世界空间）
                    // IN.normalWS表面法线
                    half3 realtimeLight = LightingLambert(attLightColor, mainLight.direction, IN.normalWS);

                    //烘培光+实时光
                    half3 shading = float4(bakedGI + realtimeLight, 1);
                    // 固有色（即无光照的返回结果）
                    half3 albedo = baseMap * _BaseColor * IN.color;
                    return float4(albedo * (bakedGI + realtimeLight), 1);
                    //return baseMap * _BaseColor * IN.color; //无光照的返回结果
                }
            ENDHLSL
        }

        //阴影渲染
        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual

            ColorMask 0 //设置为0表示，在pass执行的过程中，对于计算出的颜色不写入。（只写入深度信息 ZTest LEqual）
            Cull[_Cull] //正面和背面都应该生成阴影 不然默认是背面剔除的话 从背面就看不到阴影了

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
           

        //支持Depth Priming选项
        Pass
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

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
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBED0_CHANNEL_A //将ALBEDO的通道的a作为一个平滑通道来使用

            #pragma multi_compile_instancing //支持GPU实例化（变体开关，只用在GPU实例化）

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl" //这个要配合ShadowCasterPass使用，也需要引入（SRP的库）
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"//表面着色器输入的库
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl" //使用unity写好的顶点/片元着色器需要引入的HLSL（URP的库）
            ENDHLSL
        }
        //支持MSAA等一些复杂的效果
        Pass
        {
            Name "DepthNoramls"
            Tags{"LightMode" = "DepthNormals"}

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
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBED0_CHANNEL_A //将ALBEDO的通道的a作为一个平滑通道来使用

            #pragma multi_compile_instancing //支持GPU实例化（变体开关，只用在GPU实例化）

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl" //这个要配合ShadowCasterPass使用，也需要引入（SRP的库）
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"//表面着色器输入的库
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthNormalsPass.hlsl" //使用unity写好的顶点/片元着色器需要引入的HLSL（URP的库）
            ENDHLSL
        }
    }
}

```

# 四、具体效果
## 4.1 提前做的事
1. 调整GI->天空盒光照（GI 的全局环境光照来源） -不是强制要求，只是这样调之后方便查看
   - unity->window->rendering->lighting->environment->environment lighting->source->gradient->设置Sky Color或者Ground Color
```
GI 包括哪些东西？

Unity 里的 GI（全局光照） 范围更大，通常包括：

Lightmapping：烘焙光照贴图

Realtime GI：实时全局光照（Built-in 的 Enlighten，现已逐渐弃用）

Light Probes：光照探针，给动态物体提供间接光

Reflection Probes：反射探针

Mixed Lighting：混合光照模式

Ambient Occlusion：环境光遮蔽

Emissive 材质：自发光参与 GI

Environment Lighting：环境光/天空盒/环境反射
```
1. 物体要设置为static，烘焙光才能生效
![](./七-手写URPShader代码框架-漫反射Shader框架/7.3%20设置static.png)
2. 设置stataic 后需要在unity->window->rendering->lighting 中点击Generate Lighting才会生效
    - 之前提到的plane修改Emission 也需要点击Generate Lighting才会生效
![](./七-手写URPShader代码框架-漫反射Shader框架/7.3%20烘培设置.png)
    - 生成后会在场景同名文件下生成烘培数据
![](./七-手写URPShader代码框架-漫反射Shader框架/7.3%20烘培数据.png)
## 4.2 具体效果
![](./七-手写URPShader代码框架-漫反射Shader框架/6.4%20具体效果.gif)
- 给材质加上纹理后的效果
![](./七-手写URPShader代码框架-漫反射Shader框架/7.3%20加上纹理效果.png)