//
//  MQPhotosBrowser.m
//  MQPhotosBrowser
//
//  Created by ma on 16/1/15.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "MQPhotosBrowser.h"
#import "MQPhotoView.h"
#import "SDWebImageManager.h"
#import "JGProgressHUD.h"
#import "MQPhoto.h"

#define kMQPhotosViewMargin 10

@interface MQPhotosBrowser () <UIScrollViewDelegate,MQPhotoViewDelegate>
@property (nonatomic,strong) NSArray *photos;           //所有MQPhoto数组
@property (nonatomic,assign) NSInteger currentIndex;    //当前显示的index

@property (nonatomic,strong) UIView *contentView;               //总视图

@property (nonatomic,strong) UILabel *indexLabel;               //索引标签
@property (nonatomic,strong) UIButton *saveButton;              //保存按钮
@property (nonatomic,strong) UIScrollView *photosScrollView;    //装照片的视图

@property (nonatomic,strong) NSMutableSet *reusablePhotoViews;  //可重用的照片
@property (nonatomic,strong) NSMutableSet *visiblePhotoViews;   //可见的照片
@end

@implementation MQPhotosBrowser
#pragma mark - init
+ (instancetype)photoViewWithUrls:(NSArray *)urls sourceViews:(NSArray *)sourceViews andCurrentIndex:(NSInteger)currentIndex{
    if (sourceViews.count != urls.count || urls.count == 0) {
        return nil;
    }
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i<sourceViews.count; i++) {
        MQPhoto *photo = [[MQPhoto alloc] init];
        photo.imageUrl = urls[i];
        photo.sourceView = sourceViews[i];
        [photos addObject:photo];
    }
    MQPhotosBrowser *photosView = [[MQPhotosBrowser alloc] init];
    photosView.photos = photos;
    photosView.currentIndex = currentIndex;
    return photosView;
}

+ (instancetype)photoViewWithUrls:(NSArray *)urls currentPlaceHolder:(UIImage *)currentPlaceHolder andCurrentIndex:(NSInteger)currentIndex{
    if (urls.count == 0) {
        return nil;
    }
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i<urls.count; i++) {
        MQPhoto *photo = [[MQPhoto alloc] init];
        photo.imageUrl = urls[i];
        if (currentPlaceHolder && i == currentIndex) {
            photo.placeHolder = currentPlaceHolder;
        }else{
            photo.placeHolder = [self imageWithColor:[UIColor colorWithWhite:0.9 alpha:1] size:CGSizeMake(1, 1)];
        }
        [photos addObject:photo];
    }
    MQPhotosBrowser *photosView = [[MQPhotosBrowser alloc] init];
    photosView.photos = photos;
    photosView.currentIndex = currentIndex;
    return photosView;
}

+ (instancetype)photoViewWithLocalSourceViews:(NSArray *)sourceViews andCurrentIndex:(NSInteger)currentIndex{
    if (sourceViews.count == 0) {
        return nil;
    }
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i<sourceViews.count; i++) {
        MQPhoto *photo = [[MQPhoto alloc] init];
        
        UIView *sourceView = sourceViews[i];
        if ([sourceView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)sourceView;
            photo.image = imageView.image;
        }
        if ([sourceView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sourceView;
            photo.image = button.currentImage;
        }
        photo.sourceView = sourceView;
        
        [photos addObject:photo];
    }
    MQPhotosBrowser *photosView = [[MQPhotosBrowser alloc] init];
    photosView.photos = photos;
    photosView.currentIndex = currentIndex;
    return photosView;
}

+ (instancetype)photoViewWithLocalImages:(NSArray *)images andCurrentIndex:(NSInteger)currentIndex{
    if (images.count == 0) {
        return nil;
    }
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i<images.count; i++) {
        MQPhoto *photo = [[MQPhoto alloc] init];
        photo.image = images[i];
        photo.placeHolder = images[i];
        [photos addObject:photo];
    }
    MQPhotosBrowser *photosView = [[MQPhotosBrowser alloc] init];
    photosView.photos = photos;
    photosView.currentIndex = currentIndex;
    return photosView;
}

