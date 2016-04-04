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
    self.titleLabel.textColor = ColorWithHexRGB(0xffffff);
    self.lineLabel.backgroundColor = ColorWithHexRGBA(0xffffff, 0.3);
}

- (void)resetCellWithModel:(MmiaPaperProductListModel *)productModel
{
    [self.headImageView sd_setImageWithURL:NSURLWithString(productModel.logo) placeholderImage:[UIImage imageNamed:@"search_logo.png"]];
    self.titleLabel.text = productModel.title;
}

@end
