//
//  MMiaConcernMagezineViewController.h
//  MMIA
//
//  Created by lixiao on 14-9-18.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//关注的杂志

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

@class MMiaConcernMagezineViewController;
@protocol MMiaConcernMagezineViewControllerDelegate <NSObject>

- (void)didSelectItemAtConcernMagezine:(MMiaConcernMagezineViewController *)concernMagezine indexPath:(NSIndexPath *)indexPath;

@end
@interface MMiaConcernMagezineViewController : UIViewController<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,assign)id<MMiaConcernMagezineViewControllerDelegate>delegate;
-(void)doReturnConcernMagezineBlock:(int)concern indexPath:(NSIndexPath *)indexPath;

@end
