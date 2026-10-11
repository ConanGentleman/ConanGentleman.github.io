---
title: UnityUrpShader入门学习-（五）Shader中变量的使用
date: 2026-10-10 23:58:24
tags: Unity Shader
categories: Unity学习笔记
---

Shader中变量的使用
<!--more-->

# 一、URP编码规范、HLSLINCLUDE与SRP兼容
## 1.1 命名规则
### 1.1.1 顶点/片元着色器
提高可读性，不是编译侧强制需要的命名规则

光照模型名+Pass+Vertex/Fragment
```c
#pragma vertex UnlitPassVertex //表示无光照模型Pass的顶点着色器
#pragma vertex UnlitPassFragment //表示无光照模型Pass的片元着色器
```

### 1.1.2 顶点数据
1. 在内置管线中称为 appdata
2. 在urp管线中称为 Attribute

### 1.1.3 片元着色器数据
1. 在内置管线中称为 v2f
2. 在urp管线中称为 Varying

### 1.1.4 顶点位置数据命名
pos+（所处坐标空间的）后缀：
1. OS - 对象空间 Object Space
2. WS - 世界空间 World Space
3. VS - 视图空间 View Space
4. CS - 裁剪空间 Clip Space

## 1.2 开启SRP batcher合批优化

### 1.2.1 方法
将各pass中共用的变量/头文件 写到Pass同级，并用 HLSLINCLUDE 和 ENDHLSL包裹起来
其中变量还需要用 CBUFFER_START(UnityPerMaterial) 和 CBUFFER_END包裹起来
```c
subshader
{
    HLSLINCLUDE
        //头文件
        CBUFFER_START(UnityPerMaterial)
        //变量
        CBUFFER_END
    ENDHLSL

    pass 
    {

    }
}
```

代表开启成功如下所示：
![](./五-Shader中变量的使用/1.2%20SRP%20batcher%20合批优化.png)

### 1.2.2 优势（⭐）
**对于unity自带的动态合批，需要使用相同的材质，并且材质的参数必须是相同的才能合拼。而使用SRP batcher合批 只需要材质使用的shader相同，参数可以不同**


# 二、变量类型
标量、向量、矩阵、纹理对象、数组、缓冲
## 2.1 标量
1. 标量类型包括：
- bool-对或错。**注意properties不能定义bool值，可以加[Toggle]前缀** 一般是用于做函数中的一些临时变量使用。具体看代码示例
- float-32位浮点数。通常用于世界空间位置、纹理坐标或涉及复杂函数（例如三角函数或幂/幂）的标量计
算。
- half-16位浮点数。通常用于短矢量、方向、物体空间位置、颜色。**（float占用空间太多，一般用half，如果最终表现效果不好再换回float）**
- double-64位浮点数。不能用作输入/输出，比较少用。
  - 使用该类型时，需要把下面代码 **写在 HLSLINCLUDE中 声明**，否则Unity会有报错提示：
```c
#pragma target 4.5;
```
![](./五-Shader中变量的使用/2.1%20double报错提示.png)
- real-当函数可以支持half或float时，在URP/HDRP中使用。**默认为half（假设平台支持）。当着色器指定“#define PREFER_HALF 0”，它将使用浮点精度**。ShaderLibrary函数中的许多常见数学函数都使用此类型。
- int-32位有符号整数
- uint-32位无符号整数（GLES2 除外，不支持此整数，而是定义为int）。
1. 注意：
Fixed（类型）： 在urp管线下已经不支持了，如果代码中还有该类型，应该修改为half类型
- 11位定点数，范围为-2到2。通常用于LDR颜色
- 是来自CG语法的东西，尽管所有平台现在似乎都只是将其转换为half，即使在CGPROGRAM 中也是如此
- HLSL不支持fixed
- 在从内置管线升级时，请改用half！

