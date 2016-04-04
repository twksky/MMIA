//
//  MmiaPersonHomeHeaderView.h
//  MmiaHD
//
//  Created by lixiao on 15/3/11.
//  Copyright (c) 2015年 yhx. All rights reserved.
//
/*个人主页header*/

#import <UIKit/UIKit.h>
#import "LoginInfoItem.h"
#import "UIImageView+WebCache.h"

@protocol MmiaPersonHomeHeaderViewDelegate <NSObject>

@optional

- (void)addConcernPerson:(UIButton *)button;
- (void)tapSetHeadImageViewClickImageView:(UIImageView *)imageView;
- (void)tapSetButton;

@end

@interface MmiaPersonHomeHeaderView : UIView

@property (nonatomic, retain) UIImageView *backGroundImageView;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UIButton    *addConcernButton;
@property (nonatomic, retain) UILabel     *nikeNameLabel;
@property (nonatomic, retain) UIButton    *setButton;
@property (nonatomic, assign) id<MmiaPersonHomeHeaderViewDelegate> delegate;

- (void)resetSubViewsWithDictionary:(LoginInfoItem *)loginItem;
- (void)resetFrame:(CGRect)frame;

@end
