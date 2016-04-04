//
//  MmiaSettingViewController.h
//  MmiaHD
//
//  Created by lixiao on 15/3/31.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackBaseViewController.h"
#import "LoginInfoItem.h"
#import "MmiaSettingMacro.h"
#import "GlobalHeader.h"
#import "MmiaToast.h"
#import "MmiaBaseViewController.h"
#import "MmiaProcessView.h"
#import "MmiaChangePasswordViewController.h"
#import "UIViewController+StackViewController.h"
#import "MmiaFeedBackViewController.h"


@interface MmiaSettingViewController : StackBaseViewController

@property ( nonatomic , strong ) UIView *backgroudView;
@property ( nonatomic , strong ) UITextField *nikeName;
@property ( nonatomic , strong ) UITextField *sex;
@property ( nonatomic , strong ) UITextField *signature;
@property ( nonatomic , strong ) UIButton *changgePassword;
@property ( nonatomic , strong ) UIButton *suggest;
@property ( nonatomic , strong ) UIButton *clear;
@property (nonatomic, retain) UIImageView *headImageView;

- (id)initWithLoginItem:(LoginInfoItem *)item;
- (void)setTarget:(id)tar withLogOutSuccessAction:(SEL)action;
@end
