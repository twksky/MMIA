//
//  MmiaRecommendWaterFallHeader.m
//  MmiaHD
//
//  Created by lixiao on 15/4/15.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaRecommendWaterFallHeader.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"

@implementation MmiaRecommendWaterFallHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = ColorWithHexRGBA(0x000000, 0.8);
        self.titleLabel = [[UILabel alloc]initWithFrame:frame];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:22];
        self.titleLabel.textAlignment = MMIATextAlignmentCenter;
        self.titleLabel.textColor = ColorWithHexRGB(0xffffff);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    if (_title != title)
    {
        [_titleLabel setText:title];
        _title = title;
    }
}


@end
