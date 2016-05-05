//
//  Demo2ViewController.m
//  MQPhotosBrowser
//
//  Created by ma on 16/5/5.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "Demo2ViewController.h"
#import "DataTool.h"
#import "UIImageView+WebCache.h"
#import "MQPhotosBrowser.h"

@interface Demo2ViewController ()
@property (nonatomic,strong) NSMutableArray *imageViews;
@property (nonatomic,strong) NSArray *urlsSmall;
@property (nonatomic,strong) NSArray *urlsBig;
@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageViews = [NSMutableArray array];
    self.urlsSmall = [DataTool getSmallImageUrls];
    self.urlsBig = [DataTool getBigImageUrls];
    
    [self setupSubviews];
}

- (void)setupSubviews{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    CGFloat margin = 2;
    NSInteger countInRow = 2;
    CGFloat imageViewW = (self.view.frame.size.width-(countInRow-1)*margin)/countInRow;
    CGFloat imageViewH = imageViewW * 0.8;
    for (int i = 0; i<self.urlsBig.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSInteger row = i / countInRow;
        NSInteger col = i % countInRow;
        CGFloat imageViewX = (imageViewW + margin)*col;
        CGFloat imageViewY = (imageViewH + margin)*row;
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [scrollView addSubview:imageView];
        
        //image
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlsSmall[i]]];
        
        //tap
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        [imageView addGestureRecognizer:tap];
        
        //imageViews
        [self.imageViews addObject:imageView];
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY([self.imageViews.lastObject frame]));
}

- (void)imageViewTapped:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    //show
    //传入所有的url、imageView和点击的index
    MQPhotosBrowser *photosView = [MQPhotosBrowser photoViewWithUrls:self.urlsBig sourceViews:self.imageViews andCurrentIndex:imageView.tag];
    [photosView show];
}
@end