1. 代码示例
```c
Properties  //通过材质面板传入的属性 
	{
		[Toggle]_IsUseMainTex("Is Use Main Texture", Float) = 1 //不能定义bool类型，所以改用定义为Int。
	}

HLSLINCLUDE
    CBUFFER_START(UnityPerMaterial)
        half _IsUseMainTex;
    CBUFFER_END
ENDHLSL

HLSLPROGRAM
    float4 UnlitPassFragment(Varying IN) :SV_TARGET
    {
        float4 mainTexColor;
        if (_IsUseMainTex)
        {
            mainTexColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
        }
        else
        {
            mainTexColor = float4(1,1,1,1);
        }
        float3 finalColor = (mainTexColor * _MainColor * _ColorIntensity).rgb;
        return float4(finalColor,1);
    }
ENDHLSL
```
![](./五-Shader中变量的使用/2.1%20标量.png)

## 2.2 向量
#### 2.2.1 向量格式
标量类型-向量长度(最多为4，即4维)
- Float4：包含4个浮点的浮点向量
- Half3：半精度向量，3个分量
- Int2：整型向量，2个分量
- 从技术上讲float1，它也是一个一维向量，要采用数组语法访问。

### 2.2.2 访问数据，操作运算符
声明定义 float f4 = float4(1,2,3,4)
f4.xyzw ->float4(1,2,3,4) // swizzle&repeat 写法。x,y,z,w分别代表一个float
f4.rgba ->float4(1,2,3,4) // swizzle&repeat 写法。r,g,b,a分别代表一个float
- f4[0] -> 1
- f4.x -> 1
- f4.xy -> f4.rg -> float2(1,2) // swizzle&repeat 写法
- f4.xyz -> f4.rgb -> float3(1,2,3) // swizzle&repeat 写法
- f4.xxx -> f4.rrr -> float3(1,1,1) // swizzle&repeat 写法
- f4.agbr -> f4.wyzx -> float4(4,2,3,1) // swizzle&repeat 写法
- float4(f4[0]) -> float4(f4[0],f4[0],f4[0],f4[0])
- **小技巧**
```c
float1 f;
return float4(f.xxx,1)//等价 float4(f.x,f.x,fx,1)
```

## 2.3 矩阵
### 2.3.1 矩阵格式
标量类型+行数+列数
- float4x4-4行，4列
- int4x3-4行，3列
- half2x1-2行，1列
- float1x4-1行，4列
### 2.3.2 Unity有内置的变换矩阵，用于空间变换
**使用UNITY_MATRIX_前缀的大写字母的宏定义变换**
- UNITY_MATRIX_M(或Unity_ObjectToWorld)-模型矩阵，从对象空间转换为世界空间
- UNITY_MATRIX_V-视图矩阵，从世界空间转换为视图空间
- UNITY_MATRIX_P-投影矩阵，从视图空间转换为投影空间
- UNITY_MATRIX_VP-查看投影矩阵，从世界空间转换为投影空间
注意代码中矩阵的左乘和右乘，示例
```c
float4 result = mul(UNITY_MATRIX_MVP, float4(float3(1,1,1), 1)); ////使用Core.hlsl中的矩阵运算，将传入顶点的位置（先拓展到4维向量float4(IN.pos,1)）信息变换到处于投影空间中的位置信息
```
### 2.3.3 为什么会有单独的VP矩阵
为了优化渲染性能而存在

### 2.3.4 逆变换矩阵
**多了一个I**

- UNITY_MATRIX_I_M(或unity_WorldToObject)-逆模型矩阵，从世界空间转换到对象空间
- UNITY_MATRIX_I_V-逆视图矩阵，从视图空间转换为世界空间
- UNITY_MATRIX_I_P-逆投影矩阵，从投影空间转换为视图空间
- UNITY_MATRIX_I_VP-逆视图投影矩阵，从投影空间转换为世界空间

### 2.3.5 矩阵数据访问
1. 如果以索引为0开始：._m+行+列
._m00 、 ._m10 、 m_01
2. 如果以索引为1开始：._+行+列
._11、 ._21、 ._12
3. 使用数据方式访问（索引从0开始）
[0][0]  [1][0]  [0][1]
4.用Swizzle取矩阵
._m00_m11 或 ._11_22 代表取矩阵1行1列到2行2列构成的矩阵

