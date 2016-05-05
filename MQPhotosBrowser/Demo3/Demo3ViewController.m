//
//  Demo3ViewController.m
//  MQPhotosBrowser
//
//  Created by ma on 16/5/5.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "Demo3ViewController.h"
#import "MQPhotosBrowser.h"

@interface Demo3ViewController ()
@property (nonatomic,strong) NSMutableArray *imageViews;
@end

@implementation Demo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageViews = [NSMutableArray array];
    
    [self setupSubviews];
}

- (void)setupSubviews{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    CGFloat margin = 2;
    NSInteger countInRow = 2;
    CGFloat imageViewW = (self.view.frame.size.width-(countInRow-1)*margin)/countInRow;
    CGFloat imageViewH = imageViewW * 0.8;
    for (int i = 0; i<9; i++) {
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
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        
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
    //传入所有的已经赋值image的imageView
    MQPhotosBrowser *photosView = [MQPhotosBrowser photoViewWithLocalSourceViews:self.imageViews andCurrentIndex:imageView.tag];
    [photosView show];
}

@end
