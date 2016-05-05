//
//  DemoObject.m
//  MQPhotosBrowser
//
//  Created by ma on 16/5/5.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "DemoObject.h"

@implementation DemoObject
+ (instancetype)demoWithTitle:(NSString *)title class:(NSString *)demoClass{
    DemoObject *demo = [[DemoObject alloc] init];
    demo.demoTitle = title;
    demo.demoClass = demoClass;
    return demo;
}
@end