## 2.4 纹理采样（纹理对象）

### 2.4.1 声明2d纹理 和 采样器
#### 2.4.1.1 声明一张2d纹理贴图 (还有3d和立方体纹理)
```c
TEXTURE2D(纹理贴图名)
```
#### 2.4.1.2 声明采样器(对某一张贴图如何进行纹理采样)
- 举一种采样器类型：sampler + 纹理贴图名  表示采样器设置来源于主纹理贴图名的 读取的Wrap Mode 和 Filter Mode
```c
SAMPLER(采样器)
// 例如
// SAMPLER(sampler_MainTex) //即 sampler + 纹理贴图名  表示采样器设置来源于主纹理贴图名的 读取的是
```

#### 2.4.1.3 声明独立采样器（与纹理贴图无关）(⭐)
**提出的原因：** DX11以上 单Shader中支持的采样器数量比贴图少得多。 同一张纹理，可以同时用 Repeat / Clamp / Mirror / MirrorOnce，不用复制纹理。

SamplerState 自定义采样器名（**名字里面需要包括Wrap Mode 和 Filter Mode 名字**）
例如：
SamplerState MyRepeatPointSampler;
代表该采样器使用 Repeat 和 Point

- 注意：
- 需要 #pragma target 3.5 或更高（4.5 支持更完整）。

- OpenGL ES 2.0 不支持独立采样器，会回退到 sampler2D 组合方式。

- 移动端 Vulkan / Metal / GLES3 一般支持。

- 自定义 SamplerState 不能作为材质属性暴露在 Inspector 里，通常硬编码在 Shader 中。

- 如果只写 Texture2D _MainTex; 而不写 SamplerState sampler_MainTex;，直接 .Sample() 可能会编译报错，需要补上采样器声明。
#### 2.4.1.4 Unity中采样器的一些状态
![](./五-Shader中变量的使用/2.4%20纹理采样.png)
- Wrap Mode（重复模式、环绕模式）
  - Repeat - 重复
```c
//将顶点着色器的uv*2能够看出该效果
    Varying UnlitPassVertex(Attribute IN) //顶点着色器，传入数据声明变量名为IN
    {
        Varying OUT = (Varying)0; //初始化输出数据为0

        //矩阵变换
        OUT.posCS = mul(UNITY_MATRIX_MVP, float4(IN.posOS, 1)); //使用Core.hlsl中的矩阵运算，将传入顶点的位置（先拓展到4维向量float4(IN.pos,1)）信息变换到处于投影空间中的位置信息

        OUT.uv = IN.uv * 2; //顶点数据，传到片元数据中

        return OUT;
    }
```
![](./五-Shader中变量的使用/2.4%20纹理采样-Repeat.png)
  - Clamp 边缘拉伸
![](./五-Shader中变量的使用/2.4%20纹理采样-Clamp.png)
  - Mirror - 镜像
![](./五-Shader中变量的使用/2.4%20纹理采样-Mirror.png)
  - Mirror Once -先镜像一次，然后边缘拉伸。它是 Mirror 和 Clamp 两种模式的结合体。 部分手机上不支持
  - Per-axis - 各项异性(uv采用不同的重复模式)
- Filter Mode(纹理过滤状态) - **锯齿严重程度**
  - Point (no filter)  -不过滤，点采样 （锯齿严重）
  - Bilinear - 双线性采样
  - Trilinear - 三线性采样

#### 2.4.2 使用纹理uv坐标
1. 使用纹理中平铺和偏移功能
![](./五-Shader中变量的使用/)

