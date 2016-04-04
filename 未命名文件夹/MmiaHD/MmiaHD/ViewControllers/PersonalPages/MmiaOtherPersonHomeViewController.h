//
//  MmiaOtherPersonHomeViewController.h
//  MmiaHD
//
//  Created by lixiao on 15/3/25.
//  Copyright (c) 2015年 yhx. All rights reserved.
//他人主页

#import <UIKit/UIKit.h>
#import "StackBaseViewController.h"

typedef void (^concernButtonClickBlock)(BOOL concern);

@interface MmiaOtherPersonHomeViewController : StackBaseViewController

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, copy)   concernButtonClickBlock concernClickBlock;

-(id)initWithUserId:(NSInteger)userId;

@end
