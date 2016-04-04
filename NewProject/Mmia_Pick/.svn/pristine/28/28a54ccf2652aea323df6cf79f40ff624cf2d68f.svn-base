//
//  MmiaSearchCollectionViewCell.m
//  MMIA
//
//  Created by lixiao on 15/5/20.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaSearchCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UtilityMacro.h"

@implementation MmiaSearchCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.contentView.bounds = CGRectMake(0, 0, App_Frame_Width, 60);
//     self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.titleLabel.textColor = ColorWithHexRGB(0xffffff);
    self.lineLabel.backgroundColor = ColorWithHexRGBA(0xffffff, 0.3);
}

//- (void)resetCellWithModel:(MmiaSearchModel *)searchModel
//{
//    [_headImageView sd_setImageWithURL:[NSURL URLWithString:searchModel.logo]];
//    [_titleLabel setText:searchModel.companyName];
//    
//}

- (void)reloadCell
{
    self.headImageView.image = [UIImage imageNamed:@"header.jpeg"];
    self.titleLabel.text = @"哈哈";
}

@end
