//
//  Demo4ViewController.m
//  MQPhotosBrowser
//
//  Created by ma on 16/5/5.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "Demo4ViewController.h"
#import "MainCell.h"
#import "MQPhotosBrowser.h"

@interface Demo4ViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation Demo4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i<9; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MainCell *cell = (MainCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [images addObject:cell.imageView.image];
    }
    
    //show
    //传入所有的images
    MQPhotosBrowser *photosView = [MQPhotosBrowser photoViewWithLocalImages:images andCurrentIndex:indexPath.row];
    [photosView show];
}

@end
