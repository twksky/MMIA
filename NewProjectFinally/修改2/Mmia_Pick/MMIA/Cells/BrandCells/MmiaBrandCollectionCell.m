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
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 2.0f;
    
    _doubleImageView.clipsToBounds = YES;
    _doubleImageView.backgroundColor = ColorWithHexRGB(0xeeeeee);
    _doubleImageView.layer.borderWidth = 0.6f;
    _doubleImageView.layer.borderColor = ColorWithHexRGB(0xcccccc).CGColor;
    
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
    
    //添加阴影
    UIView *shadowView = [[UIView alloc]init];
    shadowView.backgroundColor = [UIColor greenColor];
    shadowView.layer.shadowOpacity = 1.0;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0.5);
    shadowView.layer.shadowColor = ColorWithHexRGBA(0x000000, 0.3).CGColor;
    [self.contentView insertSubview:shadowView aboveSubview:_downImageView];
    
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(@123);
        make.height.equalTo(@123);
        make.center.mas_equalTo(_doubleImageView);
    }];
}

- (void)reloadCellWithModel:(MmiaPaperProductListModel *)model
{
    _contentLabel.text = model.describe;
    _webContentLabel.text = model.officalWebsite;
    _descriptionLabel.text = model.title;
    
    [self.doubleImageView sd_setImageWithURL:NSURLWithString(model.focusImg)];
    [_downImageView sd_setImageWithURL:NSURLWithString(model.focusImg)];
}



@end
