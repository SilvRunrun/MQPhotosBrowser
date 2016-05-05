//
//  MQPhotosBrowser.h
//  MQPhotosBrowser
//
//  Created by ma on 16/1/15.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQPhotosBrowser : UIView
+ (instancetype)photoViewWithUrls:(NSArray *)urls sourceViews:(NSArray *)sourceViews andCurrentIndex:(NSInteger)currentIndex;
+ (instancetype)photoViewWithUrls:(NSArray *)urls currentPlaceHolder:(UIImage *)currentPlaceHolder andCurrentIndex:(NSInteger)currentIndex;
+ (instancetype)photoViewWithLocalSourceViews:(NSArray *)sourceViews andCurrentIndex:(NSInteger)currentIndex;
+ (instancetype)photoViewWithLocalImages:(NSArray *)images andCurrentIndex:(NSInteger)currentIndex;
- (void)show;
@end
