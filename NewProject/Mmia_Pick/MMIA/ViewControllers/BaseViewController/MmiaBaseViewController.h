//
//  MmiaBaseViewController.h
//  MMIA
//
//  Created by lixiao on 15/5/18.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "GlobalHeader.h"
#import "AdditionHeader.h"
#import "UIImageView+WebCache.h"

@interface MmiaBaseViewController : UICollectionViewController

//总navigationBar,高度 64/44
@property (nonatomic, strong) UIView *navigationView;
//状态栏
@property (nonatomic, strong) UIView *statusView;
//高度为44的navigationBar
@property (nonatomic, strong) UIView *naviBarView;
@property (nonatomic, strong) UILabel *lineLabel;
//右边label
@property (nonatomic, strong) UILabel *rightLabel;

- (void)addBackBtnWithTarget:(id)target selector:(SEL)selector;
- (void)addRightBtnWithImage:(UIImage *)rightImage Target:(id)target selector:(SEL)selector;
- (void)addRightLabelWithText:(NSString *)text;
@end