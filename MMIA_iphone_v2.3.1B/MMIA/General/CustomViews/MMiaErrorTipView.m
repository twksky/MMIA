//
//  MMiaErrorTipView.m

//
//  Created by yhx on 14-4-11.
//  Copyright (c) 2014年 yhx. All rights reserved.
//

#import "MMiaErrorTipView.h"
#import "MMIToast.h"

@interface MMiaErrorTipView()

@property (nonatomic, strong) UIImageView* errTipImageView;
@property (nonatomic, strong) UILabel*     errTipText;
@property (nonatomic, strong) UIButton*    errTipButton;
@property (nonatomic, assign) id<MMiaErrorTipViewDelegate> delegate;

- (void)btnClicked:(UIButton *)sender;

@end

@implementation MMiaErrorTipView

- (id)initWithView:(UIView *)view
            center:(CGPoint)centerPoint
             image:(UIImage *)errTipImage
              text:(NSString *)errTipText
          delegate:(id)errDelegate
{
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(view.frame), centerPoint.y, CGRectGetWidth(view.bounds), 125)];
    if ( self )
    {
        self.delegate = errDelegate;
        
        if( errTipImage )
        {
            if( !_errTipImageView )
            {
                _errTipImageView = [[UIImageView alloc] initWithImage:errTipImage];
                _errTipImageView.center = CGPointMake(centerPoint.x, errTipImage.size.height/2);
                _errTipImageView.backgroundColor = [UIColor clearColor];
                [self addSubview:_errTipImageView];
            }
        }
        
        if( errTipText )
        {
            if( !_errTipText )
            {
                _errTipText = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, CGRectGetMaxY(self.errTipImageView.frame) + 15, CGRectGetWidth(self.bounds), 25 )];
                _errTipText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                _errTipText.font = [UIFont systemFontOfSize:14];
                _errTipText.text = errTipText;
                _errTipText.textColor = [UIColor blackColor];
                _errTipText.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
                _errTipText.shadowOffset = CGSizeMake(0.0f, 1.0f);
                _errTipText.backgroundColor = [UIColor clearColor];
                _errTipText.textAlignment = NSTextAlignmentCenter;
                [self addSubview:_errTipText];
            }
        }
        
        if( !_errTipButton )
        {
            _errTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _errTipButton.frame = CGRectMake( (CGRectGetWidth(self.bounds)-100)/2, CGRectGetMaxY(self.errTipText.frame) + 15, 100, 25 );
            [_errTipButton setTitle:@"重新加载" forState:UIControlStateNormal];
            [_errTipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_errTipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [_errTipButton setBackgroundImage:[UIImage imageNamed:@"reloadBtn.png"] forState:UIControlStateNormal];
            _errTipButton.titleLabel.font = [UIFont systemFontOfSize:14];
            
            [_errTipButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_errTipButton];
        }
    }
    
    return self;
}

- (void)btnClicked:(UIButton *)sender
{
    if( [self.delegate respondsToSelector:@selector(onErrorTipViewRefreshBtnClicked:)] )
    {
        [_delegate onErrorTipViewRefreshBtnClicked:self];
    }
}

+ (void)showErrorTipForErroe:(NSError *)error
{
    NSString* errStr = @"无法访问网络,请稍候重试...";
    if( !error || [error code] == 404 )
    {
        errStr = @"内容加载错误,请稍后再试...";
    }
    else if( [error code] == 500 ) // 超时
    {
        errStr = @"网络不给力哦,请稍候重试...";
    }
    [MMIAutoAlertView showWithText:errStr topOffset:0 bottomOffset:0 image:nil];
}

+ (id)showErrorTipForView:(UIView *)view
                   center:(CGPoint)centerPoint
                    error:(NSError *)error
                 delegate:(id)delegate
{
    if( [view viewWithTag:110] )
    {
        [[view viewWithTag:110] removeFromSuperview];
    }
    
    // 无网络
    NSString* errStr = @"无法访问网络,请稍候重试...";
    UIImage*  errImg = [UIImage imageNamed:@"netError2.png"];
    // 服务器接口出错或挂掉
    if( !error || [error code] == 404 )
    {
        errStr = @"内容加载错误,请稍后再试...";
        errImg = [UIImage imageNamed:@"netError1.png"];
    }
    else if( [error code] == 500 ) // 超时
    {
        errStr = @"网络不给力哦,请稍候重试...";
        errImg = [UIImage imageNamed:@"netError2.png"];
    }
    [MMIAutoAlertView showWithText:errStr topOffset:0 bottomOffset:0 image:nil];
    
    MMiaErrorTipView* tipView = [[MMiaErrorTipView alloc] initWithView:view center:centerPoint image:errImg text:errStr delegate:delegate];
    tipView.tag = 110;
    [view addSubview:tipView];
    
    return tipView;
}

+ (void)hideErrorTipForView:(UIView *)view
{
    for (UIView* subView in [view subviews])
    {
        if ([subView isKindOfClass:[MMiaErrorTipView class]])
        {
            [subView removeFromSuperview];
            return;
        }
    }
}

@end
