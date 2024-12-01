---
title: lua学习笔记1
date: 2024-08-20 21:46:11
tags: 热更新相关
categories: 热更新相关
---
lua学习笔记
<!--more-->
- [零 引用](#零-引用)
- [一 概述](#一-概述)
- [二 安装](#二-安装)
- [三 基本语法](#三-基本语法)
    - [3.1 交互式编程](#31-交互式编程)
    - [3.2 脚本式编程](#32-脚本式编程)
    - [3.3 注释](#33-注释)
    - [3.4 标识符](#34-标识符)
- [四 数据类型](#四-数据类型)
    - [4.1 nil(空)](#41-nil空)
    - [4.2 boolean（布尔）](#42-boolean布尔)
    - [4.3 number（数字）](#43-number数字)
    - [4.4 string（字符串）](#44-string字符串)
    - [4.5 表](#45-表)
    - [4.6 function（函数）](#46-function函数)
    - [4.7 thread（线程）](#47-thread线程)
    - [4.8 userdata（自定义类型）](#48-userdata自定义类型)
- [五 变量](#五-变量)
    - [5.1 变量](#51-变量)
    - [5.2 赋值语句](#52-赋值语句)
    - [5.3 索引](#53-索引)
- [六 循环](#六-循环)
    - [6.1 循环方式](#61-循环方式)
    - [6.2 循环控制语句](#62-循环控制语句)
    - [6.3 无限循环](#63-无限循环)
- [七 流程控制 （if else）](#七-流程控制-if-else)
- [八 函数](#八-函数)
    - [8.1 概述](#81-概述)
    - [8.2 函数的定义](#82-函数的定义)
    - [8.3 多返回值](#83-多返回值)
    - [8.4 可变参数](#84-可变参数)
- [九 运算符](#九-运算符)
    - [9.1 运算符类型](#91-运算符类型)
    - [9.2 算数运算符](#92-算数运算符)
    - [9.3 关系运算符](#93-关系运算符)
    - [9.4 逻辑运算符](#94-逻辑运算符)
    - [9.5 其他运算符](#95-其他运算符)
    - [9.6 运算符优先级](#96-运算符优先级)
- [十 字符串](#十-字符串)
    - [10.1 字符串的表示](#101-字符串的表示)
    - [10.2 字符串长度计算](#102-字符串长度计算)
    - [10.3 字符串的操作（函数）](#103-字符串的操作函数)
    - [10.4 字符串截取](#104-字符串截取)
    - [10.5 字符串大小写转换](#105-字符串大小写转换)
    - [10.6 字符串查找与反转](#106-字符串查找与反转)
    - [10.7 字符串格式化](#107-字符串格式化)
    - [10.8 字符与整数相互转换](#108-字符与整数相互转换)
    - [10.9 字符串连接与复制](#109-字符串连接与复制)
    - [10.10 匹配模式](#1010-匹配模式)
- [十一 Lua数组](#十一-lua数组)
    - [11.1 概述](#111-概述)
    - [11.2 一维数组](#112-一维数组)
    - [11.3 多维数组](#113-多维数组)
- [十二 迭代器（⭐）](#十二-迭代器)
    - [12.1 概述](#121-概述)
    - [12.2 泛型for迭代器](#122-泛型for迭代器)
    - [12.2 无状态的迭代器](#122-无状态的迭代器)
    - [12.3 多状态的迭代器](#123-多状态的迭代器)
- [十三 table（表）（⭐）](#十三-table表)
    - [13.1 概述](#131-概述)
    - [13.2 表（Table）的构造](#132-表table的构造)
    - [13.3 Table操作](#133-table操作)
- [十四 模块与包（⭐）](#十四-模块与包)
    - [14.1 概述及定义](#141-概述及定义)
    - [14.2 加载模块（require函数）](#142-加载模块require函数)
    - [14.3 C包](#143-c包)
- [十五 元表(Metatable)（⭐）](#十五-元表metatable)
    - [15.1 概述](#151-概述)
    - [15.2 \_\_index 元方法（⭐⭐⭐）](#152-__index-元方法)
    - [15.3 \_\_newindex 元方法（⭐）](#153-__newindex-元方法)
    - [15.4 rawget和rawset](#154-rawget和rawset)
    - [15.5 运算元方法-为表添加操作符](#155-运算元方法-为表添加操作符)
    - [15.6 \_\_call元方法](#156-__call元方法)
    - [15.7 \_\_tostring 元方法](#157-__tostring-元方法)
- [十六 协同程序（coroutine）（⭐⭐⭐）](#十六-协同程序coroutine)
    - [16.1 什么是协同（coroutine）](#161-什么是协同coroutine)
    - [16.2 基本语法](#162-基本语法)
    - [16.3 各个语法的用法实例](#163-各个语法的用法实例)
    - [16.4 生产者-消费者问题](#164-生产者-消费者问题)
    - [16.5 线程和协同程序区别](#165-线程和协同程序区别)
- [十七 文件I/O](#十七-文件io)
    - [17.1 概述及用法](#171-概述及用法)
    - [17.2 简单模式（io.调用）](#172-简单模式io调用)
    - [17.3 完全模式（file:调用）](#173-完全模式file调用)
- [十八 错误处理](#十八-错误处理)
    - [18.1 概述](#181-概述)
    - [18.2 语法错误](#182-语法错误)
    - [18.3 运行错误](#183-运行错误)
    - [18.4 错误处理](#184-错误处理)
    - [18.5 pcall 和 xpcall、debug](#185-pcall-和-xpcalldebug)
- [十九 调试(Debug)](#十九-调试debug)
    - [19.1 概述及Debug的方法](#191-概述及debug的方法)
    - [19.2 调试类型](#192-调试类型)
- [二十 垃圾回收](#二十-垃圾回收)
    - [20.1 概述](#201-概述)
    - [20.2 垃圾回收器函数](#202-垃圾回收器函数)
- [二十一 面向对象（⭐）](#二十一-面向对象)
    - [21.1 概述](#211-概述)
    - [21.2 面向对象特征](#212-面向对象特征)
    - [21.3 Lua 中面向对象](#213-lua-中面向对象)
    - [21.4 简单实例（⭐）](#214-简单实例)
    - [21.5 点调用和冒号调用的区别（⭐⭐⭐）](#215-点调用和冒号调用的区别)
    - [21.6 Lua 继承(⭐⭐⭐)](#216-lua-继承)
    - [21.7 Lua多态（函数重写）](#217-lua多态函数重写)
- [二十二 数据库访问（LuaSQL）](#二十二-数据库访问luasql)
    - [22.1 概述](#221-概述)
    - [22.2 安装](#222-安装)
    - [22.3 实例](#223-实例)




# 零 引用

本文件内容来自以下网址：
1. [Lua 教程 | 菜鸟教程 (runoob.com)](https://www.runoob.com/lua/lua-tutorial.html)
2. [Lua 5.3 中文参考手册(菜鸟教程翻译)](https://www.runoob.com/manual/lua53doc/contents.html)
3. [lua 的io操作，非常详细。](https://blog.csdn.net/duanxuyun/article/details/4751118)


# 一 概述

1. Lua 是一种轻量小巧的脚本语言，用标准C语言编写并以源代码形式开放， 其设计目的是为了嵌入应用程序中，从而为应用程序提供灵活的扩展和定制功能。
Lua 是巴西里约热内卢天主教大学（Pontifical Catholic University of Rio de Janeiro）里的一个研究小组于 1993 年开发的，该小组成员有：Roberto Ierusalimschy、Waldemar Celes 和 Luiz Henrique de Figueiredo。
2. 设计目的
其设计目的是为了嵌入应用程序中，从而为应用程序提供灵活的扩展和定制功能。
3. 特性

- 轻量级: 它用标准C语言编写并以源代码形式开放，编译后仅仅一百余K，可以很方便的嵌入别的程序里。
- 可扩展: Lua提供了非常易于使用的扩展接口和机制：由宿主语言(通常是C或C++)提供这些功能，Lua可以使用它们，就像是本来就内置的功能一样。
- 其它特性:
- 
    - 支持面向过程(procedure-oriented)编程和函数式编程(functional programming)；
    - 自动内存管理；只提供了一种通用类型的表（table），用它可以实现数组，哈希表，集合，对象；
    - 语言内置模式匹配；闭包(closure)；函数也可以看做一个值；提供多线程（协同进程，并非操作系统所支持的线程）支持；
    - 通过闭包和table可以很方便地支持面向对象编程所需要的一些关键机制，比如数据抽象，虚函数，继承和重载等。

4. 应用场景
    - 游戏开发
    - 独立应用脚本
    - Web 应用脚本
    - 扩展和数据库插件如：MySQL Proxy 和 MySQL WorkBench安全系统，如入侵检测系统

# 二 安装

首先安装Lua for Windows(exe包)： [Releases · rjpcomputing/luaforwindows (github.com)](https://github.com/rjpcomputing/luaforwindows/releases)
![](安装截图.jpg)
使用IDE：VSCode、IDEA、LuaStudio。这里我使用VSCode进行开发配置，相关配置内容（该内容我们忽略 4. Lua 编译环境配置中的1-6，因为我们下载的exe安装直接帮我们配置好了环境变量了）： [(3条消息) Visual Studio Code -> VSCode 开发环境搭建 ---- Lua 开发环境搭建 及 代码运行（code runner 插件）_vscode安装lua_YanWennian的博客-CSDN博客](https://blog.csdn.net/yanwennian/article/details/103480938)

# 三 基本语法

### 3.1 交互式编程
直接在命令行中输入程序并立即查看效果，通过lua -i或lua来启用
```lua
$ lua -i 
$ Lua 5.3.0  Copyright (C) 1994-2015 Lua.org, PUC-Rio
> 
-- 执行命令
> print("Hello World！")
```

### 3.2 脚本式编程
1. 将代码存储在本地以.lua为扩展名的文件中（ hello.lua ），其中内容为：
```lua
print("Hello World!")
print("www.runoob.com")
```
2. 在文件所在目录的终端(或cmd)执行脚本

```cmd
$ lua hello.lua
Hello World！
www.runoob.com
```
3. 我们也可以将代码修改为如下形式来执行脚本（在开头添加：#!/usr/local/bin/lua）：

```lua
#!/usr/local/bin/lua

print("Hello World!")
print("www.runoob.com")
```

以上代码中，我们指定了 Lua 的解释器 /usr/local/bin 就是指你本地lua的位置。window安装后的lua可能不太需要，但在linux下需要在头部添加#!/usr/local/bin/lua。

### 3.3 注释

1. 单行注释
两个减号

```lua
--
```

2. 多行注释
```lua
--[[
 多行注释
 多行注释
 --]]
```

### 3.4 标识符

1. 以字母或下划线开头 + 0个或者多个字母、下划线、数字
2. 最好不要使用下划线加大写字母的标示符，因为Lua的保留字也是这样的。
3. Lua 不允许使用特殊字符如 @, $, 和 % 来定义标示符
4. Lua 区分大小写。
5. 一些正确的定义

```md
mohd         zara      abc     move_name    a_123
myname50     _temp     j       a23b9        retVal
```

6. 关键字

![关键字](关键字.png)
一般约定，以下划线开头连接一串大写字母的名字（比如 _VERSION）被保留用于 Lua 内部全局变量。

# 四 数据类型

|数据类型|	描述|
|-----|-----|
nil	| 这个最简单，只有值nil属于该类，**表示一个无效值**（在条件表达式中相当于false）。
boolean	|包含两个值：false和true。
number	|表示双精度类型的**实浮点数**
string	|字符串由一对**双引号或单引号**来表示
function	|由 C 或 Lua 编写的**函数**
userdata	|表示任意存储在变量中的**C数据结构**
thread	|表示执行的**独立线路**，用于执行**协同程序**
table	|Lua 中的表（table）其实是一个"**关联数组**"（associative arrays），数组的**索引**可以是数字、字符串或表类型。在 Lua 里，table 的创建是通过"**构造表达式**"来完成，**最简单构造表达式是{}**，用来创建一个**空表**。
### 4.1 nil(空)

1. 给**全局**变量或者 **table 表**里的变量**赋一个 nil** 值，等同于把它们**删掉**
2. nil 作比较时应该加上双引号 "：

```lua
> type(X)
nil
> type(X)==nil
false
> type(X)=="nil"
true
--- 因是 type(X) 实质是返回的 "nil" 字符串，是一个 string 类型：
--- type(type(X))==string
```
### 4.2 boolean（布尔）

boolean 类型只有两个可选值：true（真） 和 false（假），**Lua 把 false 和 nil 看作是 false，其他的都为 true，<font color=red>数字 0 也是 true**</font>

### 4.3 number（数字）

Lua 默认只有一种 number 类型 -- double（双精度）类型 **（默认类型可以修改 luaconf.h 里的定义）**

### 4.4 string（字符串）

1. 字符串由一对双引号或单引号来表示

```lua
string1 = "this is string1"
string2 = 'this is string2'

html = [[
<html>
<head></head>
<body>
    <a href="http://www.runoob.com/">菜鸟教程</a>
</body>
</html>
]]
print(html)
```

1. 在对一个数字字符串上进行算术操作时，Lua 会尝试将这个数字字符串转成一个数字:

```lua
> print("2" + 6)
8.0
> print("2" + "6")
8.0
> print("2 + 6")
2 + 6
> print("-2e2" * "6")
-1200.0
> print("error" + 1)
stdin:1: attempt to perform arithmetic on a string value
stack traceback:
        stdin:1: in main chunk
        [C]: in ?
>
```

1. 连接字符串使用 ..

```lua
> print("a" .. 'b')
ab
> print(157 .. 428)
157428
> 
```

1. 使用#来计算字符串长度

```lua
> len = "www.runoob.com"
> print(#len)
14
> print(#"www.runoob.com")
14
```

### 4.5 表

在 Lua 里，table 的创建是通过"构造表达式"来完成，最简单构造表达式是{}，用来创建一个空表。

1. 直接初始化表:

```lua
-- 创建一个空的 table
local tbl1 = {}
 
-- 直接初始表
local tbl2 = {"apple", "pear", "orange", "grape"}
```

2. Lua 中的表（table）其实是一个"关联数组"（associative arrays），数组的索引可以是数字或者是字符串

```lua
-- table_test.lua 脚本文件
a = {}
a["key"] = "value"
key = 10
a[key] = 22
a[key] = a[key] + 11
for k, v in pairs(a) do
    print(k .. " : " .. v)
end
```

3. 不同于其他语言的数组把 0 作为数组的初始索引，**在 Lua 里表的默认初始索引一般以 1 开始**。
4. table **不会固定长度大小**，有**新数据添加**时 table 长度会**自动增长**，没**初始的 table 都是 nil**

### 4.6 function（函数）

1. 在 Lua 中，函数是被看作是"第一类值（First-Class Value）"，函数可以存在变量里:

```lua
-- function_test.lua 脚本文件
function factorial1(n)
    if n == 0 then
        return 1
    else
        return n * factorial1(n - 1)
    end
end
print(factorial1(5))
factorial2 = factorial1
print(factorial2(5))
```

2. function 可以以匿名函数（anonymous function）的方式通过参数传递:

```lua
-- function_test2.lua 脚本文件
function testFun(tab,fun)
        for k ,v in pairs(tab) do
                print(fun(k,v));
        end
end

tab={key1="val1",key2="val2"};
testFun(tab,
function(key,val)--匿名函数
        return key.."="..val;
end
);
```

### 4.7 thread（线程）
在 Lua 里，最主要的线程是协同程序（coroutine）。它跟线程（thread）差不多，**拥有自己独立的栈、局部变量和指令指针，可以跟其他协同程序共享全局变量和其他大部分东西**。

线程跟协程的区别：**线程可以同时多个运行，而协程任意时刻只能运行一个**，并且处于**运行状态的协程只有被挂起（suspend）时才会暂停**。

### 4.8 userdata（自定义类型）

userdata 是一种**用户自定义数据**，用于表示一种**由应用程序或 C/C++ 语言库所创建的类型**，可以将任意 C/C++ 的任意数据类型的数据（通常是 struct 和 指针）**存储到 Lua 变量中调用**。

# 五 变量

### 5.1 变量

1. 变量在使用前，需要在代码中进行声明，即创建该变量。
2. Lua 变量有三种类型：全局变量、局部变量、表中的域。
   -  Lua 中的**变量全是全局变量**，哪怕是语句块或是函数里，除非**用 local 显式声明为局部变量**。
   -  **局部变量的作用域**为从声明位置开始到所在语句块结束。

```lua
-- test.lua 文件脚本
a = 5               -- 全局变量
local b = 5         -- 局部变量

function joke()
    c = 5           -- 全局变量
    local d = 6     -- 局部变量
end

joke()
print(c,d)          --> 5 nil

do 
    local a = 6     -- 局部变量
    b = 6           -- 对局部变量重新赋值
    print(a,b);     --> 6 6
end

print(a,b)      --> 5 6
```

3. 变量的默认值均为 nil

### 5.2 赋值语句

1. 赋值是改变一个变量的值和改变表域的最基本的方法。

```lua
a = "hello" .. "world"
t.n = t.n + 1
```

2. Lua 可以对**多个变量同时赋值**，变量列表和值列表的各个元素用逗号分开，**赋值语句右边的值会依次赋给左边的变量**。

```lua
a, b = 10, 2*x       <-->       a=10; b=2*x
```

3. 遇到赋值语句**Lua会先计算右边所有的值然后再执行赋值操作**，所以我们可以**这样进行交换变量的值：**(⭐)

```lua
x, y = y, x                     -- swap 'x' for 'y'
a[i], a[j] = a[j], a[i]         -- swap 'a[i]' for 'a[j]'
```

4. 当变量个数和值的个数不一致时，Lua会一直以变量个数为基础采取以下策略：
    - a. 变量个数 > 值的个数             按变量个数补足nil
    - b. 变量个数 < 值的个数             多余的值会被忽略

```lua
a, b, c = 0, 1
print(a,b,c)             --> 0   1   nil
 
a, b = a+1, b+1, b+2     -- value of b+2 is ignored
print(a,b)               --> 1   2
 
a, b, c = 0
print(a,b,c)             --> 0   nil   nil
```

5. **应该尽可能的使用局部变量，有两个好处：**
    - **避免命名冲突**。
    - 访问局部变量的**速度**比全局变量**更快**。

### 5.3 索引

1. 对 table 的索引使用方括号 []。Lua 也提供了 **. 操作**。

```markdown
t[i]
t.i                 -- 当索引为字符串类型时的一种简化写法
gettable_event(t,i) -- 采用索引访问本质上是一个类似这样的函数调用
```

```lua
> site = {}
> site["key"] = "www.runoob.com"
> print(site["key"])
www.runoob.com
> print(site.key)
www.runoob.com
```

# 六 循环

### 6.1 循环方式

1.  Lua 语言提供了以下几种循环处理方式：

|循环类型|	描述|
|-----|----|
while 循环|	在条件为 true 时，让程序重复地执行某些语句。执行语句前会先检查条件是否为 true。
for 循环|	重复执行指定语句，重复次数可在 for 语句中控制。
repeat...until|	重复执行循环，直到 指定的条件为真时为止
循环嵌套|	可以在循环内嵌套一个或多个循环语句（while do ... end;for ... do ... end;repeat ... until;）

### 6.2 循环控制语句

1. Lua 支持以下循环控制语句： 

控制语句|	描述
---|---
break 语句|	退出当前循环或语句，并开始脚本执行紧接着的语句。
goto 语句|	将程序的控制点转移到一个标签处。

2. Lua不支持continue，但可以用以下方式实现continue功能：
    - 使用repeat until实现
  
    ```lua
    for i = 10, 1, -1 do
    repeat
        if i == 5 then
        print("continue code here")
        break
        end
        print(i, "loop code here")
    until true
    end
    ```

    - 使用goto实现
    
    ```lua
    for i=1, 3 do
        if i <= 2 then
            print(i, "yes continue")
            goto continue
        end
        print(i, " no continue")
        ::continue::
        print([[i'm end]])
    end
    ```
    
    - 使用if else实现
    
    ```lua
    for i=1, 3 do 
        print(i)   
        if i <= 2 then     
            print("continue the loop")  
        else  
            print(" loop area")   
    end   
    print("end of loop")
    end
    ```

### 6.3 无限循环

```lua
while( true )
do
   print("循环将永远执行下去")
end
```

# 七 流程控制 （if else）

语句|	描述
---|---
if 语句|	if 语句 由一个布尔表达式作为条件判断，其后紧跟其他语句组成。
if...else| 语句	if 语句 可以与 else 语句搭配使用, 在 if 条件表达式为 false 时执行 else 语句代码。
if 嵌套语句|	你可以在if 或 else if中使用一个或多个 if 或 else if 语句 。

控制结构的条件表达式结果可以是任何值，Lua认为false和nil为假，true和非nil为真。

**要注意的是Lua中 0 为 true：**

```lua
--[ 0 为 true ]
if(0)
then
    print("0 为 true")
end
```

# 八 函数

### 8.1 概述

1. 在Lua中，函数是对语句和表达式进行抽象的主要方法。既可以用来处理一些特殊的工作，也可以用来计算一些值。

2. Lua 提供了**许多的内建函数**，你可以很方便的在程序中调用它们，**如print()函数**可以将传入的参数打印在控制台上。

3. Lua 函数主要有两种用途：

    - 完成指定的任务，这种情况下函数作为调用语句使用；
    - 计算并返回值，这种情况下函数作为赋值语句的表达式使用。

### 8.2 函数的定义

1. Lua 编程语言函数定义格式如下：

    <font color="red">optional_function_scope</font> function <font color="green">function_name</font> ( <font color="blue">argument1, argument2, argument3..., argumentn</font>)
        <font color="pink">function_body</font>
        return <font color="orange">result_params_comma_separated</font>
    end


2. 解析 

- <font color="red">optional_function_scope</font>: 该参数是可选的指定函数是全局函数还是局部函数，未设置该参数默认为全局函数，如果你需要设置函数为局部函数需要使用关键字 local。

- <font color="green">function_name</font>: 指定函数名称。

- <font color="blue">argument1, argument2, argument3..., argumentn</font>: 函数参数，多个参数以逗号隔开，函数也可以不带参数。

- <font color="pink">function_body</font>: 函数体，函数中需要执行的代码语句块。

- <font color="orange">result_params_comma_separated</font>: 函数返回值，Lua语言函数可以返回多个值，每个值以逗号隔开。

3. 实例
   - 定义函数 max()，参数为 num1, num2，用于比较两值的大小，并返回最大值

    ```lua
    --[[ 函数返回两个值的最大值 --]]
    function max(num1, num2)

    if (num1 > num2) then
        result = num1;
    else
        result = num2;
    end

    return result; 
    end
    -- 调用函数
    print("两值比较最大值为 ",max(10,4))
    print("两值比较最大值为 ",max(5,6))
    ```

   - Lua 中我们可以将**函数作为参数**传递给函数

    ```lua
    myprint = function(param)
    print("这是打印函数 -   ##",param,"##")
    end

    function add(num1,num2,functionPrint)
    result = num1 + num2
    -- 调用传递的函数参数
    functionPrint(result)
    end
    myprint(10)
    -- myprint 函数作为参数传递
    add(2,5,myprint)
    ```

### 8.3 多返回值

1. Lua函数可以返回多个结果值，比如string.find，其返回匹配串"开始和结束的下标"（如果不存在匹配串返回nil）。

```lua
> s, e = string.find("www.runoob.com", "runoob") 
> print(s, e)
5    10
```

2. Lua函数中，在**return后列出要返回的值**的列表即可返回多值（比如用，隔开）

```lua
function maximum (a)
    local mi = 1             -- 最大值索引
    local m = a[mi]          -- 最大值
    for i,val in ipairs(a) do
       if val > m then
           mi = i
           m = val
       end
    end
    return m, mi --多返回值
end

print(maximum({8,10,23,12,5}))
```
2. 注意一下多返回值的函数在赋值时的情况，**仅仅只有放在所有逗号之后的那个函数会把返回值展开**。
   
```lua
function add()
    return 1,0
end

local b,c,d,e = add(),add()

print(b) -- 1
print(c) -- 1
print(d) -- 0
print(e) -- nil
```

### 8.4 可变参数

1. Lua 函数可以接受可变数目的参数，和 C 语言类似，在**函数参数列表中使用三点 ... 表示**函数有可变的参数。 (**可变参数通过循环遍历...进行读取**)

```lua
function add(...)  
local s = 0  
  for i, v in ipairs{...} do   --> {...} 表示一个由所有变长参数构成的数组  
    s = s + v  
  end  
  return s  
end  
print(add(3,4,5,6,7))  --->25
```

2. 通过**select("#",...)** 来获取可变参数的数量，**避免**参数中存在 **nil的元素**导致长度计算出错

```lua
function average(...)
   result = 0
   local arg={...}
   for i,v in ipairs(arg) do
      result = result + v
   end
   print("总共传入 " .. select("#",...) .. " 个数")
   return result/select("#",...)
end

print("平均值为",average(10,5,3,4,5,6))
```

3. 有时候我们可能需要**几个固定参数加上可变参数**，**固定参数必须放在变长参数之前**:

```lua
function fwrite(fmt, ...)  ---> 固定的参数fmt
    return io.write(string.format(fmt, ...))     
end

fwrite("runoob\n")       --->fmt = "runoob", 没有变长参数。  
fwrite("%d%d\n", 1, 2)   --->fmt = "%d%d", 变长参数为 1 和 2
```

4. 通常在遍历变长参数的时候只需要使用 {…}，然而**变长参数可能会包含一些 nil**，那么就**可以用 select 函数来访问变长参数**了：select('#', …) 或者 select(n, …)

    - **select('#', …) 返回可变参数的长度**。
    - **select(n, …) 用于返回从起点 n 开始到结束位置的所有参数列表，返回的是多个参数，而不是一个table**。

```lua
function f(...)
    a = select(3,...)  -->从第三个位置开始，变量 a 对应右边变量列表的第一个参数
    print (a)
    print (select(3,...)) -->打印所有列表参数
end

f(0,1,2,3,4,5)
--输出
--2
--2       3       4       5

do  
    function foo(...)  
        for i = 1, select('#', ...) do  -->获取参数总数
            local arg = select(i, ...); -->读取参数，arg 对应的是右边变量列表的第一个参数
            print("arg", arg);  
        end  
    end  
  
    foo(1, 2, 3, 4);  
end
--[[
输出
arg    1
arg    2
arg    3
arg    4
]]--
```

# 九 运算符

### 9.1 运算符类型

- 算术运算符
- 关系运算符
- 逻辑运算符
- 其他运算符 

### 9.2 算数运算符

1. 下表列出了 Lua 语言中的常用算术运算符，设定 A 的值为10，B 的值为 20：

操作符|	描述|	实例
---|---|---
+|	加法|	A + B 输出结果 30
-|	减法|	A - B 输出结果 -10
*|	乘法|	A * B 输出结果 200
/|	除法|	B / A 输出结果 2
%|	取余|	B % A 输出结果 0
^|	乘幂|	A^2 输出结果 100
-|	负号|	-A 输出结果 -10
//|	整除运算符(>=lua5.3)|	5//2 输出结果 2

2. 在 lua 中，/ 用作除法运算，计算结果包含小数部分，**// 用作整除运算，计算结果不包含小数部分**

### 9.3 关系运算符

下表列出了 Lua 语言中的常用关系运算符，设定 A 的值为10，B 的值为 20：

操作符|	描述|	实例
---|---|---
==|	等于，检测两个值是否相等，相等返回 true，否则返回 false|	(A == B) 为 false。
~=|	不等于，检测两个值是否相等，不相等返回 true，否则返回 false|	(A ~= B) 为 true。
\> |	大于，如果左边的值大于右边的值，返回 true，否则返回 false|	(A > B) 为 false。
< |	小于，如果左边的值大于右边的值，返回 false，否则返回 true|	(A < B) 为 true。
\>= |	大于等于，如果左边的值大于等于右边的值，返回 true，否则返回 false|	(A >= B) 返回 false。
<= |	小于等于， 如果左边的值小于等于右边的值，返回 true，否则返回 false|	(A <= B) 返回 true。

### 9.4 逻辑运算符
下表列出了 Lua 语言中的常用逻辑运算符，设定 A 的值为 true，B 的值为 false： (**lua逻辑运算符也具有短路的功能**)

操作符|	描述|	实例
---|---|---
and|	逻辑与操作符。 若 A 为 false，则返回 A，否则返回 B。|	(A and B) 为 false。
or|	逻辑或操作符。 若 A 为 true，则返回 A，否则返回 B。|	(A or B) 为 true。
not|	逻辑非操作符。与逻辑运算结果相反，如果条件为 true，逻辑非为 false。|not(A and B) 为 true。

### 9.5 其他运算符

下表列出了 Lua 语言中的连接运算符与计算表或字符串长度的运算符：

操作符|	描述|	实例
---|---|---
..|	连接两个字符串|	a..b ，其中 a 为 "Hello " ， b 为 "World", 输出结果为 "Hello World"。
#|	一元运算符，返回字符串或表的长度。|	#"Hello" 返回 5

### 9.6 运算符优先级

1. 从高到低的顺序

```lua
^
not    - (unary)
*      /       %
+      -
..
<      >      <=     >=     ~=     ==
and
or
```

2. 除了 ^ 和 .. 外所有的二元运算符都是**左连接**的。

```lua
a+i < b/2+1          <-->       (a+i) < ((b/2)+1)
5+x^2*8              <-->       5+((x^2)*8)
a < y and y <= z     <-->       (a < y) and (y <= z)
-x^2                 <-->       -(x^2)
x^y^z                <-->       x^(y^z)
```

# 十 字符串

### 10.1 字符串的表示

1. 字符串或串(String)是由数字、字母、下划线组成的一串字符。

2. 在 Lua 中，字符串是一种基本的数据类型，用于存储文本数据。

3. Lua 中的字符串可以包含任意字符，包括字母、数字、符号、空格以及其他特殊字符。

4. Lua 语言中字符串可以使用以下三种方式来表示：
   - 单引号间的一串字符。 
   
   ```lua
   local str1 = 'This is a string.'
   local str2 = "This is also a string."
   ```
   - 双引号间的一串字符。
   
   ```lua
   local str = "Hello, "
    str = str .. "World!"  -- 创建一个新的字符串并将其赋值给str
    print(str)  -- 输出 "Hello, World!"
   ```
   - **[\[ 与 ]] 间的一串字符**。
   
   ```lua
   local multilineString = [[
    This is a multiline string.
    It can contain multiple lines of text.
    No need for escape characters.
    ]]

    print(multilineString)
   ```

### 10.2 字符串长度计算

1. 使用 string.len函数或 utf8.len 函数，包含**中文的一般用 utf8.len**，string.len 函数用于计算**只包含 ASCII 字符串的长度**。

```lua
local myString = "Hello, 世界!"

-- 计算字符串的长度（字符个数）
local length1 = utf8.len(myString)
print(length1) -- 输出 10

-- string.len 函数会导致结果不准确
local length2 = string.len(myString)
print(length2) -- 输出 14
```

2. **转义字符用于表示不能直接显示的字符**，比如后退键，回车键等，如在字符串转换双引号可以使用 \
3. 所有的转义字符和所对应的意义：
![转义字符的意义](转义字符的意义.png)

### 10.3 字符串的操作（函数）

Lua 提供了很多的方法来支持字符串的操作：


序号|	方法 & 用途
---|---
1|	string.upper(argument)<br>**字符串全部转为大写字母**。
2|	string.lower(argument)<br>**字符串全部转为小写字母**。
3|	string.gsub(mainString,findString,replaceString,num)<br>**在字符串中替换**。 <br>mainString 为要操作的字符串， findString 为被替换的字符，replaceString 要替换的字符，num 替换次数（可以忽略，则全部替换），如：<br> > string.gsub("aaaa","a","z",3);<br> zzza    3
4|	string.find (str, substr, [init, [plain]])<br>**在一个指定的目标字符串 str 中搜索指定的内容 substr**，**如果找到了一个匹配的子串，就会返回这个子串的起始索引和结束索引，不存在则返回 nil**。<br>init 指定了搜索的起始位置，默认为 1，可以一个负数，表示从后往前数的字符个数。<br>plain 表示是否使用简单模式，默认为 false，true 只做简单的查找子串的操作，false 表示使用使用正则模式匹配。<br>以下实例查找字符串 "Lua" 的起始索引和结束索引位置：<br> > string.find("Hello Lua user", "Lua", 1) <br>7    9
5|	string.reverse(arg)<br>**字符串反转**<br> > string.reverse("Lua")<br>auL
6|	string.format(...)<br>返回一个**类似printf的格式化字符串**<br>> string.format("the value is:%d",4)<br>the value is:4
7|	string.char(arg) 和 string.byte(arg[,int])<br>char **将整型数字转成字符并连接**， **byte 转换字符为整数值(可以指定某个字符，默认第一个字符)**。<br>> string.char(97,98,99,100)<br>abcd<br>> string.byte("ABCD",4)<br>68<br>> string.byte("ABCD")<br>65<br>>
8|	string.len(arg)<br>**计算字符串长度**。<br>string.len("abc")<br>3
9|	string.rep(string, n)<br>**返回字符串string的n个拷贝**<br>> string.rep("abcd",2)<br>abcdabcd
10|	..<br>**链接两个字符串**<br>> print("www.runoob.".."com")<br>www.runoob.com
11|	string.gmatch(str, pattern)<br>**返回一个迭代器函数，每一次调用这个函数，返回一个在字符串 str 找到的下一个符合 pattern 描述的子串**。如果参数 pattern 描述的字符串没有找到，迭代函数返回nil。<br>> for word in string.gmatch("Hello Lua user", "%a+") do print(word) end<br>Hello<br>Lua<br>user<br>
12|	string.match(str, pattern, init)<br>string.match()**只寻找源字串str中的第一个配对. 参数init可选, 指定搜寻过程的起点, 默认为1**。<br>在成功配对时, 函数将返回配对表达式中的所有捕获结果; 如果没有设置捕获标记, 则返回整个配对字符串. 当没有成功的配对时, 返回nil。<br>> = string.match("I have 2 questions for you.", "%d+ %a+")<br>2 questions<br>> = string.format("%d, %q", string.match("I have 2 questions for you.", "(%d+) (%a+)"))<br>2, "questions"

### 10.4 字符串截取

1. 字符串截取使用 sub() 方法。**string.sub() 用于截取字符串**，原型为：

```lua
string.sub(s, i [, j])
```

参数说明：
- s：要截取的字符串。
- i：截取开始位置。
- j：截取结束位置，默认为 -1，最后一个字符。
- 
2. 实例

```lua
-- 字符串
local sourcestr = "prefix--runoobgoogletaobao--suffix"
print("\n原始字符串", string.format("%q", sourcestr))

-- 截取部分，第4个到第15个
local first_sub = string.sub(sourcestr, 4, 15)
print("\n第一次截取", string.format("%q", first_sub))

-- 取字符串前缀，第1个到第8个
local second_sub = string.sub(sourcestr, 1, 8)
print("\n第二次截取", string.format("%q", second_sub))

-- 截取最后10个
local third_sub = string.sub(sourcestr, -10)
print("\n第三次截取", string.format("%q", third_sub))

-- 索引越界，输出原始字符串
local fourth_sub = string.sub(sourcestr, -100)
print("\n第四次截取", string.format("%q", fourth_sub))
```

### 10.5 字符串大小写转换

```lua
string1 = "Lua";
print(string.upper(string1))
print(string.lower(string1))
```

### 10.6 字符串查找与反转

```lua
string = "Lua Tutorial"
-- 查找字符串
print(string.find(string,"Tutorial"))
reversedString = string.reverse(string)
print("新字符串为",reversedString)
```

### 10.7 字符串格式化

1. 格式字符串可能包含以下的转义码:
    - %c - 接受一个数字, 并将其**转化为ASCII码表中对应的字符**
    - %d, %i - 接受一个数字并将**其转化为有符号的整数格式**
    - %o - 接受一个数字并将其转化为**八进制数格式**
    - %u - 接受一个数字并将其转化为**无符号整数格式**
    - %x - 接受一个数字并将其转化为**十六进制数格式, 使用小写字母**
    - %X - 接受一个数字并将其转化为**十六进制数格式, 使用大写字母**
    - %e - 接受一个数字并将其转化为**科学记数法格式, 使用小写字母e**
    - %E - 接受一个数字并将其转化为**科学记数法格式, 使用大写字母E**
    - %f - 接受一个数字并将其转化为**浮点数格式**
    - %g(%G) - 接受一个数字并将其转化**为%e(%E, 对应%G)及%f中较短的一种格式**
    - %q - 接受一个字符串并将其转化为**可安全被Lua编译器读入的格式**
    - %s - 接受一个字符串并**按照给定的参数格式化该字符串**
2. 为进一步细化格式, 可以在 **%号后添加参数. 参数将以如下的顺序读入** :
(1) **符号**: 一个+号表示其后的数字转义符将让正数显示正号. 默认情况下只有负数显示符号.
(2) **占位符**: 一个0, 在后面指定了字串宽度时占位用. 不填时的默认占位符是空格.
(3) **对齐标识**: 在指定了字串宽度时, 默认为右对齐, 增加-号可以改为左对齐.
(4) **宽度数值**
(5) **小数位数/字串裁切**: 在宽度数值后增加的小数部分n, 若后接f(浮点数转义符, 如%6.3f)则设定该浮点数的小数只保留n位, 若后接s(字符串转义符, 如%5.3s)则设定该字符串只显示前n位.**%5.3s表示宽度为5，且保留3位小数**
3. 实例

```lua
string1 = "Lua"
string2 = "Tutorial"
number1 = 10
number2 = 20
-- 基本字符串格式化
print(string.format("基本格式化 %s %s",string1,string2))
-- 日期格式化
date = 2; month = 1; year = 2014
print(string.format("日期格式化 %02d/%02d/%04d", date, month, year))
-- 十进制格式化
print(string.format("%.4f",1/3))
```

```lua
string.format("%c", 83)                 -- 输出S
string.format("%+d", 17.0)              -- 输出+17
string.format("%05d", 17)               -- 输出00017
string.format("%o", 17)                 -- 输出21
string.format("%u", 3.14)               -- 输出3
string.format("%x", 13)                 -- 输出d
string.format("%X", 13)                 -- 输出D
string.format("%e", 1000)               -- 输出1.000000e+03
string.format("%E", 1000)               -- 输出1.000000E+03
string.format("%6.3f", 13)              -- 输出13.000
string.format("%q", "One\nTwo")         -- 输出"One\
                                        -- 　　Two"
string.format("%s", "monkey")           -- 输出monkey
string.format("%10s", "monkey")         -- 输出    monkey
string.format("%5.3s", "monkey")        -- 输出  mon
```

### 10.8 字符与整数相互转换

```lua
-- 字符转换
-- 转换第一个字符
print(string.byte("Lua"))
-- 转换第三个字符
print(string.byte("Lua",3))
-- 转换末尾第一个字符
print(string.byte("Lua",-1))
-- 第二个字符
print(string.byte("Lua",2))
-- 转换末尾第二个字符
print(string.byte("Lua",-2))

-- 整数 ASCII 码转换为字符
print(string.char(97))

--[[
76
97
97
117
117
a

--]]
```

### 10.9 字符串连接与复制

```lua
string1 = "www."
string2 = "runoob"
string3 = ".com"
-- 使用 .. 进行字符串连接
print("连接字符串",string1..string2..string3)

-- 字符串长度
print("字符串长度 ",string.len(string2))

-- 字符串复制 2 次
repeatedString = string.rep(string2,2)
print(repeatedString)

--[[
连接字符串    www.runoob.com
字符串长度     6
runoobrunoob    
--]]
```

### 10.10 匹配模式

1. Lua 中的匹配模式直接用常规的字符串来描述。 它用于模式匹配函数 string.find, string.gmatch, string.gsub, string.match。你**还可以在模式串中使用字符类**。

2. 字符类**指可以匹配一个特定字符集合内任何字符的模式项**。比如，**字符类 %d 匹配任意数字**。所以你可以**使用模式串 %d%d/%d%d/%d%d%d%d 搜索 dd/mm/yyyy 格式的日期**：

```lua
s = "Deadline is 30/05/1999, firm"
date = "%d%d/%d%d/%d%d%d%d"
print(string.sub(s, string.find(s, date)))    --> 30/05/1999
```

3. 下面的表列出了Lua支持的所有字符类：
单个字符 **(除 ^$()%.[]\*+-? 外)**: 与该字符自身配对

- .(点): 与任何字符配对
- %a: 与任何字母配对
- %c: 与任何控制符配对(例如\n)
- %d: 与任何数字配对
- %l: 与任何小写字母配对
- %p: 与任何标点(punctuation)配对
- %s: 与空白字符配对
- %u: 与任何大写字母配对
- %w: 与任何字母/数字配对
- %x: 与任何十六进制数配对
- %z: 与任何代表0的字符配对
- %x(此处x是非字母非数字字符): 与字符x配对. 主要用来处理表达式中有功能的字符(^$()%.[]*+-?)的配对问题, 例如%%与%配对
- [数个字符类]: 与任何[]中包含的字符类配对. 例如[%w_]与任何字母/数字, 或下划线符号(_)配对
- [\^数个字符类]: 与任何不包含在[]中的字符类配对. 例如[^%s]与任何非空白字符配对

**当上述的字符类用大写书写时, 表示与非此字符类的任何字符配对. 例如, %S表示与任何非空白字符配对.例如，'%A'非字母的字符:**

```lua
> print(string.gsub("hello, up-down!", "%A", "."))
hello..up.down.    4
```
**数字4不是字符串结果的一部分，他是gsub返回的第二个结果，代表发生替换的次数。**
在**模式匹配中有一些特殊字符**，他们有特殊的意义，Lua中的特殊字符如下：

```lua
( ) . % + - * ? [ ^ $
```

**'%' 用作特殊字符的转义字符，因此 '%.' 匹配点；'%%' 匹配字符 '%'。转义字符 '%'不仅可以用来转义特殊字符，还可以用于所有的非字母的字符。**

4. 模式条目可以是：

- 单个字符类匹配该类别中任意单个字符；
- 单个字符类跟一个 '\*'， 将匹配**零或多个该类的字**符。 这个条目**总是匹配尽可能长的串**；
- 单个字符类跟一个 '+'， 将匹配**一或更多个该类的字符**。 这个条目总是匹配**尽可能长**的串；
- 单个字符类跟一个 '-'， 将匹配**零或更多个该类的字符**。 和 '*' 不同， 这个条目总是匹配**尽可能短**的串；
- 单个字符类跟一个 '?'， 将匹配**零或一个该类的字符**。 只要有可能，它会匹配一个；
- %n， 这里的 n 可以从 1 到 9； 这个条目匹配**一个等于 n 号捕获物（后面有描述）的子串**。
- %bxy， 这里的 x 和 y 是两个明确的字符； 这个条目匹配以 x 开始 y 结束， 且其中 x 和 y 保持 平衡 的字符串。 意思是，如果从左到右读这个字符串，对每次读到一个 x 就 +1 ，读到一个 y 就 -1， 最终结束处的那个 y 是第一个记数到 0 的 y。 举个例子，条目 %b() 可以匹配到括号平衡的表达式。
- %f[set]， 指 边境模式； 这个条目会匹配到一个位于 set 内某个字符之前的一个空串， 且这个位置的前一个字符不属于 set 。 集合 set 的含义如前面所述。 匹配出的那个空串之开始和结束点的计算就看成该处有个字符 '\0' 一样。

5. 模式：

模式 指一个模式条目的序列。 **在模式最前面加上符号 '\^' 将锚定从字符串的开始处做匹配**。 在模式最后面加上**符号'\$'**将使匹配过程锚定到**字符串的结尾**。 
如果 **'\^' 和 '\$' 出现在其它位置**，它们均没有特殊含义，**只表示自身**。

6. 捕获：

**模式可以在内部用小括号括起一个子模式**； 这些子模式被**称为 捕获物**。 当匹配成功时，由 捕获物 匹配到的字符串中的子串被保存起来用于未来的用途。 捕获物以它们左括号的次序来编号。 例如，对于模式 "(a*(.)%w(%s*))" ， 字符串中匹配到 "a*(.)%w(%s*)" 的部分保存在第一个捕获物中 （因此是编号 1 ）； 由 "." 匹配到的字符是 2 号捕获物， 匹配到 "%s*" 的那部分是 3 号。

作为一个特例，**空的捕获 () 将捕获到当前字符串的位置（它是一个数字）**。 例如，如果将模式 "()aa()" 作用到字符串 "flaaap" 上，将产生两个捕获物： 3 和 5 。

# 十一 Lua数组

### 11.1 概述

1. 数组，就是相**同数据类型的元素按一定顺序排列的集合**，可以是**一维**数组和**多维**数组。

2. 在Lua中，数组**不是一种特定的数据类型**，而是一种用来**存储一组值的数据结构**。

3. 实际上，**Lua 中并没有专门的数组类型**，而是使用一种被称为 **"table" 的数据结构来实现数组**的功能。

4. Lua 数组的索引键值可以使用整数表示，数组的大小不是固定的。

5. 在 **Lua 索引值是以 1 为起始，但你也可以指定 0 开始**。

### 11.2 一维数组

1. 索引访问

```lua
-- 创建一个数组
local myArray = {10, 20, 30, 40, 50}

-- 访问数组元素
print(myArray[1])  -- 输出 10
print(myArray[3])  -- 输出 30
```

2. 要计算数组的长度（即数组中元素的个数），你可以使用 # 操作符：(但注意 如果存在连续两个nil夹在数组中间，#只会计算前半截的长度)

```lua
local myArray = {10, 20, 30, 40, 50}

-- 计算数组长度
local length = #myArray

print(length) -- 输出 5
```

3. 一维数组可以用 for 循环出数组中的元素

```lua
-- 创建一个数组
local myArray = {10, 20, 30, 40, 50}

-- 循环遍历数组
for i = 1, #myArray do
    print(myArray[i])
end
```

4. lua索引默认从1开始

```lua
array = {"Lua", "Tutorial"}

for i= 0, 2 do
   print(array[i])
end
```

5. 添加元素

```lua
-- 创建一个数组
local myArray = {10, 20, 30, 40, 50}

-- 添加新元素到数组末尾
myArray[#myArray + 1] = 60


-- 循环遍历数组
for i = 1, #myArray do
    print(myArray[i])
end
```

6. 删除元素

```lua
-- 创建一个数组
local myArray = {10, 20, 30, 40, 50}

-- 删除第三个元素
table.remove(myArray, 3)

-- 循环遍历数组
for i = 1, #myArray do
    print(myArray[i])
end
```
### 11.3 多维数组

1. 以下是一个三行三列的阵列多维数组：

```lua
-- 初始化数组
array = {}
for i=1,3 do
   array[i] = {}
      for j=1,3 do
         array[i][j] = i*j
      end
end

-- 访问数组
for i=1,3 do
   for j=1,3 do
      print(array[i][j])
   end
end
```

2. 不同索引键的三行三列阵列多维数组：

```lua
-- 初始化数组
array = {}
maxRows = 3
maxColumns = 3
for row=1,maxRows do
   for col=1,maxColumns do
      array[row*maxColumns +col] = row*col
   end
end

-- 访问数组
for row=1,maxRows do
   for col=1,maxColumns do
      print(array[row*maxColumns +col])
   end
end
```

正如你所看到的，以上的实例中，**数组设定了指定的索引值，这样可以避免出现 nil 值，有利于节省内存空间**。

# 十二 迭代器（⭐）

### 12.1 概述

迭代器（iterator）是一种对象，它能够**用来遍历标准模板库容器中的部分或全部元素**，每个迭代器对象代表容器中的确定的地址。

在 Lua 中迭代器是一种支**持指针类型的结构**，它可以遍历集合的每一个元素。

### 12.2 泛型for迭代器

1. **泛型 for** 在自己内部保存迭代函数，实际上它保存三个值： **迭代函数、状态常量、控制变量**。泛型 for 迭代器**提供了集合的 key/value** 对，语法格式如下：

```lua
for k, v in pairs(t) do
    print(k, v)
end
```
上面代码中，k, v为变量列表；pairs(t)为表达式列表。

```lua
array = {"Google", "Runoob"}

for key,value in ipairs(array) 
do
   print(key, value)
end
```

以上实例中我们使用了 Lua 默认提供的迭代函数 ipairs。(**建议最好都用pairs**，因为ipairs不能找到0和0以下的自定义索引内容,如果从1开始 索引顺序断了 后面的内容也找不到)。

2. 下面我们看看**泛型 for 的执行过程**：

- 首先，初始化，**计算 in 后面表达式的值，表达式应该返回泛型 for 需要的三个值：迭代函数、状态常量、控制变量**；与多值赋值一样，如果表达式返回的结果个数不足三个会自动用 nil 补足，多出部分会被忽略。
- 第二，将**状态常量和控制变量**作为**参数调用迭代函数**（注意：对于 for 结构来说，**状态常量**没有用处，仅仅**在初始化时获取他的值并传递给迭代函数**）。
- 第三，将迭**代函数返回的值赋给变量列表**。
- 第四，如果**返回的第一个值为nil循环结束**，否则执行循环体。
- 第五，回到**第二步再次调用迭代函数**

3. 在Lua中我们常常**使用函数来描述迭代器**，**每次调用该函数就返回集合的下一个元素**。Lua 的迭代器包含以下两种类型：
   - 无状态的迭代器
   - 多状态的迭代器

### 12.2 无状态的迭代器

1. 无状态的迭代器是**指不保留任何状态的迭代器**，因此在循环中我们可以**利用无状态迭代器避免创建闭包花费额外的代价**。
2. 每一次迭代，**迭代函数都是用两个变量（状态常量和控制变量）的值作为参数被调用**，一个**无状态的迭代器只利用这两个值**可以**获取下一个元素**。
3. 这种**无状态迭代器的典型的简单的例子是 ipairs**，它**遍历数组的每一个元素，元素的索引需要是数值**。

```lua
function square(iteratorMaxCount,currentNumber)
   if currentNumber<iteratorMaxCount
   then
      currentNumber = currentNumber+1
   return currentNumber, currentNumber*currentNumber
   end
end
-- square,3,0 迭代函数、状态常量、控制变量 currentNumber==currentNumber时 函数square就没有返回值了
for i,n in square,3,0 
do
   print(i,n)
end
```

4. **ipairs的实现（⭐）**
**迭代的状态包括被遍历的表（循环过程中不会改变的状态常量）和当前的索引下标（控制变量）**，ipairs 和迭代函数都很简单，我们在 Lua 中可以这样实现：

```lua
function iter (a, i)
    i = i + 1
    local v = a[i]
    if v then
       return i, v
    end
end
 
function ipairs (a)
    return iter, a, 0
end
```

**当 Lua 调用 ipairs(a) 开始循环时，他获取三个值：迭代函数 iter、状态常量 a、控制变量初始值 0；然后 Lua 调用 iter(a,0) 返回 1, a[1]（除非 a[1]=nil）；第二次迭代调用 iter(a,1) 返回 2, a[2]……直到第一个 nil 元素。**


### 12.3 多状态的迭代器

1. 很多情况下，**迭代器需要保存多个状态信息而不是简单的状态常量和控制变量**，最**简单的方法是使用闭包**，**还有一种方法**就是将所有的状态**信息封装到 table 内**，将 table **作为迭代器的状态常量**，因为这种情况下可以将所有的信息存放在 table 内，**所以迭代函数通常不需要第二个参数**。
2. 创建自己的迭代器

```lua
array = {"Google", "Runoob"}

function elementIterator (collection)
   local index = 0
   local count = #collection
   -- 闭包函数
   return function ()
      index = index + 1
      if index <= count
      then
         --  返回迭代器的当前元素
         return collection[index]
      end
   end
end

for element in elementIterator(array)
do
   print(element)
end

--[[
Google
Runoob    
--]]
```

以上实例中我们可以看到，**elementIterator 内使用了闭包函数，实现计算集合大小并输出各个元素**。


# 十三 table（表）（⭐）

### 13.1 概述

1. table 是 Lua 的**一种数据结构用来帮助我们创建不同的数据类型**，如：**数组、字典**等。

2. Lua table **使用关联型数组**，你可以**用任意类型的值来作数组的索引**，但这个值**不能是 nil**。

3. Lua table 是**不固定大小的**，你可以根据自己需要进行扩容。

4. Lua也是 **通过table来解决模块（module）、包（package）和对象（Object）** 的。 例如string.format表示使用"format"来索引table string。

### 13.2 表（Table）的构造

1. 构造器是创建和初始化表的表达式。表是Lua特有的功能强大的东西。**最简单的构造函数是{}**，用来创建一个空表。可以直接初始化数组:

```lua
-- 初始化表
mytable = {}

-- 指定值
mytable[1]= "Lua"

-- 移除引用
mytable = nil
-- lua 垃圾回收会释放内存
```

2. 当我们为 **table a 并设置元素，然后将 a 赋值给 b，则 a 与 b 都指向同一个内存**。如果 **a 设置为 nil ，则 b 同样能访问 table 的元素**。如果没有指定的变量指向a，Lua的垃圾回收机制会清理相对应的内存。
以下实例演示了以上的描述情况：

```lua
-- 简单的 table
mytable = {}
print("mytable 的类型是 ",type(mytable))

mytable[1]= "Lua"
mytable["wow"] = "修改前"
print("mytable 索引为 1 的元素是 ", mytable[1])
print("mytable 索引为 wow 的元素是 ", mytable["wow"])

-- alternatetable和mytable的是指同一个 table
alternatetable = mytable

print("alternatetable 索引为 1 的元素是 ", alternatetable[1])
print("alternatetable 索引为 wow 的元素是 ", alternatetable["wow"])

alternatetable["wow"] = "修改后"

print("mytable 索引为 wow 的元素是 ", mytable["wow"])

-- 释放变量
alternatetable = nil
print("alternatetable 是 ", alternatetable)

-- mytable 仍然可以访问
print("mytable 索引为 wow 的元素是 ", mytable["wow"])

mytable = nil
print("mytable 是 ", mytable)

--[[
mytable 的类型是        table
mytable 索引为 1 的元素是       Lua
mytable 索引为 wow 的元素是     修改前
alternatetable 索引为 1 的元素是        Lua
alternatetable 索引为 wow 的元素是      修改前
mytable 索引为 wow 的元素是     修改后
alternatetable 是       nil
mytable 索引为 wow 的元素是     修改后
mytable 是      nil

    --]]
```

### 13.3 Table操作

1. 常用方法

序号|	方法 & 用途
---|---
1|	**table.concat (table [, sep [, start [, end]]])**<br>concat是concatenate(连锁, 连接)的缩写. table.concat()函数列出参数中**指定table的数组部分从start位置到end位置的所有元素, 元素间以指定的分隔符(sep)隔开**。
2|	**table.insert (table, [pos,] value)**<br>在table的数组部分**指定位置(pos)插入值为value的一个元素**. pos参数可选, 默认为数组部分末尾.
3|	**table.maxn (table)**<br>指定table中**所有正数key值中最大的key值**. 如果**不存在**key值为正数的元素, **则返回0**。(**Lua5.2之后该方法已经不存在了**,本文使用了自定义函数实现)
4|	**table.remove (table [, pos])**<br>**返回table数组部分位于pos位置的元素**. 其后的元素会被前移. **pos参数可选, 默认为table长度, 即从最后一个元素删起**。
5|	**table.sort (table [, comp])**<br>对给定的table进行**升序排序**。


2. Table连接 
使用 concat() 输出一个列表中元素连接成的字符串:

```lua
fruits = {"banana","orange","apple"}
-- 返回 table 连接后的字符串
print("连接后的字符串 ",table.concat(fruits))

-- 指定连接字符
print("连接后的字符串 ",table.concat(fruits,", "))

-- 指定索引来连接 table
print("连接后的字符串 ",table.concat(fruits,", ", 2,3))

--[[
连接后的字符串     bananaorangeapple
连接后的字符串     banana, orange, apple
连接后的字符串     orange, apple
    --]]
```

3. 插入和移除

```lua
fruits = {"banana","orange","apple"}

-- 在末尾插入
table.insert(fruits,"mango")
print("索引为 4 的元素为 ",fruits[4])

-- 在索引为 2 的键处插入
table.insert(fruits,2,"grapes")
print("索引为 2 的元素为 ",fruits[2])

print("最后一个元素为 ",fruits[5])
table.remove(fruits)
print("移除后最后一个元素为 ",fruits[5])

--[[
索引为 4 的元素为     mango
索引为 2 的元素为     grapes
最后一个元素为     mango
移除后最后一个元素为     nil
    --]]
```

4. Table排序
以下实例演示了 sort() 方法的使用，用于对 Table 进行排序：

```lua
fruits = {"banana","orange","apple","grapes"}
print("排序前")
for k,v in ipairs(fruits) do
        print(k,v)
end

table.sort(fruits)
print("排序后")
for k,v in ipairs(fruits) do
        print(k,v)
end
```

# 十四 模块与包（⭐）

### 14.1 概述及定义

1. **模块类似于一个封装库**，从 Lua 5.1 开始，Lua 加入了标准的模块管理机制，可以把一些**公用的代码放在一个文件里**，**以 API 接口的形式在其他地方调用**，有利于代码的重用和降低代码耦合度

2. **Lua 的模块是由变量、函数等已知元素组成的 table**，因此**创建一个模块**很简单，**就是创建一个 table**，然后把需要导出的常量、函数放入其中，最后返回这个 table 就行。以下为创建自定义模块 module.lua，文件代码格式如下：

```lua
-- 文件名为 module.lua
-- 定义一个名为 module 的模块
module = {}
 
-- 定义一个常量
module.constant = "这是一个常量"
 
-- 定义一个函数
function module.func1()
    io.write("这是一个公有函数！\n")
end
 
local function func2()
    print("这是一个私有函数！")
end
 
function module.func3()
    func2()
end
 
return module
```

由上可知，模块的结构就是一个 table 的结构，因此可以**像操作调用 table 里的元素那样来操作调用模块里的常量或函数**。

**上面的 func2** 声明为程序块的局部变量，即**表示一个私有函数**，因此是不能从外部访问模块里的这个私有函数，**必须通过模块里的公有函数来调用**.

### 14.2 加载模块（require函数）

1. Lua提供了一个名为**require的函数用来加载模块**。要加载一个模块，只需要简单地调用就可以了。例如：
2. 执行 **require 后会返回一个由模块常量或函数组成的 table**，并且**还会定义一个包含该table 的全局变量**。

```lua
-- test_module.lua 文件
-- module 模块为上文提到到 module.lua
require("module")
 
print(module.constant)
 
module.func3()

--[[
这是一个常量
这是一个私有函数！
--]]
```
或者给加载的模块定义一个别名变量，方便调用：

```lua
-- test_module2.lua 文件
-- module 模块为上文提到到 module.lua
-- 别名变量 m
local m = require("module")
 
print(m.constant)
 
m.func3()
```

3. **加载机制（⭐）**

- 对于**自定义的模块**，模块文件**不是放在哪个文件目录都行**，函数 require 有它自己的文件路径加载策略，它会尝试从 Lua 文件或 C 程序库中加载模块。
- **require 用于搜索 Lua 文件的路径是存放在全局变量 package.path** 中，当 **Lua 启动后**，会**以环境变量 LUA_PATH 的值来初始这个环境变量**。如果**没有找到该环境变量**，**则使用一个编译时定义的默认路径来初始化**。

- 当然，**如果没有 LUA_PATH 这个环境变量，也可以自定义设置，在当前用户根目录下打开 .profile 文件**（**没有则创建，打开 .bashrc 文件也可以**），例如把 **"~/lua/" 路径加入 LUA_PATH 环境变量里：**

```lua
#LUA_PATH
export LUA_PATH="~/lua/?.lua;;"
```

- **文件路径以 ";" 号分隔**，最后的 2 个 ";;" 表示新加的路径后面加上原来的默认路径。

- 接着，**更新环境变量参数**，使之立即生效。

```lua
source ~/.profile
```

- 这时假设 package.path 的值是：

```lua
/Users/dengjoe/lua/?.lua;./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua
```

- 那么调用 require("module") 时就会尝试打开以下文件目录去搜索目标。

```lua
/Users/dengjoe/lua/module.lua;
./module.lua
/usr/local/share/lua/5.1/module.lua
/usr/local/share/lua/5.1/module/init.lua
/usr/local/lib/lua/5.1/module.lua
/usr/local/lib/lua/5.1/module/init.lua
```

### 14.3 C包

1. Lua和C是很容易结合的，使用 C 为 Lua 写包。

2. 与Lua中写包不同，**C包在使用以前必须首先加载并连接**，在大多数系统中最容易的实现方式是通过动态连接库机制。

3. Lua在一个叫**loadlib的函数内提供了所有的动态连接的功能**。这个函数有**两个参数:库的绝对路径和初始化函数**。所以典型的调用的例子如下:

```lua
local path = "/usr/local/lua/lib/libluasocket.so"
local f = loadlib(path, "luaopen_socket")
```

- loadlib 函数**加载指定的库并且连接到 Lua**，然而它**并不打开库**（也就是说**没有调用初始化函数**），反之他**返回初始化函数作为 Lua 的一个函数**，这样我们就可以**直接在Lua中调用他**。
- 如果加载动态库或者查找初始化函数时**出错**，**loadlib 将返回 nil 和错误信息**。我们可以修改前面一段代码，使其**检测错误然后调用初始化函数**：

```lua
local path = "/usr/local/lua/lib/libluasocket.so"
-- 或者 path = "C:\\windows\\luasocket.dll"，这是 Window 平台下
local f = assert(loadlib(path, "luaopen_socket"))
f()  -- 真正打开库
```

一般情况下我们期望二进制的发布库包含一个与前面代码段相似的 stub 文件，安装二进制库的时候可以随便放在某个目录，只需要修改 stub 文件对应二进制库的实际路径即可。

**将 stub 文件所在的目录加入到 LUA_PATH，这样设定后就可以使用 require 函数加载 C 库了**。

# 十五 元表(Metatable)（⭐）

### 15.1 概述

1. 在 Lua table 中我们可以访问对应的 key 来得到 value 值，但是却无法对两个 table 进行操作(比如相加)。

2. 因此 **Lua 提供了元表(Metatable)**，允许我们改变 table 的行为，每个行为关联了对应的**元方法**。
例如，**使用元表我们可以定义 Lua 如何计算两个 table 的相加操作 a+b**。

3. 当 Lua 试图**对两个表进行相加**时，先**检查两者之一是否有元表**，**之后检查**是否有一个叫 **__add 的字段**，若**找到，则调用对应的值**。 **__add 等即时字段**，其对应的值（**往往是一个函数或是 table**）就是 **"元方法"** 。
有两个很重要的函数来处理元表（⭐）：

- **setmetatable(table,metatable)**: 对指定 table **设置元表**(metatable)，**如果**元表(metatable)中**存在 __metatable 键值**，setmetatable **会失败**。
- **getmetatable(table)**: **返回对象的元表**(metatable)。

4. 以下实例演示了如何对指定的表设置元表：

```lua
mytable = {}                          -- 普通表 
mymetatable = {}                      -- 元表
setmetatable(mytable,mymetatable)     -- 把 mymetatable 设为 mytable 的元表

--以上代码写成一行
mytable = setmetatable({},{})
```

### 15.2 __index 元方法（⭐⭐⭐）

1. **这是 metatable 最常用的键**。

2. 当你**通过键来访问** table 的时候，如果**这个键没有值**，那么Lua就会**寻找该table的metatable**（假定有metatable）中的**__index 键**。如果**__index包含一个表格，Lua会在表格中查找相应的键**。我们可以在使用 lua 命令进入交互模式查看：

```lua
$ lua
Lua 5.3.0  Copyright (C) 1994-2015 Lua.org, PUC-Rio
> other = { foo = 3 } 
> t = setmetatable({}, { __index = other }) 
> t.foo
3
> t.bar
nil
```

3. 如果 **__index包含一个函数的话，Lua就会调用那个函数，table和键会作为参数传递给函数**。

**__index 元方法查看表中元素是否存在**，如果**不存在**，返回结果**为 nil**；如果**存在**则**由 __index 返回结果**。

```lua
mytable = setmetatable({key1 = "value1"}, {
  __index = function(mytable, key)
    if key == "key2" then
      return "metatablevalue"
    else
      return nil
    end
  end
})

print(mytable.key1,mytable.key2)

--[[
value1    metatablevalue  
--]]
```

4. 实例解析（⭐）：

- mytable 表赋值为 {key1 = "value1"}。

- mytable 设置了元表，元方法为 __index。

- 在mytable表中查找 key1，如果找到，返回该元素，找不到则继续。

- 在mytable表中查找 key2，如果找到，返回 metatablevalue，找不到则继续。

- 判断元表有没有__index方法，如果__index方法是一个函数，则调用该函数。

- 元方法中查看是否传入 "key2" 键的参数（mytable.key2已设置），如果传入 "key2" 参数返回 "metatablevalue"，否则返回 mytable 对应的键值。

5.我们可以将以上代码简单写成：

```lua
mytable = setmetatable({key1 = "value1"}, { __index = { key2 = "metatablevalue" } })
print(mytable.key1,mytable.key2)
```

6. 总结（⭐）

Lua 查找一个表元素时的规则，其实就是如下 3 个步骤:

- **在表中查找，如果找到，返回该元素，找不到则继续**
- **判断该表是否有元表，如果没有元表，返回 nil，有元表则继续。**
- **判断元表有没有 __index 方法，**
  - 如果 __index 方法为 **nil**，则返回**nil**；
  - 如果 __index 方法是一个**表**，则**重复 1、2、3**；
  - 如果 __index 方法是一个**函数**，则返回**该函数的返回值**。

### 15.3 __newindex 元方法（⭐）

1. **__newindex 元方法用来对表更新（赋值修改）**，**__index**则用来**对表访问** 。
2. 当你给表的一个**缺少的索引赋值**，解释器就会**查找元表的__newindex 元方法**：如果**存在则调用这个函数而不进行赋值操作**。

```lua
mymetatable = {}
mytable = setmetatable({key1 = "value1"}, { __newindex = mymetatable })

print(mytable.key1)

mytable.newkey = "新值2"
print(mytable.newkey,mymetatable.newkey)

mytable.key1 = "新值1"
print(mytable.key1,mymetatable.key1)

--[[
value1
nil    新值2
新值1    nil
--]]
```

以上实例中表**设置了元方法 __newindex**，在对新索引键 **（newkey）赋值**时（mytable.newkey = "新值2"），**会调用元方法**，而不进行赋值。而如果对**已存在的索引键（key1）**，则**会进行赋值，而不调用元方法** __newindex。

### 15.4 rawget和rawset

1. rawget

- 绕开__index 只获取表自身属性有没有 （不关心元表的）

2. rawset

- 绕开__newindex 只设置表自身属性 （不重定向到元表__newindex对应的表）


### 15.5 运算元方法-为表添加操作符

1. 表中对应的操作列表如下：(注意：__是两个下划线)

模式|	描述
---|---
__add|	对应的运算符 '+'.
__sub|	对应的运算符 '-'.
__mul|	对应的运算符 '*'.
__div|	对应的运算符 '/'.
__mod|	对应的运算符 '%'.
__unm|	对应的运算符 '-'.
__concat|	对应的运算符 '..'.
__eq|	对应的运算符 '=='.
__lt|	对应的运算符 '<'.
__le|	对应的运算符 '<='.

2. 以下实例演示了两表相加操作：

```lua
-- 计算表中最大值，table.maxn在Lua5.2以上版本中已无法使用
-- 自定义计算表中最大键值函数 table_maxn，即返回表最大键值
function table_maxn(t)
    local mn = 0
    for k, v in pairs(t) do
        if mn < k then
            mn = k
        end
    end
    return mn
end

-- 两表相加操作
mytable = setmetatable({ 1, 2, 3 }, {
  __add = function(mytable, newtable)
    for i = 1, table_maxn(newtable) do
      table.insert(mytable, table_maxn(mytable)+1,newtable[i])
    end
    return mytable
  end
})

secondtable = {4,5,6}

mytable = mytable + secondtable
for k,v in ipairs(mytable) do
    print(k,v)
end

--[[
1    1
2    2
3    3
4    4
5    5
6    6
--]]
__add 键包含在元表中，并进行相加操作。 
```

### 15.6 __call元方法

1. __call 元方法在 **Lua 调用一个值时调用（当子表做为函数名字的形式被调用的时候，如mytable(newtable)，会调用__call函数）**。以下实例演示了计算表中元素的和：

```lua
-- 计算表中最大值，table.maxn在Lua5.2以上版本中已无法使用
-- 自定义计算表中最大键值函数 table_maxn，即计算表的元素个数
function table_maxn(t)
    local mn = 0
    for k, v in pairs(t) do
        if mn < k then
            mn = k
        end
    end
    return mn
end

-- 定义元方法__call
mytable = setmetatable({10}, {
  __call = function(mytable, newtable)
        sum = 0
        for i = 1, table_maxn(mytable) do
                sum = sum + mytable[i]
        end
        for i = 1, table_maxn(newtable) do
                sum = sum + newtable[i]
        end
        return sum
  end
})
newtable = {10,20,30}
print(mytable(newtable))

--[[
70
--]]
```

### 15.7 __tostring 元方法

1. __tostring 元方法用于修改表的输出行为。以下实例我们自定义了表的输出内容：

```lua
mytable = setmetatable({ 10, 20, 30 }, {
  __tostring = function(mytable)
    sum = 0
    for k, v in pairs(mytable) do
                sum = sum + v
        end
    return "表所有元素的和为 " .. sum
  end
})
print(mytable)

--[[
表所有元素的和为 60    
--]]
```

# 十六 协同程序（coroutine）（⭐⭐⭐）

### 16.1 什么是协同（coroutine）

1. Lua 协同程序(coroutine)与线程比较类似：**拥有独立的堆栈，独立的局部变量，独立的指令指针，同时又与其它协同程序共享全局变量和其它大部分东西**。
2. 协同程序可以理解为**一种特殊的线程**，可以**暂停和恢复其执行**，从而允许非抢占式的多任务处理。
3. 协同是非常强大的功能，但是用起来也很复杂。

### 16.2 基本语法

1. **协同程序由 coroutine 模块**提供支持。

2. 使用协同程序，你可以在函数中使用 **coroutine.create 创建一个新的协同程序对象**，并使用 **coroutine.resume 启动它的执行**。协同程序可以通过调用 **coroutine.yield 来主动暂停自己的执行**，并将控制权交还给调用者。
3. 具体函数方法

方法|	描述
---|---
coroutine.create()|	**创建 coroutine，返回 coroutine**， 参数是一个函数，当和 resume 配合使用的时候就唤醒函数调用
coroutine.resume()|	**重启 coroutine**，和 create 配合使用。**正常结束返回true+yield的返回值，否则返回false+yield的返回值（一般对已结束的协程resume就会false）**。**返回值是yield()的参数。**
coroutine.yield()|	**挂起 coroutine**，将 coroutine 设置为挂起状态，这个和 resume 配合使用能有很多有用的效果。**返回值是resume调用时传入的值**。
coroutine.status()|	**查看 coroutine 的状态**<br>注：coroutine 的状态有三种：dead，suspended，running(已结束、已挂起、运行中),具体什么时候有这样的状态请参考下面的程序。
coroutine.wrap()|	**创建 coroutine，返回一个函数，一旦你调用这个函数，就进入 coroutine，和 create 功能重复** 
coroutine.running()|	**返回正在跑的 coroutine**，一个 coroutine 就是一个线程，当使用running的时候，就是**返回一个 coroutine 的线程号** + **true/false**

4. 以下实例演示了如何使用 Lua 协同程序：

```lua
function foo()
    print("协同程序 foo 开始执行")
    local value = coroutine.yield("暂停 foo 的执行")
    print("协同程序 foo 恢复执行，传入的值为: " .. tostring(value))
    print("协同程序 foo 结束执行")
end

-- 创建协同程序
local co = coroutine.create(foo)

-- 启动协同程序
local status, result = coroutine.resume(co)
print(result) -- 输出: 暂停 foo 的执行

-- 恢复协同程序的执行，并传入一个值
status, result = coroutine.resume(co, 42)
print(result) -- 输出: 协同程序 foo 恢复执行，传入的值为: 42
```

- 以上实例中，我们**定义了一个名为 foo 的函数作为协同程序**。在函数中，我们**使用 coroutine.yield 暂停了协同程序的执行，并返回了一个值**

- 在主程序中，我们使用 **coroutine.create 创建了一个协同程序对象**，并使用 **coroutine.resume 启动了它的执行**。

- 在**第一次调用 coroutine.resume 后，协同程序执行到 coroutine.yield 处暂停**，**并将值返回给主程序**。然后，我们**再次调用 coroutine.resume，并传入一个值作为协同程序恢复执行时的参数**。

执行以上代码输出结果为：
```
协同程序 foo 开始执行
暂停 foo 的执行
协同程序 foo 恢复执行，传入的值为: 42
协同程序 foo 结束执行
nil
```

### 16.3 各个语法的用法实例

1. 实例1

```lua
-- coroutine_test.lua 文件
-- 创建了一个新的协同程序对象 co，其中协同程序函数打印传入的参数 i
co = coroutine.create(
    function(i)
        print(i);
    end
)
-- 使用 coroutine.resume 启动协同程序 co 的执行，并传入参数 1。协同程序开始执行，打印输出为 1
coroutine.resume(co, 1)   -- 1

-- 通过 coroutine.status 检查协同程序 co 的状态，输出为 dead，表示协同程序已经执行完毕
print(coroutine.status(co))  -- dead
 
print("----------")

-- 使用 coroutine.wrap 创建了一个协同程序包装器，将协同程序函数转换为一个可直接调用的函数对象
co = coroutine.wrap(
    function(i)
        print(i);
    end
)
 
co(1)
 
print("----------")
-- 创建了另一个协同程序对象 co2，其中的协同程序函数通过循环打印数字 1 到 10，在循环到 3 的时候输出当前协同程序的状态和正在运行的线程
co2 = coroutine.create(
    function()
        for i=1,10 do
            print(i)
            if i == 3 then
                print(coroutine.status(co2))  --running
                print(coroutine.running()) --thread:XXXXXX
            end
            coroutine.yield()
        end
    end
)

-- 连续调用 coroutine.resume 启动协同程序 co2 的执行
coroutine.resume(co2) --1
coroutine.resume(co2) --2
coroutine.resume(co2) --3

-- 通过 coroutine.status 检查协同程序 co2 的状态，输出为 suspended，表示协同程序暂停执行
print(coroutine.status(co2))   -- suspended
print(coroutine.running())
 
print("----------")
```

输出结果为

```lua
1
dead
----------
1
----------
1
2
3
running
thread: 0x7fb801c05868    false
suspended
thread: 0x7fb801c04c88    true
----------
```
coroutine.running就可以看出来,**coroutine在底层实现就是一个线程**。

当**create一个coroutine的时候就是在新线程中注册了一个事件**。

当**使用resume触发事件的时候**，create的**coroutine函数就被执行了**，当**遇到yield的时候就代表挂起当前线程**，**等候再次resume触发事件**。

2. 接下来我们分析一个更详细的实例：

```lua {.line-numbers}
function foo (a)
    print("foo 函数输出", a)
    return coroutine.yield(2 * a) -- 返回  2*a 的值
end
 
co = coroutine.create(function (a , b)
    print("第一次协同程序执行输出", a, b) -- co-body 1 10
    local r = foo(a + 1)
     
    print("第二次协同程序执行输出", r)
    local r, s = coroutine.yield(a + b, a - b)  -- a，b的值为第一次调用协同程序时传入
     
    print("第三次协同程序执行输出", r, s)
    return b, "结束协同程序"                   -- b的值为第二次调用协同程序时传入
end)
        
print("main", coroutine.resume(co, 1, 10)) -- true, 4
print("--分割线----")
print("main", coroutine.resume(co, "r")) -- true 11 -9
print("---分割线---")
print("main", coroutine.resume(co, "x", "y")) -- true 10 end
print("---分割线---")
print("main", coroutine.resume(co, "x", "y")) -- cannot resume dead coroutine
print("---分割线---")

--[[
第一次协同程序执行输出    1    10
foo 函数输出    2
main    true    4
--分割线----
第二次协同程序执行输出    r
main    true    11    -9
---分割线---
第三次协同程序执行输出    x    y
main    true    10    结束协同程序
---分割线---
main    false    cannot resume dead coroutine
---分割线---
--]]
```

对以上程序进行详细流程说明（⭐⭐⭐）:

- 首先按正常流程走到第6行创建协程，但没有启动
- 运行**17行**启动协程co。传入参数1，10。
- 此时**6行**的匿名函数参数a，b的值为1，10
- 运行**7行** 输出 **<font color="red">第一次协同程序执行输出    1    10</font>**
- 运行**8行**执行函数1行foo，传入参数a+1 (即1+1 为2)
- 此时**1行**的函数foo参数a的值为2
- 运行**2行** 输出 **<font color="red">foo 函数输出    2</font>**
- 运行**3行** **中断协程**，此时返回给**17行**的coroutine.resume(co, 1, 10) 返回值。 返回值构成为两部分：
  - true(正常结束返回true，**一般对已结束的协程resume就会false**)
  - 3行中coroutine.yield(2 * a)中的所有参数，这里为 2\*a （即 2\*2 为 4）
  - 最终返回值为 true, 4
- 返回到**17行** 输出 **<font color="red">main    true    4</font>**
- 运行**18行** 输出 **<font color="red">--分割线----</font>**
- \--------------------------------------------------------------------------------------------------------
- 运行**19行**再次启动协程co，传入参数“r”，并从上一次终端的位置开始运行，即**3行**
- 运行**3行** 此时 **coroutine.yield(2 * a)** 的值**为再次启动协程时传入的参数**，即**19行传入的参数 “r”**
  - **因此3行执行的代码为 return "r"**
- 运行**4行** end
- 返回**8行** 得到foo（a+1）的返回值为3行的返回值 **“r”**,并赋值给本地变量r
- 运行**10行** 输出 **<font color="red">第二次协同程序执行输出    r</font>**
- 运行**11行** **中断协程**，此时返回给**19行** 的coroutine.resume(co, 1, 10) 返回值.返回值构成为：
  - true(正常结束返回true，**一般对已结束的协程resume就会false**)
  - coroutine.yield(a + b, a - b)中的所有参数，即a + b, a - b -> 1+10 , 1-10 -> 11,-9 **(a，b的值为第一次调用协同程序时传入)**
  - 最终返回值为 true, 11, -9
- 返回**19行** 输出 **<font color="red">main    true    11    -9</font>**
- 运行**20行** 输出 **<font color="red">---分割线---</font>**
- \--------------------------------------------------------------------------------------------------------
- 运行**21行** **同理19行**，再次启动协程co，传入参数"x", "y"，并从上一次终端的位置开始运行，即**11行**
- 运行**11行** 此时 **coroutine.yield(a + b, a - b)** 的值**为再次启动协程时传入的参数**，即**21行传入的参数 "x", "y"**
  - **因此11行执行的代码为 local r, s = "x", "y"**
- 运行**13行** 输出 **<font color="red">第三次协同程序执行输出    x    y</font>**
- 运行**14行** 返回协程返回值，构成为：
  - true(正常结束返回true，**一般对已结束的协程resume就会false**)
  - 协程正常返回值，即**b, "结束协同程序"** 。**(a，b的值为第一次调用协同程序时传入)**
  - 最终返回值为 true, 10, "结束协同程序"
- 返回**21行** 输出 **<font color="red">main    true    10    结束协同程序</font>**
- 运行**22行** 输出 **<font color="red">---分割线---</font>**
- 运行**23行** 由于协程运行完成，因此启用协程会失败。输出 **<font color="red">main    false    cannot resume dead coroutine</font>**
- 运行**24行** 输出 **<font color="red">---分割线---</font>**

### 16.4 生产者-消费者问题

1. 使用Lua的协同程序来完成生产者-消费者这一经典问题。

```lua
local newProductor

function productor()
     local i = 0
     while true do
          i = i + 1
          send(i)     -- 将生产的物品发送给消费者
     end
end

function consumer()
     while true do
          local i = receive()     -- 从生产者那里得到物品
          print(i)
     end
end

function receive()
     local status, value = coroutine.resume(newProductor)
     return value
end

function send(x)
     coroutine.yield(x)     -- x表示需要发送的值，值返回以后，就挂起该协同程序
end

-- 启动程序
newProductor = coroutine.create(productor)
consumer()
--[[
1
2
3
4
5
6
7
8
9
10
11
12
13
……
--]]
-- 启动程序
newProductor = coroutine.create(productor)
consumer()
```

### 16.5 线程和协同程序区别

1. 线程与协同程序的**主要区别在于，一个具有多个线程的程序可以同时运行几个线程，而协同程序却需要彼此协作的运行**。
2. 在**任一指定时刻只有一个协同程序在运行**，并且这个正在运行的协同程序只有在明确的被要求挂起的时候才会被挂起。
协同程序有点类似同步的多线程，在等待同一个线程锁的几个线程有点类似协同。

3. 主要区别归纳如下：

- **调度方式**：**线程**通常由**操作系统的调度器进行抢占式调度**，操作系统会在不同线程之间切换执行权。而**协同程序**是**非抢占式调度**的，它们由**程序员显式地控制执行权**的转移。

- **并发性**：**线程是并发**执行的，**多个线程可以同时运行**在多个处理器核心上，或者通过时间片轮转在单个核心上切换执行。**协同程序则是协作式**的，**只有一个协同程序处于运行状态**，其他协同程序**必须等待当前协同程序主动放弃执行权**。

- **内存占用**：**线程通常需要独立的堆栈和上下文环境**，因此线程的**创建和销毁**会带来**额外的开销**。而**协同程序可以共享相同的堆栈和上下文**，因此创建和销毁协同程序的**开销较小**。

- **数据共享**：**线程**之间可以**共享内存空间**，但**需要注意线程安全性和同步**问题。**协同程序**通常**通过参数传递和返回值**来进行**数据共享**，**不同协同程序**之间的**数据隔离性较好**。

- 调试和错误处理：**线程通常在调试和错误处理方面更复杂**，因为多个线程之间的交互和并发执行可能导致难以调试的问题。**协同程序则在调试和错误处理方面相对简单**，因为它们是由程序员显式地控制执行流程的。

4. 总体而言，**线程适用于需要并发执行的场景**，例如在多核处理器上利用并行性加快任务的执行速度。而**协同程序适用于需要协作和协调的场景**，例如**状态机、事件驱动编程或协作式任务处理**。选择使用线程还是协同程序取决于具体的应用需求和编程模型。

# 十七 文件I/O

### 17.1 概述及用法

1. Lua I/O 库用于读取和处理文件。分为简单模式（和C一样）、完全模式。

- 简**单模式（simple model）拥有一个当前输入文件和一个当前输出文件**，并且提供针对这些文件相关的操作。
- **完全模式（complete model） 使用外部的文件句柄来实现**。它以一种面对对象的形式，将所有的文件操作定义为文件句柄的方法

2. **简单模式在做一些简单的文件操作时较为合适**。但是在**进行一些高级的文件操作的时候，简单模式就显得力不从心。例如同时读取多个文件这样的操作，使用完全模式则较为合适**。

3. 打开文件操作语句如下：

```lua
file = io.open (filename [, mode])
```

- mode的值有：

模式|	描述
---|---
r|	以**只读方式打开文**件，该**文件必须存在**。
w|	**打开只写文件**，若**文件存在则**文件长度清为0，即**该文件内容会消失**。若**文件不存在则建立该文件**。
a|	以**附加的方式打开只写文件**。若**文件不存在**，则会**建立**该文件，如果**文件存在**，写入的**数据会被加到文件尾**，即文件**原先的内容会被保留**。（EOF符保留）
r+|	以**可读写方式打开文件**，该**文件必须存在**。
w+|	**打开可读写文件**，若****文件存在**则文件长度清为零，即该文件**内容会消失**。若文件**不存在则建立**该文件。
a+|	与**a类似，但此文件可读可写**
b|	**二进制模式，如果文件是二进制文件，可以加上b**
+|	**号表示对文件既可以读也可以写**

### 17.2 简单模式（io.调用）

1. 简单模式使用标准的 I/O 或使用一个当前输入文件和一个当前输出文件。
以下为 file.lua 文件代码，操作的文件为test.lua(如果没有你需要创建该文件)，代码如下：

```lua
-- 以只读方式打开文件
file = io.open("test.lua", "r")

-- 设置默认输入文件为 test.lua
io.input(file)

-- 输出文件第一行
print(io.read())

-- 关闭打开的文件
io.close(file)

-- 以附加的方式打开只写文件
file = io.open("test.lua", "a")

-- 设置默认输出文件为 test.lua
io.output(file)

-- 在文件最后一行添加 Lua 注释
io.write("--  test.lua 文件末尾注释")

-- 关闭打开的文件
io.close(file)
```

执行以上代码，你会发现，输出了 test.lua 文件的第一行信息，并在该文件最后一行添加了 lua 的注释。如我这边输出的是：

```lua
-- test.lua 文件
```

2. 在以上实例中我们使用了 io."x" 方法，其中 io.read() 中我们没有带参数，参数可以是下表中的一个：

模式|	描述
---|---
"*n"|	**读取一个数字并返回它**。例：file.read("*n")
"*a"|	**从当前位置读取整个文件**。例：file.read("*a")
"*l"（默认）|	**读取下一行**，在文件尾 (EOF) 处返回 nil。例：file.read("*l")
number|	**返回一个指定字符个数的字符串**，如果number为0则返回空字串，或在 EOF 时返回 nil。例：file.read(5)

3. 简单模式的I/O方法汇总
参考博客：[lua 的io操作，非常详细。](https://blog.csdn.net/duanxuyun/article/details/4751118)

方法| 描述
---|---
io.close ([file])|　　功能：相当于file:close()，关闭默认的输出文件
io.flush ()|　　功能：相当于file:flush(),**输出所有缓冲中的内容到默认输出文件**
io.lines ([filename])| 功能：打开指定的文件filename为读模式并**返回一个迭代函数（配合循环语句使用）**,每次调用将**获得文件中的一行内容,当到文件尾时，将返回nil,并自动关闭文件**。**若不带参数时io.lines() <=> io.input():lines()**; **读取默认输入设备的内容，但结束时不关闭文件。** <br>如：for line in io.lines("main.lua") do<br>　　print(line)<br>　　end
io.open (filename [, mode])|功能：**按指定的模式打开一个文件**，成功则返回文件句柄，失败则返回nil+错误信息。模式参数说明在 [17.1 概述及用法](#171-概述及用法) 中的第3点有说明
io.output ([file])|　功能：相当于io.input，但操作在默认输出文件上
io.popen ([prog [, mode]])| 功能：开始程序prog于额外的进程,并返回用于prog的文件句柄(并不支持所有的系统平台)
io.read (...)|　功能：从当前输入流输入读取一行，参数在 [17.2 简单模式](#172-简单模式io调用) 中的第2点提到。相当于io.input():read。 **不带参数时，默认每运行一次io.read()就向下读一行**
io.tmpfile ()|功能：返回一个临时文件句柄，该文件以更新模式打开，程序结束时自动删除
io.type (obj)|　功能：检测obj是否一个可用的文件句柄<br>返回：<br>　　"file"：为一个打开的文件句柄<br>　　"closed file"：为一个已关闭的文件句柄<br>　　nil: 表示obj不是一个文件句柄
io.write (...)|　　功能：相当于io.output():write,向文件写入内容，写入方式会根据mode而不同。

### 17.3 完全模式（file:调用）

1. 通常我们**需要在同一时间处理多个文件**。我们需要**使用 file:function_name 来代替 io.function_name 方法**。以下实例演示了如何同时处理同一个文件:
```lua
-- 以只读方式打开文件
file = io.open("test.lua", "r")

-- 输出文件第一行
print(file:read())

-- 关闭打开的文件
file:close()

-- 以附加的方式打开只写文件
file = io.open("test.lua", "a")

-- 在文件最后一行添加 Lua 注释
file:write("--test")

-- 关闭打开的文件
file:close()
```

**read 的参数与简单模式一致。**


2. 完全模式的I/O方法汇总

方法|描述
---|---
file:close()|　功能：关闭文件。　注：**当文件句柄被垃圾收集后，文件将自动关闭。句柄将变为一个不可预知的值**
file:flush()|　功能：向文件写入缓冲中的所有数据
file:lines()|　功能：**返回一个迭代函数（配合循环语句使用）**,每次调用将获得文件中的一行内容,**当到文件尾时，将返回nil,但不关闭文件。** <br>如：for line in file:lines() do body end
file:read(...)|功能：**按指定的格式读取一个文件**,按每个格式函数将**返回一个字串或数字,如果不能正确读取将返回nil**,若**没有指定格式将指默认按行方式**进行**读取**。参数与 [17.2 简单模式](#172-简单模式io调用) 中的第2点相同。 **不带参数时，默认每运行一次io.read()就向下读一行**
file:seek([whence][,offset])|功能：**设置和获取当前文件位置**,**成功则返回最终的文件位置**(按字节),**失败则返回nil加错误信息**<br>参数:<br>　　whence:<br>　　　"set": 从文件头开始<br>　　　"cur": 从当前位置开始[默认]<br>　　　"end": 从文件尾开始<br>　　offset: 默认为0<br>**不带参数file:seek()则返回当前位置**,file:seek("set")**则定位到文件头**,file:seek("end")**则定位到文件尾并返回文件大小**
file:setvbuf(mode,[,size])|功能：**设置输出文件的缓冲模式**<br>　　参数<br>　　mode:<br>　　　"no": 没有缓冲，即直接输出<br>　　　"full": 全缓冲，即当缓冲满后才进行输出操作(也可调用flush马上输出)<br>　　　"line": 以行为单位，进行输出(多用于终端设备)<br>**最后两种模式,size可以指定缓冲的大小**(按字节)，**忽略size将自动调整为最佳的大小**
file:write(...)|功能：**按指定的参数格式输出文件内容，参数必须为字符或数字**，若要输出**其它值**，则需**通过tostring或string.format进行转换**

以下实例使用了 **seek 方法**，**定位到文件倒数第 25 个位置并使用 read 方法的 \*a 参数**，**即从当前位置(倒数第 25 个位置)读取整个文件**:

```lua
-- 以只读方式打开文件
file = io.open("test.lua", "r")

file:seek("end",-25)
print(file:read("*a"))

-- 关闭打开的文件
file:close()

--[[
st.lua 文件末尾--test
--]]

```

# 十八 错误处理

### 18.1 概述

1. 程序运行中错误处理是必要的，在我们进行文件操作，数据转移及web service 调用过程中都会出现不可预期的错误。如果不注重错误信息的处理，就会造成信息泄露，程序无法运行等情况。

2. 任何程序语言中，都需要错误处理。错误类型有：
    - 语法错误
    - 运行错误

### 18.2 语法错误

1.语法错误通常是由于对程序的组件（如运算符、表达式）使用不当引起的。一个简单的实例如下：

```lua
-- test.lua 文件
a == 2
```

以上代码执行结果为：

```lua
lua: test.lua:2: syntax error near '=='
```
正如你所看到的，以上出现了语法错误，一个 "=" 号跟两个 "=" 号是有区别的。一个 "=" 是赋值表达式两个 "=" 是比较运算。

### 18.3 运行错误

1. 运行错误是程序可以正常执行，但是会输出报错信息。如下实例由于参数输入错误，程序执行时报错：

```lua
function add(a,b)
   return a+b
end

add(10)
```

当我们编译运行以上代码时，编译是可以成功的，但在运行的时候会产生如下错误：

```lua
lua: test2.lua:2: attempt to perform arithmetic on local 'b' (a nil value)
stack traceback:
    test2.lua:2: in function 'add'
    test2.lua:5: in main chunk
    [C]: ?
```

lua 里调用函数时，即使实参列表和形参列表不一致也能成功调用，多余的参数会被舍弃，缺少的参数会被补为 nil。
**以上报错信息是由于参数 b 被补为 nil 后，nil 参与了 + 运算**。
假如 add 函数内不是 "return a+b" 而是 "print(a,b)" 的话，结果会变成 "10 nil" 不会报错。

### 18.4 错误处理

可以使用两个函数：**assert 和 error 来处理错误**。实例如下：

1. assert

```lua
local function add(a,b)
   assert(type(a) == "number", "a 不是一个数字")
   assert(type(b) == "number", "b 不是一个数字")
   return a+b
end
add(10)
```

执行以上程序会出现如下错误：

```lua
lua: test.lua:3: b 不是一个数字
stack traceback:
    [C]: in function 'assert'
    test.lua:3: in local 'add'
    test.lua:6: in main chunk
    [C]: in ?

```

实例中**assert首先检查第一个参数，若没问题**，assert**不做任何事情**；**否则**，assert**以第二个参数作为错误信息抛出**。
2. error
- 语法格式：

```lua
error (message [, level])
```

- 功能：**终止正在执行的函数，并返回message的内容作为错误信息**(**error函数永远都不会返回**)
- 通常情况下，error会附加一些错误位置的信息到message头部。
- Level参数指示获得错误的位置:
    - **Level=1[默认]：为调用error位置(文件+行号)**
    - **Level=2：指出哪个调用error的函数的函数**
    - **Level=0:不添加错误位置信息**

### 18.5 pcall 和 xpcall、debug

1. pcall
(1) Lua中处理错误，可以**使用函数pcall（protected call）来包装需要执行的代码**。
(2) pcall接收**一个函数和要传递给后者(即函数)的参数**，并执行，**执行结果: 有错误、无错误**. 返回值**true或false，errorinfo（实际好像只返回一个true或false，没有其他信息）**。

语法格式如下:

```lua
if pcall(function_name, ….) then
-- 没有错误
else
-- 一些错误
end
```

(3) 简单实例：

```lua  {.line-numbers}
f=pcall(function(i) print(i) end, 33)
print(f)
   
t=pcall(function(i) print(i) error('error..') end, 33)
print(t)

--[[
33
true
33
false  
]]
```

第4行 由于error('error..')终止了正在进行的函数  所以返回false 

(4) pcall以一种 **"保护模式"来调用第一个参数**，因此pcall可以**捕获函数执行中的任何错误**。通常在错误发生时，希望落得更多的调试信息，而不只是发生错误的位置。但**pcall返回时，它已经销毁了调用桟的部分内容**。

2. xpcall与debug
(1) Lua提供了xpcall函数，**xpcall接收第二个参数——一个错误处理函数**，当**错误发生**时，**Lua会在调用桟展开（unwind）前调用错误处理函数**，于是就可以**在这个函数中使用debug库来获取关于错误的额外信息**了。

(2) **debug**库提供了两个通用的**错误处理函数**:

- debug.debug：**提供一个Lua提示符，让用户来检查错误的原因**
- debug.traceback：**根据调用桟来构建一个扩展的错误消息**

(3) 实例

```lua
>=xpcall(function(i) print(i) error('error..') end, function() print(debug.traceback()) end, 33)
33
stack traceback:
stdin:1: in function <stdin:1>
[C]: in function 'error'
stdin:1: in function <stdin:1>
[C]: in function 'xpcall'
stdin:1: in main chunk
[C]: in ?
false        nil
```

(4) 实例2

```lua
function myfunction ()
   n = n/nil
end

function myerrorhandler( err )
   print( "ERROR:", err )
end

status = xpcall( myfunction, myerrorhandler )
print( status)
```

执行以上程序会出现如下错误：

```lua
ERROR:    test2.lua:2: attempt to perform arithmetic on global 'n' (a nil value)
false
```

# 十九 调试(Debug)

### 19.1 概述及Debug的方法

1. Lua 提供了 debug 库用于提供创建我们自定义调试器的功能。Lua 本身并未有内置的调试器，但很多开发者共享了他们的 Lua 调试器代码。

2. Lua 中 debug 库包含以下函数：

序号	|方法 | 用途
---|---|---
1|	debug()|**进入一个用户交互模式，运行用户输入的每个字符串**。 使用简单的命令以及其它调试设置，用户可以检阅全局变量和局部变量， 改变变量的值，计算一些表达式，等等。<br>输入一行仅包含 cont 的字符串将结束这个函数， 这样调用者就可以继续向下运行。
2|	getfenv(object)|**返回对象的环境变量**。
3|	gethook(optional thread)|**返回三个表示线程钩子设置的值**： 当前钩子函数，当前钩子掩码，当前钩子计数
4|	getinfo ([thread,] f [, what])|**返回关于一个函数信息的表**。 你可以直接提供该函数， 也可以用一个数字 f 表示该函数。 数字 **f 表示运行在指定线程的调用栈对应层次上的函数**： **0 层表示当前函数**（**getinfo 自身**）； **1 层表示调用 getinfo 的函数** （除非是尾调用，这种情况不计入栈）；等等。 如果 **f 是一个比活动函数数量还大的数字**， getinfo **返回 nil**。
5|	debug.getlocal ([thread,] f, local)|此函数**返回在栈的 f 层处函数的索引为 local 的局部变量 的名字和值**。 这个函数不仅用于访问显式定义的局部变量，也包括形参、临时变量等。
6|	getmetatable(value)|**把给定索引指向的值的元表压入堆栈**。如果**索引无效**，或是这个值没有元表，**函数将返回 0 并且不会向栈上压任何东西**。
7.|	getregistry()|**返回注册表表**，这是一个预定义出来的表， 可以用来**保存任何 C 代码想保存的 Lua 值**。
8|	getupvalue (f, up)|此函数**返回函数 f 的第 up 个上值的名字和值(即函数中定义的第up个变量的名和值)**。 如果该函数没有那个上值，返回 nil 。<br>以 '(' （开括号）打头的变量名表示没有名字的变量 （去除了调试信息的代码块）。
9|	sethook ([thread,] hook, mask [, count])|**将一个函数作为钩子函数设入**。 字符串 mask 以及数字 count **决定了钩子将在何时调用**。 掩码是由下列字符组合成的字符串，每个字符有其含义：**<br>'c': 每当 Lua 调用一个函数时，调用钩子；<br>'r': 每当 Lua 从一个函数内返回时，调用钩子；<br>'l': 每当 Lua 进入新的一行时，调用钩子**。
10|	setlocal ([thread,] level, local, value)|这个函数**将 value 赋给 栈上第 level 层函数的第 local 个局部变量**。 如果**没有**那个变量，函数**返回 nil** 。 如果 level**越界**，**抛出**一个**错误**。
11|	setmetatable (value, table)|**将 value 的元表设为 table**（可以是 nil）。 返回 value。
12|	setupvalue (f, up, value)|**这个函数将 value 设为函数 f 的第 up 个上值**。 如果函数没有那个上值，返回 nil 否则，返回该上值的名字。
13|	traceback ([thread,] [message [, level]])|**如果 message 有，且不是字符串或 nil， 函数不做任何处理直接返回 message**。 **否则**，它**返回调用栈的栈回溯信息**。 字符串可选项 message 被添加在栈回溯信息的开头。 数字**可选项 level 指明从栈的哪一层开始回溯** （**默认为 1 **，即调用 traceback 的那里）。

3. 上表列出了我们常用的调试函数，接下来我们可以看些简单的例子：

```lua
function myfunction ()
print(debug.traceback("Stack trace"))
print(debug.getinfo(1))
print("Stack trace end")
        return 10
end
myfunction ()
print(debug.getinfo(1))
```

执行以上代码输出结果为：

```lua
Stack trace
stack traceback:
c:\Users\XXX\Desktop\notes\Lua\test.lua:2: in function 'myfunction'
c:\Users\XXX\Desktop\notes\Lua\test.lua:7: in main chunk
[C]: ?
table: 03069D28
Stack trace end
table: 03069C60
```

4. 我们经常需要调试函数的内的局部变量。我们可以使用 setupvalue 函数来设置这些局部变量。实例如下：

```lua
function newCounter ()
  local n = 0
  local k = 0
  return function ()
    k = n
    n = n + 1
    return n
    end
end

counter = newCounter ()
print(counter())
print(counter())

local i = 1

repeat
  name, val = debug.getupvalue(counter, i)
  if name then
    print ("index", i, name, "=", val)
        if(name == "n") then
                debug.setupvalue (counter,2,10)
        end
    i = i + 1
  end -- if
until not name

print(counter())
```

执行以上代码输出结果为：

```lua
1
2
index    1    k    =    1
index    2    n    =    2
11
```
在以上实例中，计数器在每次调用时都会自增1。实例中我们使用了 getupvalue 函数查看局部变量的当前状态。我们可以**设置局部变量为新值。实例中，在设置前 n 的值为 2,使用 setupvalue 函数将其设置为 10。现在我们调用函数，执行后输出为 11 而不是 3**。

### 19.2 调试类型

- 命令行调试
  - 命令行调试器有：RemDebug、clidebugger、ctrace、xdbLua、LuaInterface - Debugger、Rldb、ModDebug。
- 图形界面调试
  - 图形界调试器有：SciTE、Decoda、ZeroBrane Studio、akdebugger、luaedit。

# 二十 垃圾回收

### 20.1 概述

1. Lua 采用了**自动内存管理**。 这意味着你**不用操心**新创建的对象需要的内存如何分配出来， 也不用考虑在对象不再被使用后怎样释放它们所占用的内存。

2. Lua运行了一个**垃圾收集器**来收集所有**死对象** （即在 Lua 中不可能再访问到的对象）**来完成自动内存管理的工作**。 Lua 中所有用到的内存，如：**字符串、表、用户数据、函数、线程、 内部结构等，都服从自动管理**。

3. Lua 实现了一个**增量标记-扫描收集器**。 它**使用这两个数字来控制垃圾收集循环**： **垃圾收集器间歇率和垃圾收集器步进倍率**。 这两个数字都使用百分数为单位 （例如：值 100 在内部表示 1 ）。

4. **垃圾收集器间歇率**控制着收集器需要在**开启新的循环前要等待多久**。 **增大这个值会减少收集器的积极性**。 当这个值比 100 小的时候，收集器在开启新的循环前不会有等待。 设置这个值为 200 就会让收集器等到总内存使用量达到 之前的两倍时才开始新的循环。

5. **垃圾收集器步进倍率**控制着**收集器运作速度相对于内存分配速度的倍率**。 增大这个值**不仅会让收集器更加积极，还会增加每个增量步骤的长度**。 不要把这个值设得小于 100 ， 那样的话收集器就工作的太慢了以至于永远都干不完一个循环。 默认值是 200 ，这表示收集器以内存分配的"两倍"速工作。

6. 如果你把步进倍率设为一个非常大的数字 （比你的程序可能用到的字节数还大 10% ）， 收集器的行为就像一个 stop-the-world 收集器。 接着你若把间歇率设为 200 ， 收集器的行为就和过去的 Lua 版本一样了： 每次 Lua 使用的内存翻倍时，就做一次完整的收集。

### 20.2 垃圾回收器函数

1. Lua 提供了以下函数**collectgarbage ([opt [, arg]])**用来控制自动内存管理，根据**参数opt的不同，提供不同的功能**:

- collectgarbage("collect"): **做一次完整的垃圾收集循环**。通过参数 opt 它提供了一组不同的功能：

- collectgarbage("count"): **以 K 字节数为单位返回 Lua 使用的总内存数**。 这个值有小数部分，所以只需要**乘上 1024 就能得到 Lua 使用的准确字节数**（除非溢出）。

- collectgarbage("restart"): **重启垃圾收集器的自动运行**。

- collectgarbage("setpause"): 将 **arg 设为收集器的 间歇率**。 **返回 间歇率 的前一个值**。

- collectgarbage("setstepmul"): 返回 **步进倍率 的前一个值**。

- collectgarbage("step"): **单步运行垃圾收集器**。 步长"大小"由 arg 控制。 传入 0 时，收集器步进（不可分割的）一步。 传入非 0 值， 收集器收集相当于 Lua 分配这些多（K 字节）内存的工作。 如果收集器结束一个循环将返回 true 。

- collectgarbage("stop"): **停止垃圾收集器的运行**。 在调用重启前，收集器只会因显式的调用运行。

2. 实例

```lua
mytable = {"apple", "orange", "banana"}

print(collectgarbage("count"))

mytable = nil

print(collectgarbage("count"))

print(collectgarbage("collect"))

print(collectgarbage("count"))
```
执行以上程序，输出结果如下(注意内存使用的变化)：

```lua
20.9560546875
20.9853515625
0
19.4111328125
```
lua中 有自动定时执行垃圾回收的机制
unity中热更新开发 尽量不要去自动执行垃圾回收

```lua

通过collectgarbage("setpause",100) 设置垃圾回收的间隔时间
通过collectgarbage("setstepmul",200) 设置垃圾回收的速度
通过collectgarbage("stop") 停止自动执行垃圾回收
通过collectgarbage("restart") 重新开始自动执行垃圾回收
通过collectgarbage("step",100) 执行一次垃圾回收
通过collectgarbage("isrunning") 判断垃圾回收是否正在执行
```

# 二十一 面向对象（⭐）

### 21.1 概述

1. 面向对象编程（Object Oriented Programming，OOP）是一种非常流行的计算机编程架构。
以下几种编程语言都支持面向对象编程：

- C++
- Java
- Objective-C
- Smalltalk
- C#
- Ruby

### 21.2 面向对象特征

**一般是 封装、继承、多态**

- 1） 封装：指能够把一个实体的信息、功能、响应都装入一个单独的对象中的特性。
- 2） 继承：继承的方法允许在不改动原程序的基础上对其进行扩充，这样使得原功能得以保存，而新功能也得以扩展。这有利于减少重复编码，提高软件的开发效率。
- 3） 多态：同一操作作用于不同的对象，可以有不同的解释，产生不同的执行结果。在运行时，可以通过指向基类的指针，来调用实现派生类中的方法。
- 4）抽象：抽象(Abstraction)是简化复杂的现实问题的途径，它可以为具体问题找到最恰当的类定义，并且可以在最恰当的继承级别解释问题。

### 21.3 Lua 中面向对象

1. 我们知道，**对象由属性和方法组成**。LUA中最基本的结构是table，所以需要**用table来描述对象的属性**。
2. lua 中的**function 可以用来表示方法**。那么**LUA中的类可以通过 table + function 模拟出来**。
3. 至于**继承，可以通过 metetable 模拟出来**（不推荐用，只模拟最基本的对象大部分实现够用了）。
4. **Lua 中的表不仅在某种意义上是一种对象**。像对象一样，表也有状态（成员变量）；也有与对象的值独立的本性，特别是拥有两个不同值的对象（table）代表两个不同的对象；一个对象在不同的时候也可以有不同的值，但他始终是一个对象；与对象类似，表的生命周期与其由什么创建、在哪创建没有关系。对象有他们的成员函数，表也有：

```lua
Account = {balance = 0}
function Account.withdraw (v)
    Account.balance = Account.balance - v
end
```

这个定义创建了一个新的函数，并且保存在Account对象的withdraw域内，下面我们可以这样调用：

```lua
Account.withdraw(100.00)
```

### 21.4 简单实例（⭐）

1. 以下简单的类包含了三个属性： area, length 和 breadth，printArea方法用于打印计算结果：

```lua
-- 元类
Rectangle = {area = 0, length = 0, breadth = 0}

-- 派生类的方法 new
function Rectangle:new (o,length,breadth)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.length = length or 0
  self.breadth = breadth or 0
  self.area = length*breadth;
  return o
end

-- 派生类的方法 printArea
function Rectangle:printArea ()
  print("矩形面积为 ",self.area)
end
```

2. 创建对象

创建对象是为类的实例分配内存的过程。每个类都有属于自己的内存并共享公共数据。

```lua
r = Rectangle:new(nil,10,20)
```

3. 访问属性

我们可以使用点号(.)来访问类的属性：

```lua
print(r.length)
```

4. 访问成员函数

我们可以使用冒号 : 来访问类的成员函数：

```lua
r:printArea()
```

内存在对象初始化时分配。

5. 以下我们演示了 Lua 面向对象的完整实例：

```lua
-- 元类
Shape = {area = 0}

-- 基础类方法 new
function Shape:new (o,side)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  side = side or 0
  self.area = side*side;
  return o
end

-- 基础类方法 printArea
function Shape:printArea ()
  print("面积为 ",self.area)
end

-- 创建对象
myshape = Shape:new(nil,10)

myshape:printArea()
```

执行以上程序，输出结果为：

```lua
面积为     100
```

### 21.5 点调用和冒号调用的区别（⭐⭐⭐）

- 点就是正常调用函数
- 冒号是会把 调用者 作为第一个参数传入
- 冒号可以用来声明函数 只能是function 表名::函数名 的形式
- 如果是冒号声明相当于有一个默认参数self
- lua中 有一个关键字 self 表示 默认传入的第一个参数 。用来冒号声明时作为第一个参数的代表
- 注: self不是this 只是第一个参数

```lua
function Student:Speak2()
    -- lua中 有一个关键字 self 表示 默认传入的第一个参数
    print(self.name.."Speak2")
end
Student:Speak2()
Student.Speak2(Student)
```


### 21.6 Lua 继承(⭐⭐⭐)

1. 继承是指一个对象直接使用另一对象的属性和方法。可用于扩展基础类的属性和方法。
以下演示了一个简单的继承实例：

```lua
-- Meta class
Shape = {area = 0}
-- 基础类方法 new
function Shape:new (o,side)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  side = side or 0
  self.area = side*side;
  return o
end
-- 基础类方法 printArea
function Shape:printArea ()
  print("面积为 ",self.area)
end
```

2. Square 对象继承了 Shape 类:

```lua
Square = Shape:new()
-- Derived class method new
function Square:new (o,side)
  o = o or Shape:new(o,side)
  setmetatable(o, self)
  self.__index = self
  return o
end
```

3. 完整示例（⭐⭐⭐）

```lua
-- Meta class
Shape = {area = 0}
-- 基础类方法 new
function Shape:new (o,side)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  side = side or 0
  self.area = side*side;
  return o
end
-- 基础类方法 printArea
function Shape:printArea ()
  print("面积为 ",self.area)
end

-- 创建对象
myshape = Shape:new(nil,10)
myshape:printArea()

Square = Shape:new()
-- 派生类方法 new
function Square:new (o,side)
  o = o or Shape:new(o,side)
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 派生类方法 printArea
function Square:printArea ()
  print("正方形面积为 ",self.area)
end

-- 创建对象
mysquare = Square:new(nil,10)
mysquare:printArea()

Rectangle = Shape:new()
-- 派生类方法 new
function Rectangle:new (o,length,breadth)
  o = o or Shape:new(o)
  setmetatable(o, self)
  self.__index = self
  self.area = length * breadth
  return o
end

-- 派生类方法 printArea
function Rectangle:printArea ()
  print("矩形面积为 ",self.area)
end

-- 创建对象
myrectangle = Rectangle:new(nil,10,20)
myrectangle:printArea()
```

### 21.7 Lua多态（函数重写）

Lua 中我们可以重写基础类的函数，在派生类中定义自己的实现方式：

```lua
-- 派生类方法 printArea
function Square:printArea ()
  print("正方形面积 ",self.area)
end
```

# 二十二 数据库访问（LuaSQL）

### 22.1 概述

1. 本文主要为大家介绍 Lua 数据库的操作库：LuaSQL。他是开源的，支持的数据库有：ODBC, ADO, Oracle, MySQL, SQLite 和 PostgreSQL。
2. 本文介绍MySQL的数据库连接。

### 22.2 安装

1. LuaSQL 可以使用 [LuaRocks](https://luarocks.org/) 来安装可以根据需要安装你需要的数据库驱动。
LuaRocks 安装方法：

```shell
$ wget http://luarocks.org/releases/luarocks-2.2.1.tar.gz
$ tar zxpf luarocks-2.2.1.tar.gz
$ cd luarocks-2.2.1
$ ./configure; sudo make bootstrap
$ sudo luarocks install luasocket
$ lua
Lua 5.3.0 Copyright (C) 1994-2015 Lua.org, PUC-Rio
> require "socket"
```

2. Window 下安装 LuaRocks：https://github.com/keplerproject/luarocks/wiki/Installation-instructions-for-Windows

3. 安装不同数据库驱动：

```shell
luarocks install luasql-sqlite3
luarocks install luasql-postgres
luarocks install luasql-mysql
luarocks install luasql-sqlite
luarocks install luasql-odbc
```

4. 也可以使用源码安装方式，Lua Github 源码地址：https://github.com/keplerproject/luasql

### 22.3 实例

```lua
require "luasql.mysql"

--创建环境对象
env = luasql.mysql()

--连接数据库
conn = env:connect("数据库名","用户名","密码","IP地址",端口)

--设置数据库的编码格式
conn:execute"SET NAMES UTF8"

--执行数据库操作
cur = conn:execute("select * from role")

row = cur:fetch({},"a")

--文件对象的创建
file = io.open("role.txt","w+");

while row do
    var = string.format("%d %s\n", row.id, row.name)

    print(var)

    file:write(var)

    row = cur:fetch(row,"a")
end


file:close()  --关闭文件对象
conn:close()  --关闭数据库连接
env:close()   --关闭数据库环境
```