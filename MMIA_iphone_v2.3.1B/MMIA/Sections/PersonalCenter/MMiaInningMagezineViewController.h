//
//  MMiaInningMagezineViewController.h
//  MMIA
//
//  Created by lixiao on 14-9-23.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//收进杂志

#import "MMiaBaseViewController.h"
#import "MMiaDetailSpecialViewControllerDelegate.h"


@interface MMiaInningMagezineViewController : MMiaBaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
-(id)initWithImage:(UIImage *)image imgId:(NSInteger)imgId;
@property(nonatomic,assign)BOOL isLikeOrShareVC;
@property(nonatomic,assign)id <MMiaDetailSpecialViewControllerDelegate>delegate;
@end
