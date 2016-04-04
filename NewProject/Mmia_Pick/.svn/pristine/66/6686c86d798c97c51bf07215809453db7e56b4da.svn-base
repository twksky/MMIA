//
//  MmiaBrandCollectionCell.m
//  MMIA
//
//  Created by lixiao on 15/5/25.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//
/**
 关于品牌
 **/

#import "MmiaBrandCollectionCell.h"
#import "UtilityMacro.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation MmiaBrandCollectionCell{
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
    
    self.brandLabel.textColor = ColorWithHexRGB(0x333333);
    self.contentLabel.textColor = ColorWithHexRGB(0x999999);
    self.lineLabel1.backgroundColor = ColorWithHexRGB(0x999999);
    self.webLabel.textColor = ColorWithHexRGB(0x333333);
    self.webContentLabel.textColor = ColorWithHexRGB(0x999999);
    self.lineLabel2.backgroundColor = ColorWithHexRGB(0x999999);
    self.descriptionLabel.textColor = ColorWithHexRGB(0x999999);
    _downImageView.layer.shouldRasterize = YES;
   _downImageView.transform = CGAffineTransformMakeRotation(-7 * M_PI/360);
}

- (void)reloadCellWithModel:(MmiaPaperBrandModel *)model
{
    _contentLabel.text = model.slogan;
    _webContentLabel.text = model.officalWebsite;
    _descriptionLabel.text = model.describe;
    [_doubleImageView sd_setImageWithURL:[NSURL URLWithString:model.focusImg]];
    [_downImageView sd_setImageWithURL:[NSURL URLWithString:model.focusImg]];
}



@end
