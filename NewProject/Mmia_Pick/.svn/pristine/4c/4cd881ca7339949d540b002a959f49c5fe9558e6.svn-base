//
//  MmiaDescripBrandCollectionCell.m
//  MMIA
//
//  Created by lixiao on 15/5/29.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaDescripBrandCollectionCell.h"
#import "UtilityMacro.h"
#import "UIImageView+WebCache.h"

@implementation MmiaDescripBrandCollectionCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.textColor = ColorWithHexRGB(0x333333);
    self.contentLabel.textColor = ColorWithHexRGB(0x999999);
    self.bgView.layer.borderWidth = 1.0f;
    self.bgView.layer.borderColor = ColorWithHexRGB(0x999999).CGColor;
    self.subLabel.textColor = ColorWithHexRGB(0x333333);
    self.subContentLabel.textColor = ColorWithHexRGB(0x999999);
    self.headImageView.layer.borderWidth = 0.5f;
    self.headImageView.layer.borderColor = ColorWithHexRGB(0xcccccc).CGColor;
    self.detailImageView.layer.borderWidth = 0.5f;
    self.detailImageView.layer.borderColor = ColorWithHexRGB(0xcccccc).CGColor;
}

- (void)reloadCellWithModel:(MmiaPaperProductListModel *)model
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    [self.titleLabel setText:model.title];
    [self.contentLabel setText:model.slogan];
    
}

@end
