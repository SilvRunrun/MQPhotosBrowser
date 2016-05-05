//
//  Demo1ViewController.m
//  MQPhotosBrowser
//
//  Created by ma on 16/5/5.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "Demo1ViewController.h"
#import "DataTool.h"
#import "MainCell.h"
#import "MQPhotosBrowser.h"

@interface Demo1ViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *urlsSmall;
@property (nonatomic,strong) NSArray *urlsBig;
@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.urlsSmall = [DataTool getSmallImageUrls];
    self.urlsBig = [DataTool getBigImageUrls];
    
    [self setupSubviews];
}

- (void)setupSubviews{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    NSInteger countIn1Line = 3;
    CGFloat leftRightMargin = 0;
    CGFloat itemMinimumMargin = 2;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat itemW = (screenW - 2*leftRightMargin - (countIn1Line-1)*itemMinimumMargin)/countIn1Line - 1;
    CGFloat itemH = itemW * 0.8;
    
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = itemMinimumMargin;
    layout.sectionInset = UIEdgeInsetsMake(leftRightMargin, leftRightMargin, leftRightMargin, leftRightMargin);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MainCell" bundle:nil] forCellWithReuseIdentifier:@"MainCell"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self. urlsSmall.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCell" forIndexPath:indexPath];
    cell.url = self.urlsSmall[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *imageViews = [NSMutableArray array];
    for (int i = 0; i<self.urlsSmall.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MainCell *cell = (MainCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [imageViews addObject:cell.imageView];
    }
    
    MainCell *cell = (MainCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    //show
    //传入当前点击的placeHolder用于展示MQPhotosBrowser时放大所点击的view，如果传入nil默认会放大一个白色的占位图
    MQPhotosBrowser *photosView = [MQPhotosBrowser photoViewWithUrls:self.urlsBig currentPlaceHolder:cell.imageView.image andCurrentIndex:indexPath.row];
    [photosView show];
}

@end
