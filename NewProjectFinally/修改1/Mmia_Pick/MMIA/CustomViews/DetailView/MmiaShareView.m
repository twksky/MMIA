//
//  MmiaShareView.m
//  MMIA
//
//  Created by lixiao on 15/6/12.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaShareView.h"
#import "GlobalDef.h"

@implementation MmiaShareView

- (UIWindow *)alertWindow
{
    _alertWindow = [self windowWithLevel:UIWindowLevelAlert];
    if (!_alertWindow)
    {
        _alertWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _alertWindow.windowLevel = UIWindowLevelAlert;
        _alertWindow.backgroundColor = [UIColor clearColor];
        [_alertWindow makeKeyAndVisible];
    }
    return _alertWindow;
}

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    for (UIWindow *window in windows)
    {
        if (window.windowLevel == windowLevel)
        {
            return window;
        }
    }
    return nil;
}

- (id)initWithShareViewHeight:(CGFloat)height
{
    self = [super initWithFrame:CGRectMake(0, self.alertWindow.height - height, App_Frame_Width, height)];
    if (self)
    {
        [self.alertWindow addSubview:self];
        self.backgroundColor = [ColorWithHexRGB(0xffffff) colorWithAlphaComponent:0.95];
        
        UILabel *lineLabel0 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, App_Frame_Width - 20, 0.5)];
        lineLabel0.backgroundColor = ColorWithHexRGBA(0xffffff, 1);
        [self addSubview:lineLabel0];
        
        NSArray *nameArr = [NSArray arrayWithObjects:@"微信分享.png", @"朋友圈分享.png", @"微博分享.png", @"QQ分享.png", nil];
        UIImage *image = [UIImage imageNamed:@"微信分享.png"];
        CGFloat space = (App_Frame_Width - nameArr.count * image.size.width)/5;
        
        for (int i = 0; i < nameArr.count; i++)
        {
            UIButton *button = [[UIButton alloc]init];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(space + (image.size.width + space) * i, 15, image.size.width, image.size.height);
            [button setImage:[UIImage imageNamed:[nameArr objectAtIndex:i]] forState:UIControlStateNormal];
            button.tag = 300 + i;
            [self addSubview:button];
        }
        
        CGFloat lineOriginY = 15 + image.size.height + 20;
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineOriginY, App_Frame_Width - 20, 0.5)];
        lineLabel.backgroundColor = ColorWithHexRGB(0x999999);
        [self addSubview:lineLabel];
        
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, lineOriginY + 0.5 + 15, App_Frame_Width - 20, 20)];
        cancelButton.tag = 400;
        [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:ColorWithHexRGB(0x333333) forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
        [self addSubview:cancelButton];
    }
    return self;
}

- (void)buttonClick:(UIButton *)button
{
    if (self.shareViewButtonClick)
    {
        self.shareViewButtonClick(button);
    }
}

- (void)showAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [self.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAnimation
{
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        [self.alertWindow resignKeyWindow];
        [self.alertWindow setHidden:YES];
        [self removeFromSuperview];
        [self.alertWindow removeFromSuperview];
        self.alertWindow = nil;
    }];
}

@end
