//
//  MmiaDynamicViewController.h
//  MmiaHD
//
//  Created by lixiao on 15/3/9.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MmiaDynamicViewControllerDelegate <NSObject>

//collectionViewDelegate
- (void)dynamicVCCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MmiaDynamicViewController : UIViewController

@property (nonatomic, retain) UICollectionView *dynamicCollectionView;
@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, assign) CGFloat   collectionInset;
@property (nonatomic, assign) id<MmiaDynamicViewControllerDelegate> dynamicDelegate;

@end
