//
//  MmiaLoadingCollectionCell.m
//  MMIA
//
//  Created by lixiao on 15/5/26.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaLoadingCollectionCell.h"
#import "Masonry.h"

@implementation MmiaLoadingCollectionCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIImage *loadImage = [UIImage imageNamed:@"load.png"];
       _loadImageView = [[UIImageView alloc]init];
        _loadImageView.bounds = CGRectMake(0, 0, loadImage.size.width, loadImage.size.height);
        _loadImageView.center = self.contentView.center;
        _loadImageView.image = loadImage;
        [self.contentView addSubview:_loadImageView];
    }
    return self;
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
    [_loadImageView.layer addAnimation:rotationAnimation forKey:@"rotation"];
   
  }

- (void)stopAnimation
{
    [_loadImageView.layer removeAllAnimations];
}

@end
