//
//  MmiaSpecialViewController.h
//  MmiaHD
//
//  Created by lixiao on 15/3/9.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MmiaSpecialViewControllerDelagate <NSObject>

//collectionViewDelegate
- (void)specialVCCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MmiaSpecialViewController : UIViewController

@property (nonatomic, retain) UICollectionView *specialCollectionView;
@property (nonatomic, assign) CGFloat   collectionInset;
@property (nonatomic, assign) id<MmiaSpecialViewControllerDelagate> specialDelegate;

- (id)initWithUserId:(NSInteger)userId;

@property (nonatomic, retain) NSMutableArray *dataArr;

@end
