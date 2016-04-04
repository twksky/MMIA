//
//  MMiaMagezineEditViewController.h
//  MMIA
//
//  Created by lixiao on 14-9-15.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//编辑杂志


#import "MMiaBaseViewController.h"
#import "MMiaMagezineTypeView.h"

@interface MMiaMagezineEditViewController : MMiaBaseViewController<UITableViewDelegate,UITableViewDataSource,MMiaMagezineTypeViewDelegate,UIAlertViewDelegate>
-(id)initWithMagezineId:(NSInteger)magazineId Name:(NSString *)name Description:(NSString *)description Type:(NSString *)type CategoryId:(int)categoryId Public:(int)public;
@end
