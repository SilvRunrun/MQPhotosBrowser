//
//  MQProgressView.m
//  MQProgressView
//
//  Created by ma on 16/1/12.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "MQProgressView.h"

@interface MQProgressView()
@end

@implementation MQProgressView
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - property
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    CGFloat outterLineWidth = 1;
    CGFloat outterInnerMargin = 2;
    CGFloat outterRadius = MIN(rect.size.width/2.0, rect.size.height/2.0)-5;
    CGFloat innerRadius = outterRadius - outterInnerMargin;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //内背景
    UIBezierPath *innerBackPath = [UIBezierPath bezierPathWithArcCenter:center radius:outterRadius startAngle:-M_PI_2 endAngle:-M_PI_2+M_PI*2 clockwise:YES];
    [innerBackPath addLineToPoint:center];
    CGContextAddPath(ctx, innerBackPath.CGPath);
    [[UIColor colorWithWhite:0 alpha:0.3] set];
    CGContextFillPath(ctx);
    
    //外边缘线
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(center.x-outterRadius, center.y-outterRadius, outterRadius*2, outterRadius*2)];
    CGContextAddPath(ctx, roundPath.CGPath);
    [[UIColor colorWithWhite:1 alpha:0.8] set];
    CGContextSetLineWidth(ctx, outterLineWidth);
    CGContextStrokePath(ctx);
    
    //内饼
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:innerRadius startAngle:-M_PI_2 endAngle:-M_PI_2+self.progress*2*M_PI clockwise:YES];
    [path addLineToPoint:center];
    CGContextAddPath(ctx, path.CGPath);
    [[UIColor colorWithWhite:1 alpha:0.8] set];
    CGContextFillPath(ctx);
}

@end
