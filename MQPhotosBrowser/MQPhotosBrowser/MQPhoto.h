//
//  MQPhoto.h
//  MQPhotosBrowser
//
//  Created by ma on 16/1/15.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQPhoto : NSObject
@property (nonatomic,copy) NSString *imageUrl;              //图片url
@property (nonatomic,strong) UIView *sourceView;            //源视图
@property (nonatomic,strong) UIImage *image;                //完整的图片
@property (nonatomic,assign) NSInteger index;               //所在index
@property (nonatomic,strong) UIImage *placeHolder;          //占位图
@property (nonatomic,assign) BOOL failed;                   //载入失败
@end
