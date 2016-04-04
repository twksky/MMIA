//
//  MMiaLikeViewController.h
//  MMIA
//
//  Created by MMIA-Mac on 14-9-10.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMiaBaseViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MMiaNoDataView.h"
#import "MagezineItem.h"

@class MMiaLikeViewController;
@protocol MMiaLikeViewControllerDelegate <NSObject>

-(void)likeviewController:(MMiaLikeViewController *)viewController didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)likeScrollViewDidScrollViewController:(MMiaLikeViewController *)viewController ContentOffset:(CGFloat)contentOffsetY contentInset:(CGFloat)contentInset;

@end

@interface MMiaLikeViewController : UIViewController<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource,MMiaLikeViewControllerDelegate>

//必须写的
@property (nonatomic, assign) NSInteger    userId;
@property (nonatomic, assign) BOOL isOthers;
///
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, retain) MMiaNoDataView    *noDataView;
@property (nonatomic, assign) CGFloat   collectionInset;
@property (nonatomic, assign) BOOL     isLoadding;
@property (nonatomic, assign) BOOL     isRefresh;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) MagezineItem *selectItem;
@property (nonatomic, strong) NSMutableArray  *likeDataArr;

@property (nonatomic, assign) id<MMiaLikeViewControllerDelegate>delegate;

- (void)getProductLikeDataByRequest:(NSInteger)start;
- (void)viewBackToOriginalPosition;

@end