- (instancetype)init{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        //内容视图
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        
        //索引标签
        CGFloat margin = 15;
        CGFloat indexLabelW = 100;
        CGFloat indexLabelH = 30;
        CGFloat indexLabelY = self.bounds.size.height - indexLabelH - margin;
        CGFloat indexLabelX = self.bounds.size.width/2.0 - indexLabelW/2.0;
        self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(indexLabelX, indexLabelY, indexLabelW, indexLabelH)];
        self.indexLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.12];
        self.indexLabel.layer.cornerRadius = self.indexLabel.frame.size.height/2.0;
        self.indexLabel.clipsToBounds = YES;
        self.indexLabel.adjustsFontSizeToFitWidth = YES;
        self.indexLabel.textColor = [UIColor whiteColor];
        self.indexLabel.textAlignment = NSTextAlignmentCenter;
        self.indexLabel.font = [UIFont boldSystemFontOfSize:16];
        self.indexLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.indexLabel.shadowOffset = CGSizeMake(0, -0.5);
        
        //保存按钮
        CGFloat saveButtonH = indexLabelH;
        CGFloat saveButtonW = 50;
        CGFloat saveButtonY = indexLabelY;
        CGFloat saveButtonX = self.bounds.size.width - saveButtonW - margin;
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.saveButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.saveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        self.saveButton.enabled = NO;
        self.saveButton.frame = CGRectMake(saveButtonX, saveButtonY, saveButtonW, saveButtonH);
        self.saveButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
        self.saveButton.layer.cornerRadius = 5;
        self.saveButton.layer.borderWidth = 0.75;
        self.saveButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.36].CGColor;
        [self.saveButton addTarget:self action:@selector(saveCurrentImageToAlbum) forControlEvents:UIControlEventTouchUpInside];
        
        //内部照片视图
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.x -= kMQPhotosViewMargin;
        frame.size.width += 2*kMQPhotosViewMargin;
        self.photosScrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.photosScrollView.backgroundColor = [UIColor clearColor];
        self.photosScrollView.showsHorizontalScrollIndicator = NO;
        self.photosScrollView.showsVerticalScrollIndicator = NO;
        self.photosScrollView.pagingEnabled = YES;
        self.photosScrollView.delegate = self;
        
        //初始化set
        self.reusablePhotoViews = [NSMutableSet set];
        self.visiblePhotoViews = [NSMutableSet set];
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    if (photos.count > 0) {
        for (int i=0; i<photos.count; i++) {
            MQPhoto *photo = _photos[i];
            photo.index = i;
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if (_photosScrollView) {
        [_photosScrollView setContentOffset:CGPointMake(_currentIndex*_photosScrollView.frame.size.width, 0) animated:YES];
        [self updateSubViewsInScrollView];
    }
}

#pragma mark - tool
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    //生成某种颜色的背景UIImage
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - save
- (void)saveCurrentImageToAlbum{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect visibleBounds = self.photosScrollView.bounds;
        NSInteger currentindex = floorf(CGRectGetMidX(visibleBounds)/visibleBounds.size.width);
        MQPhoto *photo = self.photos[currentindex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存失败");
        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        hud.textLabel.text = @"保存失败";
        hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        hud.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
        [hud showInView:self animated:NO];
        [hud dismissAfterDelay:0.58];
    }else{
        NSLog(@"保存成功");
        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        hud.textLabel.text = @"保存成功";
        hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        hud.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
        [hud showInView:self animated:NO];
        [hud dismissAfterDelay:0.58];
    }
}

#pragma mark - dequeue
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //更新
    [self updateSubViewsInScrollView];
    
    //[self test];
}

- (void)test{
    //重用测试
    NSMutableString *testStr = [NSMutableString stringWithString:@"   "];
    NSInteger count = [self.photosScrollView.subviews count];
    for (MQPhotoView *photoView in self.photosScrollView.subviews) {
        [testStr appendFormat:@"%p - ", photoView];
    }
    [testStr appendFormat:@"子视图数量：%ld", (long)count];
    NSLog(@"%@",testStr);
}

- (void)updateSubViewsInScrollView{
    CGRect visibleBounds = self.photosScrollView.bounds;
    CGFloat minX = CGRectGetMinX(visibleBounds);
    CGFloat maxX = CGRectGetMaxX(visibleBounds);
    CGFloat width = CGRectGetWidth(visibleBounds);
    
    //重用的最左边和最右边的index
    NSInteger firstIndex = (NSInteger)floorf((minX+kMQPhotosViewMargin*2)/width);
    NSInteger lastIndex = (NSInteger)floorf((maxX-kMQPhotosViewMargin*2-1)/width);
    
    if (firstIndex < 0) {
        firstIndex = 0;
    }
    if (lastIndex >= self.photos.count) {
        lastIndex = self.photos.count - 1;
    }
    
    //NSLog(@"理论：%ld,%ld",firstIndex,lastIndex);
    
    //回收不再显示的
    for (MQPhotoView *photoView in self.visiblePhotoViews) {
        if (photoView.index < firstIndex || photoView.index > lastIndex) {
            [self.reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }
    [self.visiblePhotoViews minusSet:self.reusablePhotoViews];
    
    //显示新的视图（遍历应当显示的所有index，判断是否已经显示，未显示则显示）
    for (NSInteger i=firstIndex; i<=lastIndex; i++) {
        BOOL isShow = NO;
        for (MQPhotoView *photoView in self.visiblePhotoViews) {
            if (photoView.index == i) {
                isShow = YES;
            }
        }
        if (!isShow) {
            [self showImageViewAtIndex:i];
        }
    }
    
    //标签
    _currentIndex = floorf(CGRectGetMidX(visibleBounds)/visibleBounds.size.width);
    self.indexLabel.text = [NSString stringWithFormat:@"%ld / %ld",self.currentIndex+1,self.photos.count];
    
    //按钮
    MQPhoto *photo = self.photos[_currentIndex];
    self.saveButton.enabled = (photo.image!=nil);
}

- (void)showImageViewAtIndex:(NSInteger)index{
    //加标识符，以防重复显示某一张照片，正在显示的话就不显示了（didScroll调用频繁，会有延迟）
    static NSInteger isShowingIndex = -1;
    //NSLog(@"正在显示：%ld，要显示：%ld",isShowingIndex,index);
    if (index == isShowingIndex) {
        return;
    }
    isShowingIndex = index;

    //重用一个photoView
    MQPhotoView *photoView = [self.reusablePhotoViews anyObject];
    if (photoView) {
        [self.reusablePhotoViews removeObject:photoView];
    }else{
        photoView = [[MQPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        photoView.photoViewDelegate = self;
    }
    
    //配置photoView
    photoView.index = index;
    photoView.photo = self.photos[index];
    
    //添加该视图
    CGRect frame = self.photosScrollView.bounds;
    frame.origin.x = frame.size.width*index + kMQPhotosViewMargin;
    frame.size.width -= 2*kMQPhotosViewMargin;
    photoView.frame = frame;
    
    [self.visiblePhotoViews addObject:photoView];
    [self.photosScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
    
    //显示完重置
    isShowingIndex = -1;
}

- (void)loadImageNearIndex:(NSInteger)index{
    if (index > 0) {
        MQPhoto *photo = self.photos[index-1];
        if (photo.image) {
            return;
        }
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:photo.imageUrl] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        }];
    }
    if (index < self.photos.count-1) {
        MQPhoto *photo = self.photos[index+1];
        if (photo.image) {
            return;
        }
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:photo.imageUrl] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        }];
    }
}

