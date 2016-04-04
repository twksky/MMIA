//
//  DetailsCell2.h
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"

@interface DetailsCell2 : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) UICollectionReusableView *footCell;
@property (strong, nonatomic) ShareView *shareView;

@end
