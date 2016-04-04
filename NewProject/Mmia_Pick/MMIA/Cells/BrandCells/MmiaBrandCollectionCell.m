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
     self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    _doubleImageView.clipsToBounds = YES;
    _doubleImageView.backgroundColor = ColorWithHexRGB(0xeeeeee);
    _doubleImageView.layer.borderWidth = 0.6f;
    _doubleImageView.layer.borderColor = ColorWithHexRGB(0xcccccc).CGColor;
    _doubleImageView.layer.shadowOpacity = 1.0;
    _doubleImageView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _doubleImageView.layer.shadowColor = ColorWithHexRGBA(0x000000, 0.3).CGColor;
    
    _downImageView = [[UIImageView alloc]init];
    _downImageView.clipsToBounds = YES;
    _downImageView.contentMode = UIViewContentModeScaleAspectFill;
    _downImageView.backgroundColor = ColorWithHexRGB(0xeeeeee);
    _downImageView.layer.borderWidth = 0.6f;
    _downImageView.layer.borderColor = ColorWithHexRGB(0xcccccc).CGColor;
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
    _contentLabel.text = model.describe;
    _webContentLabel.text = model.officalWebsite;
    _descriptionLabel.text = model.title;
    [self.doubleImageView sd_setImageWithURL:[NSURL URLWithString:model.focusImg]];
    [_downImageView sd_setImageWithURL:[NSURL URLWithString:model.focusImg]];
}



@end
