//
//  MMIToast.h
//  MMIA
//
//  Created by Free on 14-6-15.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//


//类似于android的TToast控件，替代alertView

#import <Foundation/Foundation.h>

#define DEFAULT_DISPLAY_DURATION 1.5f

@interface MMIToast : NSObject
{
    NSString *_text;
    UIButton *_contentView;
    CGFloat _duration;
}

+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_
               image:(NSString *)imageStr_;
- (void)hideAnimation;
@end


// 进入下一个页面时Loading状态
@interface MMiaLoadingView : UIView

- (id)initWithView:(UIView*)view;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

+ (id)showLoadingForView:(UIView*)view;
+ (id)showLoadingForView:(UIView*)view center:(CGPoint)centerPoint;
+ (void)hideLoadingForView:(UIView*)view;

@end

// n秒后自动消失的AlertView
@interface MMIAutoAlertView : UIView

@property (nonatomic, strong) UIWindow* alertWindow;
@property (nonatomic, strong) UIView* alertView;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, assign) CGFloat duration;

+ (instancetype)showWithText:(NSString *)text
                   topOffset:(CGFloat)topOffset
                bottomOffset:(CGFloat)bottomOffset
                       image:(NSString *)imageStr;

@end
