//
//  MmiaDetailGoodsViewController.h
//  MmiaHD
//
//  Created by lixiao on 15/3/16.
//  Copyright (c) 2015年 yhx. All rights reserved.
//
/*商品详情页*/

#import <UIKit/UIKit.h>
#import "StackBaseViewController.h"
#import "MagazineItem.h"

typedef NS_ENUM(NSInteger, MmiaEnterType){
    MmiaEnterTypeLike = 0,
    MmiaEnterTypeDynamic = 1,
    MmiaEnterTypeSpecialDetail = 2,
    MmiaEnterTypeRecommand = 3,
};

typedef void (^doLikeClickBlock) (BOOL isLike, NSIndexPath *indexPath);

@interface MmiaDetailGoodsViewController : StackBaseViewController

@property (nonatomic)  MmiaEnterType enterType;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, copy)   doLikeClickBlock doLikeClickBlock;

- (id)initWithMagezineItem:(MagazineItem *)item IndexPath:(NSIndexPath *)indexPath;

@end
