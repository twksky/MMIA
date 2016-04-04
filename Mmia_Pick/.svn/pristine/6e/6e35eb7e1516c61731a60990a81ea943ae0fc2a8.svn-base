//
//  MmiaSearchCollectionViewCell.m
//  MMIA
//
//  Created by lixiao on 15/5/20.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaSearchCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MmiaSearchCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)resetCellWithModel:(MmiaSearchModel *)searchModel
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:searchModel.logo]];
    [_titleLabel setText:searchModel.companyName];
    
}

@end
