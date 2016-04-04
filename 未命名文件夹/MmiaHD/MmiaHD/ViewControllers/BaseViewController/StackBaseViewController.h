//
//  StackBaseViewController.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-4.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdditionHeader.h"

typedef NS_ENUM(NSInteger, StackViewControllerDirection)
{
    StackViewControllerDirectionNo,
    StackViewControllerDirectionLeft,
    StackViewControllerDirectionRight,
};

@interface StackBaseViewController : UIViewController

@property (nonatomic, assign) StackViewControllerDirection direction;
@property (nonatomic, assign) CGFloat sideAnimationDuration; // 页面弹出持续时间
@property (nonatomic, assign) CGFloat sideOffset;            // 页面边距
@property (nonatomic, assign) CGRect  originViewFrame;       // View初始frame

@property (nonatomic, getter=isPortrait) BOOL portrait;      // 设备屏幕方向

@property (nonatomic, strong) UIView* contentView;           // 页面主内容view
@property (nonatomic, strong) UIView* anotherView;           // 主内容外剩余view
// lx add
@property (nonatomic, strong) UIButton *backButton;


- (void)dismissStackViewController:(id)sender;

- (void)insertIntoLoginVC;
- (void)registerSuccess;
- (void)loginSuccess;

@end
