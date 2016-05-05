# MQPhotosBrowser


## 概述

**内部UIImageView重用的高性能图片浏览器，支持本地图片和网络图片的加载。**

## 用法

####1.加载网络图片（方式一）
**此方式适用于已有图片地址数组，并在任意界面位置展示一个图片浏览器。**

```
//1.所需参数
//	图片地址数组
NSArray *urls = @[@"url1",@"url2",@"url3"];
//	第一个被展示的图片的占位图，可传nil
UIImage *placeHolder = [UIImage imageNamed:@"placeHolder"];
//	第一个被展示的图片索引
NSInteger currentIndex = 0;

//2.创建MQPhotosBrowser并展示
MQPhotosBrowser *photosView = [MQPhotosBrowser photoViewWithUrls:urls currentPlaceHolder:placeHolder andCurrentIndex:currentIndex];
[photosView show];
```

####2.加载网络图片（方式二）
**此方式适用于已有图片地址数组和所有源视图，在源视图所在界面展示一个图片浏览器。**

**与上一种方式不同之处在于：展示浏览器时会有一个从源视图放大至浏览器的动画效果，且去除浏览器时会有一个从浏览器缩小回源视图的动画效果**

```
//1.所需参数
//	图片地址数组
NSArray *urls = @[@"url1",@"url2",@"url3"];
//	所有源视图
NSArray *sourceViews = @[self.imageView1,self.imageView2,self.imageView3];
//	第一个被展示的图片索引
NSInteger currentIndex = 0;

//2.创建MQPhotosBrowser并展示
MQPhotosBrowser *photosView = [MQPhotosBrowser photoViewWithUrls:urls sourceViews:sourceViews andCurrentIndex:currentIndex];
[photosView show];
```

####3.加载本地图片（方式一）
**此方式适用于已有图片数组，并在任意界面位置展示一个图片浏览器。**

```
//1.所需参数
//	图片数组
NSArray *images = @[image1,image2,image3];
//	第一个被展示的图片索引
NSInteger currentIndex = 0;

//2.创建MQPhotosBrowser并展示
MQPhotosBrowser *photosView = [MQPhotosBrowser photoViewWithLocalImages:images andCurrentIndex:currentIndex];
[photosView show];
```

####4.加载本地图片（方式二）
**此方式适用于已有所有源视图，在源视图所在界面展示一个图片浏览器。**

**与上一种方式不同之处在于：展示浏览器时会有一个从源视图放大至浏览器的动画效果，且去除浏览器时会有一个从浏览器缩小回源视图的动画效果**

```
//1.所需参数
//	所有已经赋值image的源视图
NSArray *sourceViews = @[self.imageView1,self.imageView2,self.imageView3];
//	第一个被展示的图片索引
NSInteger currentIndex = 0;

//2.创建MQPhotosBrowser并展示
MQPhotosBrowser *photosView = [MQPhotosBrowser photoViewWithLocalSourceViews:sourceViews andCurrentIndex:currentIndex];
[photosView show];
```
