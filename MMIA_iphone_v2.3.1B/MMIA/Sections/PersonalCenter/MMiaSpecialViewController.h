//
//  MMiaSpecialViewController.h
//  MMIA
//
//  Created by lixiao on 15/1/29.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "MMiaNoDataView.h"

@class MMiaSpecialViewController;
@protocol MMiaSpecialViewControllerDelegate <NSObject>

- (void)viewController:(MMiaSpecialViewController *)viewController didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)scrollViewDidScrollViewController:(MMiaSpecialViewController *)viewController ContentoffsetY:(CGFloat)offsetY contentInset:(CGFloat)contentInset;

@end
@interface MMiaSpecialViewController : UIViewController<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>

//必传值
@property (nonatomic, assign) NSInteger    userId;
////
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, retain) MMiaNoDataView    *nodataView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat   collectionInset;
@property (nonatomic, assign) BOOL      isLoadding;
@property (nonatomic, assign) BOOL      isRefresh;
@property (nonatomic, assign) BOOL      showError;
@property (nonatomic, assign) id<MMiaSpecialViewControllerDelegate>specialDelegate;

-(void)getUserMagazineRequestStart:(NSInteger)start Size:(int)size;
- (void)viewBackToOriginalPosition;
@end