2. 代码
**需要先声明一个 贴图变量名 + _ST 的变量 才能使用纹理中平铺和偏移功能**
TRANSFORM_TEX(uv数据,贴图变量名) ，该函数会由Unity直接识别并传入   贴图变量名 + _ST 的变量 进行使用。
对应 材质上的 Scaling(Tiling) & offset
```c
float4 _MainTex_ST; // 对应 材质上的 Scaling(Tiling) & offset
OUT.uv=TRANSFORM_TEX(IN.uv,_MainTex); // .uv为float2 
```
![](./五-Shader中变量的使用/2.4%20纹理中平铺和偏移功能1.png)

3. 调整材质的Scaling(Tiling) 和 offset 的效果 
![](./五-Shader中变量的使用/2.4%20纹理中平铺和偏移功能2.png)


#### 2.4.3 其他纹理类型
- Texture2DArray 2d纹理数组
TEXTURE2D_ARRAY(textureName);
SAMPLER(sampler_textureName);

```c
float4 color = SAMPLE_TEXTURE2D_ARRAY(textureName, sampler_textureName, uv,index);
float4 color =SAMPLE_TEXTURE2D_ARRAY_LOD(textureName，sampler_textureName,uv,lod);
```

- Texture3D 3D纹理(多)
TEXTURE3D(textureName);
SAMPLER(sampler_textureName);
```c
float4 color =SAMPLE_TEXTURE3D(textureName， sampler_textureName,uvw);
float4 color =SAMPLE_TEXTURE3D_LOD(textureName,sampler_textureName,uvw,lod);
// uses 3D uv coord Ccommonly referred to as uvw)
```

- TextureCube 立方体纹理

TEXTURECUBE(textureName);
SAMPLER(sampler_textureName);

```c
...
float4 color = SAMPLE_TEXTURECUBE(textureName, sampler_textureName,dir);
float4 color = SAMPLE_TEXTURECUBE_LOD(textureName,sampler_textureName, dir,lod);
// uses 3D uv coord Cnamed dir here, as it is typically a direction)
```

- TextureCubeArray 立方体纹理数组
TEXTURECUBE_ARRAY(textureName);
SAMPLER(sampler_textureName);
```c
float4 color =SAMPLE_TEXTURECUBE_ARRAY(textureName,sampler_textureName,dir,index);
float4 color =SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName,sampler_textureName,dir,lod);
```

## 2.5 数组
### 2.5.1 float4数组和 float数组
- 数组可以用for进行遍历
- shader脚本中 Unity只能从C#脚本设置Vector(float4)和Float数组，无法在 Properties 中设置
  - float4数组 在C#脚本端 使用Shader.SetGlobalVector 设置
    - float4 * float4 = float4(f1.x\*f2.x,f1.y\*f2.y,....)
  - float数组 在C#脚本端 使用Shader.SetGlobalFloat 设置

### 2.5.2 float数组使用案例
- 代码
  - C#中的代码
```cs
public Color color;
void Update(){
    Shader.SetGlobalFloatArray("_FloatArray", new[] { 0.3f, 0.8f, 0.2f, 1.0f });
}
```
- shader中片元着色器的代码
```c
//声明 float _FloatArray[4];
return float4(finalColor,1) * float4(_FloatArray[0], _FloatArray[1], _FloatArray[2], _FloatArray[3]);
```

- 效果
![](./五-Shader中变量的使用/2.5%20数组.png)

### 2.5.3 float4数组使用案例
- 代码
  - C#中的代码
```cs
public Color color;
void Update(){
    Shader.SetGlobalVectorArray("_VectorArray", new[] {
            new Vector4(color.r,color.g,color.g,color.a),
            new Vector4(0,0,0,0)
        });
}
```
  - shader中片元着色器的代码
```c
// 声明 float4 _VectorArray[2];
return float4(finalColor,1) * _VectorArray[0];
```

- 效果
与上面一致


### 2.5.3 数组循环
- 代码
```c
float _FloatArray[10];

float add = 0;
//[unroll]//如果循环的大小是固定的（即不基于变量）并且循环不会提前退出，则“展开”循环的性能会更高
for (int i=0;i<10;i++){
    add += _FloatArray[i];
}
Out =add;

```
- 效果
![](./五-Shader中变量的使用/2.5%20数组循环.png)