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
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 2.0f;
    
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
    [self.titleLabel setText:model.title];
    
    CGFloat titleHeight = [GlobalFunction getTextSizeWithOutLineSystemFont:self.titleLabel.font ConstrainedToSize:CGSizeMake(self.width - 20, MAXFLOAT) string:model.title].height;
    //contentLabel和titleLabel的总高度
    CGFloat height = (self.height - 15.0 - 123.0 - 10 - 10 - 8);
    self.contentLabelHeight.constant = (height - titleHeight);
    [self.contentLabel updateConstraintsIfNeeded];
    [self.contentLabel setText:model.describe];
    
    [self.doubleImageView sd_setImageWithURL:NSURLWithString(model.focusImg)];
    [_downImageView sd_setImageWithURL:NSURLWithString(model.focusImg)];
}

@end
