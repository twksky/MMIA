//
//  MMiaFunsViewController.h
//  MMIA
//
//  Created by lixiao on 14-9-17.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//粉丝



#import "MMiaBaseViewController.h"

@interface MMiaFunsViewController : MMiaBaseViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWithUserId:(NSInteger)userId;

@end
