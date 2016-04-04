//
//  MMiaErrorTipView.m

//
//  Created by WuZixun on 14-4-11.
//  Copyright (c) 2014年 WuZixun. All rights reserved.
//

#import "MMiaErrorTipView.h"
#import "MMiaCommonUtil.h"



@interface MMiaErrorTipView()
{
    UIButton *refreshBtn;
}
@property (nonatomic, strong) UILabel *errTipText;
@property (nonatomic, assign) id<MMiaErrorTipViewDelegate> delegate;

- (void)initControls;
@end

@implementation MMiaErrorTipView

- (void)showRefreshButton:(BOOL)bShow
{
    refreshBtn.hidden = !bShow;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initControls];
    }
    return self;
}

- (void)setErrorTipText:(NSString *)text
{
    _errTipText.text = text;
}

- (void)setDelegate:(id<MMiaErrorTipViewDelegate>)delegate
{
    _delegate = delegate;
}

- (void)initControls
{
    NSLog(@"errTipImageView=%@",NSStringFromCGRect(self.frame));
    CGRect errorViewRect = self.frame;
    UIImageView *errTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_error_tip"]];
    errTipImageView.contentMode = UIViewContentModeCenter|UIViewContentModeScaleAspectFill;
    errTipImageView.frame = CGRectMake(0,0, errorViewRect.size.width, 110.0f);
    errTipImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:errTipImageView];
    
    _errTipText = [[UILabel alloc] init];
    _errTipText.frame = CGRectMake(0,140.0f, errorViewRect.size.width, 30.0f);
    _errTipText.textAlignment = NSTextAlignmentCenter;
    _errTipText.text = @"番茄出错啦！";
    _errTipText.backgroundColor = [UIColor clearColor];
    _errTipText.font = [UIFont boldSystemFontOfSize:18.0f];
    [self addSubview:_errTipText];
    
    //buttons
    CGRect refreshBtnRect = CGRectMake(errorViewRect.size.width/2 - 50.0f,200.0f, 100.0f, 30.0f);
    refreshBtn = [[UIButton alloc] initWithFrame:refreshBtnRect];
    [refreshBtn setBackgroundImage:[[UIImage imageNamed:@"btn_lightgray_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0,5.0,25.0,25.0)] forState:UIControlStateNormal];
    
    UIImage *refreshBtnIconImg = [UIImage imageNamed:@"btn_icon_refresh"];
    [refreshBtn setImage:refreshBtnIconImg forState:UIControlStateNormal];
    [refreshBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0f,-20.0f,0.0f,0.0f)];
    [refreshBtn setTitle:@"刷 新" forState:UIControlStateNormal];
    [refreshBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
//    [refreshBtn setTitleColor:UIColorFromRGB(0xff5933) forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(onBtnRefreshClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refreshBtn];

}

- (void)onBtnRefreshClick:(UIButton *)sender
{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(onErrorTipViewRefreshBtnClicked:)] == YES)  {
            [_delegate onErrorTipViewRefreshBtnClicked:sender];
        }
    }
}

@end
