//
//  MmiaPersonHomeCell.m
//  MmiaHD
//
//  Created by lixiao on 15/3/13.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaPersonHomeCell.h"
#import "UIView+Additions.h"
#import "AdditionHeader.h"

@implementation MmiaPersonPortraitCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.width = 168;
        self.height = 80;
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 50 - 70, (self.height - 70) / 2, 70, 70)];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = self.headImageView.height / 2;
        [self.contentView addSubview:self.headImageView];
    }
    return self;
}

@end


@implementation MmiaPersonLanscapeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.width = 424.0;
        self.height = 200.0;
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(108, (self.height - 170) / 2, 270, 170)];
        _bgView.backgroundColor = ColorWithHexRGB(0xf9f9f7);
        [self.contentView addSubview:_bgView];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, _bgView.frame.origin.y + 20, 44, 1)];
        lineLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:lineLabel];
        
        UILabel *circleLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineLabel.frame.origin.x - 3, lineLabel.top - 3, 6, 6)];
        circleLabel.backgroundColor = [UIColor whiteColor];
        circleLabel.layer.masksToBounds = YES;
        circleLabel.layer.cornerRadius = 3.0f;
        [self.contentView addSubview:circleLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, lineLabel.frame.origin.y - 5, 60, 10)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont systemFontOfSize:9];
        self.timeLabel.text = @"10分钟前";
        self.timeLabel.textAlignment = MMIATextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = self.headImageView.height / 2;
        [_bgView addSubview:self.headImageView];
        
        self.nikeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        self.nikeNameLabel.font = [UIFont systemFontOfSize:11];
        [self.nikeNameLabel setTextColor:ColorWithHexRGB(0x878c8d)];
        self.nikeNameLabel.backgroundColor = [UIColor clearColor];
        self.nikeNameLabel.center = CGPointMake(self.headImageView.center.x + self.headImageView.width / 2 + 10 + 50, self.headImageView.center.y);
        [_bgView addSubview:self.nikeNameLabel];
        
        
        self.concernButton = [[UIButton alloc]initWithFrame:CGRectMake(_bgView.width - 15 - 70, 26, 70, 26)];
        [self.concernButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.concernButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.concernButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.concernButton setTitleColor:ColorWithHexRGB(0x404040) forState:UIControlStateNormal];
        self.concernButton.layer.masksToBounds = YES;
        self.concernButton.layer.borderWidth = 1;
        self.concernButton.layer.borderColor = [[UIColor blackColor]CGColor];
        self.concernButton.layer.cornerRadius = 13.0f;
        [_bgView addSubview:self.concernButton];
        
        self.introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.headImageView.bottom + 10, _bgView.width - 20, 80)];
        self.introduceLabel.backgroundColor = [UIColor clearColor];
        self.introduceLabel.numberOfLines = 0;
        [self.introduceLabel setFont:[UIFont systemFontOfSize:9]];
        [self.introduceLabel setTextColor:ColorWithHexRGB(0x878c8d)];
        [_bgView addSubview:self.introduceLabel];
    }
    return self;
}

- (void)buttonClick:(UIButton *)button
{
    if (self.concernBlock)
    {
        self.concernBlock(button);
    }
}

@end