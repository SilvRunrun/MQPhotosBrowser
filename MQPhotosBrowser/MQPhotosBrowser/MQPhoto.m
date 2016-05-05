//
//  MQPhoto.m
//  MQPhotosBrowser
//
//  Created by ma on 16/1/15.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "MQPhoto.h"

@implementation MQPhoto
- (void)setSourceView:(UIView *)sourceView{
    _sourceView = sourceView;
    if ([sourceView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)sourceView;
        if (imageView.image) {
            _placeHolder = imageView.image;
        }
    }
    if ([sourceView isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sourceView;
        if (button.currentImage) {
            _placeHolder = button.currentImage;
        }
    }
    if (!_placeHolder) {
        _placeHolder = [self imageWithColor:[UIColor colorWithWhite:0.95 alpha:1]];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color{
    //生成某种颜色的背景UIImage
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
