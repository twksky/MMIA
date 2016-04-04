//
//  MmiaLikeViewController.h
//  MmiaHD
//
//  Created by lixiao on 15/3/9.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MmiaLikeViewControllerDelagate <NSObject>

//collectionViewDelegate
- (void)likeVCCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface MmiaLikeViewController : UIViewController

@property (nonatomic, retain) UICollectionView *likeCollectionView;
@property (nonatomic, assign) CGFloat   collectionInset;
@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, assign) id<MmiaLikeViewControllerDelagate> likeDelegate;

- (id)initWithUserId:(NSInteger)userId;

@end
