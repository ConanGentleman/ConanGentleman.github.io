---
title: 解决Hexo图片不显示的问题
date: 2024-08-11 13:27:23
tags: hexo博客搭建
categories: hexo博客搭建
---

在本地markdown上，照片能正常显示，但是部署后却不显示。看了一下[官方文档](https://hexo.io/zh-cn/docs/asset-folders)，Hexo3以上可以通过设置post_asset_folder来解决。
<!--more-->
1. 在Blog根目录安装插件：

```
npm install hexo-asset-image --save
```
2. 在全局配置文件中找到post_asset_folder并配置

```yml
post_asset_folder: true
marked:
  prependRoot: true
  postAsset: true
```

启用后，资源图片将会被自动解析为其对应文章的路径。 例如： image.jpg 位置为 /2020/01/02/foo/image.jpg ，这表示它是 /2020/01/02/foo/ 文章的一张资源图片， \!\[](image.jpg) 将会被解析为 \<img src="/2020/01/02/foo/image.jpg"> 。