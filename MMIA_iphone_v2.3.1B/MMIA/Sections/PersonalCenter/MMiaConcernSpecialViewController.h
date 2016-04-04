//
//  MMiaConcernSpecialViewController.h
//  MMIA
//
//  Created by lixiao on 15/2/5.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//他人专题

#import "MMiaBaseViewController.h"

@class MMiaConcernSpecialViewController;
@protocol MMiaConcernSpecialViewControllerDelegate <NSObject>

- (void)concernSpecialViewController:(MMiaConcernSpecialViewController *)viewController didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)concernScrollViewDidScrollViewController:(MMiaConcernSpecialViewController *)viewController ContentoffsetY:(CGFloat)offsetY contentInset:(CGFloat)contentInset;

@end

@interface MMiaConcernSpecialViewController : UIViewController

//必传
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, assign) CGFloat   collectionInset;
@property (nonatomic, retain) NSMutableArray *specialArray;
@property (nonatomic, assign) BOOL        isLoadding;
@property (nonatomic, assign) BOOL        isRefresh;
@property (nonatomic, assign) id<MMiaConcernSpecialViewControllerDelegate> specialDelegate;

- (void)getUserMagazineRequestStart:(NSInteger)start Size:(int)size;
- (void)doReturnSpecialBlock:(int)concern indexPath:(NSIndexPath *)indexPath;
- (void)viewBackToOriginalPosition;

@end
