//
//  MmiaCollectionViewCell.m
//  MMIA
//
//  Created by lixiao on 15/5/14.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaCollectionViewCell.h"

@implementation MmiaCollectionViewCell

- (UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.frame = self.bounds;
        [self.contentView addSubview:_headImageView];
    }
    return _headImageView;
}

- (UIActivityIndicatorView *)acView
{
    if (_acView == nil)
    {
        _acView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _acView.center = self.contentView.center;
        _acView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_acView];
    }
    return _acView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        _titleLabel.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
