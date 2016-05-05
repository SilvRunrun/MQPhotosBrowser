//
//  MainCell.h
//  MQPhotosBrowser
//
//  Created by ma on 16/1/13.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,copy) NSString *url;
@end
