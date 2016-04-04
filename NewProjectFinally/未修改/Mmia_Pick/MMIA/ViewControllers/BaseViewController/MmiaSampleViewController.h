//
//  MmiaSampleViewController.h
//  MMIA
//
//  Created by lixiao on 15/6/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//
/*
 **继承于 UIViewController的baseVC
 */

#import <UIKit/UIKit.h>

@interface MmiaSampleViewController : UIViewController

//总navigationBar,高度 64/44
@property (nonatomic, strong) UIView *navigationView;
//状态栏
@property (nonatomic, strong) UIView *statusView;
//高度为44的navigationBar
@property (nonatomic, strong) UIView *naviBarView;
@property (nonatomic, strong) UILabel *lineLabel;

- (void)addBackBtnWithTarget:(id)target selector:(SEL)selector;

@end