#pragma mark - photoView delegate
- (void)photoViewSingleTapped:(MQPhotoView *)photoView{
    [self dismiss];
}

- (void)photoViewImageLoaded{
    [self updateSubViewsInScrollView];
}

#pragma mark - private
//传入源视图，会从源视图开始放大。没有传的话，会使用此方法返回的frame
- (CGRect)defaultShowFrame{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat frameWH = screenW/3.0;
    CGFloat frameX = screenW/2.0 - frameWH/2.0;
    CGFloat frameY = screenH/2.0 - frameWH/2.0;
    return CGRectMake(frameX, frameY, frameWH, frameWH);
}

#pragma mark - public
- (void)show{
    //设置大小
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x -= kMQPhotosViewMargin;
    frame.size.width += 2*kMQPhotosViewMargin;
    self.photosScrollView.contentSize = CGSizeMake(frame.size.width*self.photos.count, self.photosScrollView.frame.size.height);
    self.photosScrollView.contentOffset = CGPointMake(frame.size.width*self.currentIndex, 0);
    
    [self updateSubViewsInScrollView];
    
    //添加视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.photosScrollView];
    [self.contentView addSubview:self.indexLabel];
    [self.contentView addSubview:self.saveButton];
    [window addSubview:self];
    self.userInteractionEnabled = YES;
    
    //临时视图
    //计算旧frame
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor redColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    MQPhoto *photo = self.photos[self.currentIndex];
    CGRect oldframe = CGRectZero;
    if (photo.sourceView) {
        oldframe = [photo.sourceView convertRect:photo.sourceView.bounds toView:window];
    }
    else{
        oldframe = [self defaultShowFrame];
    }
    imageView.image = photo.placeHolder;
    //计算新frame
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGFloat imageWidth = [self.photos[self.currentIndex] placeHolder].size.width;
    CGFloat imageHeight = [self.photos[self.currentIndex] placeHolder].size.height;
    CGFloat imageScale = boundsWidth / imageWidth;
    CGRect newFrame = CGRectMake(0, MAX(0, (boundsHeight-imageHeight*imageScale)/2), boundsWidth, imageHeight*imageScale);
    [self.contentView addSubview:imageView];
    
    imageView.frame = oldframe;
    //动画显示
    self.photosScrollView.alpha = 0;
    self.contentView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        imageView.frame = newFrame;
        self.contentView.alpha = 1;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        self.photosScrollView.alpha = 1;
    }];
}

- (void)dismiss{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //临时视图
    //计算新frame
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor redColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    MQPhoto *photo = self.photos[self.currentIndex];
    CGRect newframe = CGRectZero;
    if (photo.sourceView) {
        newframe = [photo.sourceView convertRect:photo.sourceView.bounds toView:window];
    }
    else{
        newframe = [self defaultShowFrame];
    }
    //原来的placeHolder可能是白板，所以用新图
    if (photo.image) {
        imageView.image = photo.image;
    }else{
        imageView.image = photo.placeHolder;
    }
    //计算旧frame(可能缩放过，用缩放过后的frame)
    MQPhotoView *photoView = [self.visiblePhotoViews anyObject];
    CGRect oldFrame = [photoView.imageView convertRect:photoView.imageView.bounds toView:window];
    [self.contentView addSubview:imageView];
    
    self.photosScrollView.alpha = 0;
    imageView.frame = oldFrame;
    [UIView animateWithDuration:0.25 animations:^{
        imageView.frame = newframe;
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
