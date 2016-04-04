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
#import "MmiaPublicResponseModel.h"

@implementation MmiaDescripBrandCollectionCell

- (void)awakeFromNib {
    // Initialization code
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 2.0f;
    
    self.headImageView.clipsToBounds = YES;
    self.detailImageView.clipsToBounds = YES;
    self.titleLabel.textColor = ColorWithHexRGB(0x333333);
    self.contentLabel.textColor = ColorWithHexRGB(0x999999);
    self.bgView.layer.borderWidth = 1.0f;
    self.bgView.layer.borderColor = ColorWithHexRGB(0xcccccc).CGColor;
    self.subLabel.textColor = ColorWithHexRGB(0x333333);
    self.subContentLabel.textColor = ColorWithHexRGB(0x999999);
}

- (void)reloadCellWithModel:(MmiaPaperProductListModel *)model
{
    [self.headImageView sd_setImageWithURL:NSURLWithString(model.logo)];
    [self.titleLabel setText:model.name];
    [self.contentLabel setText:model.slogan];
    [self.subLabel setText:model.title];
    [self.subContentLabel setText:model.describe];
    [self.detailImageView sd_setImageWithURL:NSURLWithString(model.focusImg)];
    
}

@end