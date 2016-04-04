//
//  MMiaDetailGoodsViewController.h
//  MMIA
//
//  Created by lixiao on 14-9-22.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//商品详情页

#import "MMiaBaseViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MMiaDetailSpecialViewControllerDelegate.h"
#import "MMiaShareViewController.h"
#import "MMiaLikeViewController.h"
#import "MMiaTabLikeViewController.h"
#import "MMiaSearchViewController.h"

typedef void(^deleteGoodsBlock)();

@interface MMiaDetailGoodsViewController : MMiaBaseViewController<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource,UIAlertViewDelegate>
@property(nonatomic,assign)id <MMiaDetailSpecialViewControllerDelegate>delegate;
@property(nonatomic,assign)id <MMiaShareViewControllerDelegate>shareDelegate;
@property(nonatomic,assign)id <MMiaLikeViewControllerDelegate>likeDelegate;
@property(nonatomic,assign)id <MMiaTabLikeViewControllerDelegate>tabLikeDelegate;
@property(nonatomic,assign)NSInteger productpicsid;
@property(nonatomic,retain)NSString *specialTitle;
@property(nonatomic,copy)deleteGoodsBlock deleteGoodsBlock;

-(id)initWithTitle:(NSString *)title Id:(NSInteger)id goodsImage:(NSString *)imageUrl Width:(float)width Height:(float)height price:(float)price productId:(NSInteger)productId;
@end
