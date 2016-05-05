//
//  DemoObject.h
//  MQPhotosBrowser
//
//  Created by ma on 16/5/5.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoObject : NSObject
@property (nonatomic,copy) NSString *demoTitle;
@property (nonatomic,copy) NSString *demoClass;
+ (instancetype)demoWithTitle:(NSString *)title class:(NSString *)demoClass;
@end
