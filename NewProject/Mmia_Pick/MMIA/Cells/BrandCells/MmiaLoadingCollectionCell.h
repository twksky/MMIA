//
//  MmiaLoadingCollectionCell.h
//  MMIA
//
//  Created by lixiao on 15/5/26.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MmiaLoadingCollectionCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView *loadImageView;

- (void)startAnimation;
- (void)stopAnimation;

@end
