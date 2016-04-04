//
//  MmiaDetailSpecialViewController.h
//  MmiaHD
//
//  Created by lixiao on 15/3/10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//
/*专题详情页*/

#import <UIKit/UIKit.h>
#import "StackBaseViewController.h"
#import "MagazineItem.h"

@interface MmiaDetailSpecialViewController : StackBaseViewController

@property (nonatomic, retain) UICollectionView *collectionView;
//专题推荐
@property (nonatomic, retain) UICollectionView *recommendCollectionView;

- (id)initWithUserId:(NSInteger)userId Item:(MagazineItem *)item;

@end
