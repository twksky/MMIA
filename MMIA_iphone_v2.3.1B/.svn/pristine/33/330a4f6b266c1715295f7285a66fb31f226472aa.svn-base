//
//  MMiaConcernPersonHomeViewController.h
//  MMIA
//
//  Created by lixiao on 14-9-19.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//关注人的主页

#import "MMiaBaseViewController.h"
#import "MMiaErrorTipView.h"
#import "CHTCollectionViewWaterfallLayout.h"

typedef void (^changeFunsBlock)(int follow);
@interface MMiaConcernPersonHomeViewController : MMiaBaseViewController<MMiaErrorTipViewDelegate>

@property (nonatomic, copy) changeFunsBlock funsBlock;

-(id)initWithUserid:(NSInteger)userid;
-(void)doFunsBlock:(changeFunsBlock)block;

@end
