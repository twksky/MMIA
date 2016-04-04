//
//  MMiaDetailSpecialViewController.h
//  MMIA
//
//  Created by lixiao on 14-9-15.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//专题详情页

#import "MMiaBaseViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MMiaDetailSpecialViewControllerDelegate.h"

typedef void (^changeMagezineBlock)(int concern);

@interface MMiaDetailSpecialViewController : MMiaBaseViewController

@property(nonatomic,assign)NSInteger isAttention;
@property(nonatomic,assign)BOOL isNotEdit;
@property(nonatomic,copy)changeMagezineBlock magezineBlock;

-(id)initWithTitle:(NSString *)title MagazineId:(NSInteger)magazineId UserId:(NSInteger)userId isAttention:(NSInteger)isAttention;
@end
