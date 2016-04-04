//
//  MMiaMagezineTypeCell.m
//  MMIA
//
//  Created by lixiao on 14-9-12.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaMagezineTypeCell.h"

@implementation MMiaMagezineTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor=[UIColor whiteColor];
        self.typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 70, 30)];
        [self.typeLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.typeLabel];
        
        self.typeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(App_Frame_Width-30-14, (CGRectGetHeight(self.frame)-14)/2, 14, 14)];
        [self.contentView addSubview:self.typeImageView];
        

        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation MMiaQueryCell
- (UILabel *)titleLabel
{
    if( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = MMIATextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UILabel *)lineLabel
{
    if( !_lineLabel )
    {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = UIColorFromRGB(0xd3d3d3);
        [self.contentView addSubview:_lineLabel];
    }
    return _lineLabel;
}


@end

