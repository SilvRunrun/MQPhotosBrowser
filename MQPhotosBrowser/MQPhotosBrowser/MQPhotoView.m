//
//  MQPhotoView.m
//  MQPhotosBrowser
//
//  Created by ma on 16/1/15.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "MQPhotoView.h"
#import "MQPhoto.h"
#import "MQProgressView.h"
#import "UIImageView+WebCache.h"

#define kMinShowProgress 0.06        //显示的最小的进度

@interface MQPhotoView () <UIScrollViewDelegate>
@property (nonatomic,strong) MQProgressView *progressView;  //菊花
@property (nonatomic,strong) UIButton *retryButton;         //重试按钮
@end

@implementation MQPhotoView
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.delegate = self;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    //监听点击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (void)setPhoto:(MQPhoto *)photo{
    _photo = photo;
    //加载图片
    [self loadAndShowImage];
}

#pragma mark - 手势处理
//单击隐藏
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    //移除菊花
    [self.progressView removeFromSuperview];
    self.progressView = nil;
    
    // 通知代理
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTapped:)]) {
        [self.photoViewDelegate photoViewSingleTapped:self];
    }
}

//双击放大
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    //没有原图，不响应
    if (self.photo.image) {
        if (self.zoomScale != self.minimumZoomScale) {
            [self setZoomScale:self.minimumZoomScale animated:YES];
        }else{
            //放大2倍至点击处（放大后点击出居中）
            CGPoint touchPoint = [tap locationInView:self];
            
            //基本尺寸参数
            CGFloat boundsWidth = self.bounds.size.width;
            CGFloat boundsHeight = self.bounds.size.height;
            CGFloat imageWidth = _imageView.image.size.width;
            CGFloat imageHeight = _imageView.image.size.height;
            
            //设置伸缩比例
            CGFloat screenS = boundsHeight/boundsWidth;     //16:9
            CGFloat imageS = imageHeight/imageWidth;        //2:3
            //计算出的scale刚好能让实际图片缩放至...
            CGFloat scale = 1;
            if (screenS>imageS) {
                //...（宽图：高刚好可以放大至屏幕高）
                scale = (imageWidth*boundsHeight)/(imageHeight*boundsWidth);
            }else{
                //...（长图：宽刚好可以放大至屏幕宽）
                //...（长图：宽默认显示与屏幕宽相同）,即1,再放大至最大
                scale = self.maximumZoomScale;
            }
            
            CGFloat delta = 2*scale;
            CGRect rectTozoom=CGRectMake(touchPoint.x-[UIScreen mainScreen].bounds.size.width/delta, touchPoint.y-[UIScreen mainScreen].bounds.size.height/delta, [UIScreen mainScreen].bounds.size.width/scale, [UIScreen mainScreen].bounds.size.height/scale);
            [self zoomToRect:rectTozoom animated:YES];
        }
    }
}

#pragma mark - load
- (void)loadAndShowImage{
    //涉及到重用，之前的菊花啥的先清除掉
    //去除菊花
    [self.progressView removeFromSuperview];
    self.progressView = nil;
    //去除按钮
    [self showRetryButton:NO];
    
    //有原图，直接加载
    if (self.photo.image) {
        self.imageView.image = self.photo.image;
        self.scrollEnabled = YES;
        
        //原图frame
        [self adjustFrame];
    }else{
        //无原图，加载
        self.imageView.image = self.photo.placeHolder;
        self.scrollEnabled = NO;
        
        //占位图frame
        [self adjustFrame];
        
        //之前加载失败了，不再加载，等待用户点击重试
        if (self.photo.failed){
            //重试按钮
            [self showRetryButton:YES];
            return;
        }
        
        //菊花
        CGFloat progressViewWH = 60;
        MQProgressView *progressView = [[MQProgressView alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0-progressViewWH/2.0, self.frame.size.height/2.0-progressViewWH/2.0, progressViewWH, progressViewWH)];
        self.progressView = progressView;
        self.progressView.progress = kMinShowProgress;
        [self addSubview:self.progressView];
        
        //加载图片
        __weak typeof(self) weakSelf = self;
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.photo.imageUrl] options:SDWebImageRetryFailed|SDWebImageHighPriority|SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            CGFloat realProgress = (CGFloat)receivedSize/(CGFloat)expectedSize;
            progressView.progress = realProgress > kMinShowProgress ? realProgress : kMinShowProgress;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //防止重用导致的图片加载错误
            if ([imageURL.absoluteString isEqualToString:weakSelf.photo.imageUrl]) {
                [weakSelf imageDidFinishLoad:image];
            }
        }];
    }
}

- (void)imageDidFinishLoad:(UIImage *)image{
    //移除菊花
    [self.progressView removeFromSuperview];
    self.progressView = nil;
    //成功
    if (image) {
        self.photo.failed = NO;
        
        self.imageView.image = image;
        self.scrollEnabled = YES;
        self.photo.image = image;
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageLoaded)]) {
            [self.photoViewDelegate photoViewImageLoaded];
        }
        
        [self adjustFrame];
    }else{
        self.photo.failed = YES;
        //失败
        [self showRetryButton:YES];
    }
}

- (void)showRetryButton:(BOOL)show{
    if (self.retryButton == nil) {
        //失败
        self.retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.retryButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.retryButton setTitle:@"载入失败，点击重试" forState:UIControlStateNormal];
        [self.retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.retryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.retryButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        self.retryButton.frame = CGRectMake(self.frame.size.width/2.0-80, self.frame.size.height/2.0+50, 160, 32);
        self.retryButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.retryButton.layer.cornerRadius = 5;
        self.retryButton.layer.borderWidth = 0.75;
        self.retryButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        [self.retryButton addTarget:self action:@selector(retryButtonClicked) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.retryButton];
    }
    
    self.retryButton.hidden = !show;
}

- (void)retryButtonClicked{
    self.photo.failed = NO;
    
    [self loadAndShowImage];
}

- (void)adjustFrame{
    if (_imageView.image == nil) return;
    
    //基本尺寸参数
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGFloat imageWidth = _imageView.image.size.width;
    CGFloat imageHeight = _imageView.image.size.height;
    
    //设置伸缩比例
    CGFloat screenS = boundsHeight/boundsWidth;     //16:9
    CGFloat imageS = imageHeight/imageWidth;        //2:3
    //计算出的baseScale刚好能让实际图片缩放至...
    CGFloat baseScale = 1;
    if (screenS>imageS) {
        //...（宽图：高刚好可以放大至屏幕高）
        baseScale = (imageWidth*boundsHeight)/(imageHeight*boundsWidth);
    }else{
        //...（长图：宽刚好可以放大至屏幕宽）
        //...（长图：宽默认显示与屏幕宽相同）,即1
    }
    self.maximumZoomScale = baseScale * 1.5;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    //NSLog(@"%f",baseScale);
    
    //计算imageView的初始frame
    CGFloat imageScale = boundsWidth / imageWidth;
    CGRect imageFrame = CGRectMake(0, MAX(0, (boundsHeight-imageHeight*imageScale)/2), boundsWidth, imageHeight*imageScale);
    self.contentSize = CGSizeMake(CGRectGetWidth(imageFrame), CGRectGetHeight(imageFrame));
    self.imageView.frame = imageFrame;
}

#pragma mark - UIScrollViewDelegate
- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //不断矫正位置
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    //有图的时候才允许缩放
    if (self.photo.image) {
        return self.imageView;
    }
    return nil;
}

@end
