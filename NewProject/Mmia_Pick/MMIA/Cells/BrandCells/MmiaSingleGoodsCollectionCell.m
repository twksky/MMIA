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
     self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    _headImageView.clipsToBounds = YES;
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
   
    _downImageView.layer.shouldRasterize = YES;
    _downImageView.transform = CGAffineTransformMakeRotation(-10 * M_PI/360);
    
    self.titleLabel.textColor = ColorWithHexRGB(0x333333);
    self.contentLabel.textColor = ColorWithHexRGB(0x999999);
    
}

- (void)reloadCellWithModel:(MmiaPaperProductListModel *)model
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.brandLogo]placeholderImage:[UIImage imageNamed:@"search_logo.png"]];
    [self.titleLabel setText:model.title];
    [self.contentLabel setText:model.describe];
    
    [self.doubleImageView sd_setImageWithURL:[NSURL URLWithString:model.focusImg]];
    [_downImageView sd_setImageWithURL:[NSURL URLWithString:model.focusImg]];
}



@end
