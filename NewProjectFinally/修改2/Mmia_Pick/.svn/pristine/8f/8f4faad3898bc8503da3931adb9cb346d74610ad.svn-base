//
//  MmiaLoadingCollectionCell.m
//  MMIA
//
//  Created by lixiao on 15/5/26.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaLoadingCollectionCell.h"

@interface MmiaLoadingCollectionCell ()

@property (nonatomic, strong) UIImageView* loadImageView;
@property (nonatomic, strong) UIButton*    reloadButton;

@end

@implementation MmiaLoadingCollectionCell

- (UIImageView *)loadImageView
{
    if( !_loadImageView )
    {
        UIImage* image = UIImageNamed(@"load.png");
        _loadImageView = UIImageViewImage(image);
        _loadImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        _loadImageView.center = self.center;
    }
    return _loadImageView;
}

- (UIButton *)reloadButton
{
    if( !_reloadButton )
    {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_reloadButton setTitle:@"点击重新加载" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:ColorWithHexRGB(0x999999) forState:UIControlStateNormal];
        _reloadButton.titleLabel.font = UIFontSystem(10);
        _reloadButton.bounds = CGRectMake(0, 0, 80, 30);
        _reloadButton.center = self.center;
        _reloadButton.hidden = YES;
    }
    return _reloadButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 2.0f;
        self.backgroundColor = UIColorWhite;

        [self addSubview:self.loadImageView];
        [self addSubview:self.reloadButton];
    }
    return self;
}

- (void)layoutSubviews
{
    self.loadImageView.center = self.center;
    self.reloadButton.center = self.center;
}

- (void)addReloadButtonWithTarget:(id)target selector:(SEL)selector
{
    [self.reloadButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)hiddenReloadButton:(BOOL)hidden
{
    self.reloadButton.hidden = hidden;
    self.loadImageView.hidden = !hidden;
}

- (void)startAnimation
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2 *M_PI];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.repeatCount = HUGE_VALF ;
    rotationAnimation.autoreverses= NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode=kCAFillModeForwards;
    
    [self stopAnimation];
    [self.loadImageView.layer addAnimation:rotationAnimation forKey:@"rotation"];
  }

- (void)stopAnimation
{
    [self.loadImageView.layer removeAllAnimations];
}

@end
