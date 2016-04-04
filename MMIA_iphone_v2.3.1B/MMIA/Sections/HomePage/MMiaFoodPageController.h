//
//  MMiaFoodPageController.h
//  MMIA
//
//  Created by yhx on 14-10-30.
//  Copyright (c) 2014年 广而告之. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMiaFoodPageController : UIViewController

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, assign) CGFloat   collectionInset;
@property (nonatomic ,strong) UILabel *titleView;

- (void)refreshPageData:(NSArray *)dataArray downNum:(NSInteger)num;
- (void)netWorkError:(NSError *)error;
- (void)viewBackToOriginalPosition;

@end
