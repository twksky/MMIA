//
//  MmiaBrandCollectionCell.m
//  MMIA
//
//  Created by lixiao on 15/5/22.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaSingleGoodsCollectionCell.h"
#import "UtilityMacro.h"
#import "UIImageView+WebCache.h"

@implementation MmiaSingleGoodsCollectionCell{
    UIImageView *_downImageView;
}

- (void)awakeFromNib {
    // Initialization code
    _downImageView = [[UIImageView alloc]init];
    [self.contentView insertSubview:_downImageView belowSubview:_doubleImageView];
    [_downImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(@123);
        make.height.equalTo(@123);
        make.center.mas_equalTo(_doubleImageView);
    }];
    _downImageView.layer.shouldRasterize = YES;
    _downImageView.transform = CGAffineTransformMakeRotation(-7 * M_PI/360);
    
    self.titleLabel.textColor = ColorWithHexRGB(0x333333);
    self.contentLabel.textColor = ColorWithHexRGB(0x999999);
    
    self.headImageView.layer.borderWidth = 0.5f;
    self.headImageView.layer.borderColor = ColorWithHexRGB(0xcccccc).CGColor;
    self.doubleImageView.layer.borderWidth = 0.5f;
    self.doubleImageView.layer.borderColor = ColorWithHexRGB(0xcccccc).CGColor;
   _downImageView.layer.borderWidth = 0.5f;
    _downImageView.layer.borderColor = ColorWithHexRGB(0xcccccc).CGColor;
}

- (void)reloadCellWithModel:(MmiaPaperProductListModel *)model
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.brandLogo]];
    [self.titleLabel setText:model.title];
    [self.contentLabel setText:model.describe];
    [self.doubleImageView sd_setImageWithURL:[NSURL URLWithString:model.focusImg]];
    [_downImageView sd_setImageWithURL:[NSURL URLWithString:model.focusImg]];
}



@end
