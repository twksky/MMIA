//
//  MmiaDetailTableViewCell.m
//  MmiaHD
//
//  Created by lixiao on 15/3/19.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaDetailTableViewCell.h"

@implementation MmiaDetailTableViewCell

#pragma mark - Setter

- (UIImageView *)picImageView
{
    if (!_picImageView)
    {
        _picImageView = [[UIImageView alloc]init];
        _picImageView.clipsToBounds = YES;
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
       // _picImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _picImageView;
}

#pragma mark - init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.picImageView];
    }
    return self;
}

@end
