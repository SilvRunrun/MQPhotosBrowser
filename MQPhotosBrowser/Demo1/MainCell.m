//
//  MainCell.m
//  MQPhotosBrowser
//
//  Created by ma on 16/1/13.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "MainCell.h"
#import "UIImageView+WebCache.h"

@interface MainCell ()
@end

@implementation MainCell
- (void)awakeFromNib {
}

- (void)setUrl:(NSString *)url{
    _url = url;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
}
@end
