//
//  MainTableViewLoadCell.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-29.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MainTableViewLoadCell.h"

@implementation MainTableViewLoadCell


- (UILabel *)loadLabel
{
    if( !_loadLabel )
    {
        _loadLabel = UILabel.new;
        _loadLabel.textAlignment = MMIATextAlignmentCenter;
        _loadLabel.backgroundColor = [UIColor clearColor];
        _loadLabel.textColor = [UIColor blackColor];
        _loadLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:_loadLabel];
        
        [_loadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(self).offset(-20);
        }];
    }
    return _loadLabel;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
