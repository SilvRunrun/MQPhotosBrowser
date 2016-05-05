//
//  MQPhotoView.h
//  MQPhotosBrowser
//
//  Created by ma on 16/1/15.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MQPhotoView;
@protocol MQPhotoViewDelegate <NSObject>
- (void)photoViewSingleTapped:(MQPhotoView *)photoView;
- (void)photoViewImageLoaded;
@end

@class MQPhoto;
@interface MQPhotoView : UIScrollView
@property (nonatomic,strong,readonly) UIImageView *imageView;    //图片视图
@property (nonatomic,assign) NSInteger index;       //所有图片的所在索引
@property (nonatomic,strong) MQPhoto *photo;        //模型
@property (nonatomic,weak) id<MQPhotoViewDelegate> photoViewDelegate;    //代理
@end
