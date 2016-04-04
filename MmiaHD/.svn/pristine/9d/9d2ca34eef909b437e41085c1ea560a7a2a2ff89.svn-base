//
//  CollectionViewWaterfallCell.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "CollectionViewWaterfallCell.h"
#import "UtilityMacro.h"
#import "UIView+Additions.h"

@implementation CollectionViewWaterfallCell

#pragma mark - Accessors

- (UILabel *)displayLabel
{
    if( !_displayLabel )
    {
        _displayLabel = [[UILabel alloc] init];
       // _displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _displayLabel.backgroundColor = UIColorClear;
        _displayLabel.textColor = ColorWithHexRGB(0xffffff);
        _displayLabel.font = UIFontSystem(18);
        _displayLabel.textAlignment = MMIATextAlignmentLeft;
        _displayLabel.lineBreakMode = MMIALineBreakModeWordWrap;
        
        [self.contentView addSubview:_displayLabel];
    }
    return _displayLabel;
}

- (UIImageView *)displaybgView
{
    if( !_displaybgView )
    {
        UIImage* image = [UIImageNamed(@"") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5) resizingMode:UIImageResizingModeStretch];
        _displaybgView = UIImageViewImage(image);
        _displaybgView.backgroundColor = ColorWithHexRGBA(0x272832, 0.3);
        
        [self.contentView addSubview:_displaybgView];
    }
    return _displaybgView;
}

- (UIImageView *)likeView
{
    if( !_likeView )
    {
        _likeView = UIImageViewNamed(@"like_small.png");
        _likeView.backgroundColor = UIColorClear;
        
        [self.contentView addSubview:_likeView];
    }
    CGFloat likeViewY = self.displayLabel.bottom;
    if( self.displayLabel.height > 0 )
    {
        likeViewY += 8;
    }
    _likeView.frame = CGRectMake( self.displayLabel.left, likeViewY + (13 - _likeView.image.size.height)/2, _likeView.image.size.width, _likeView.image.size.height );
    
    return _likeView;
}

- (UILabel *)likeLabel
{
    if( !_likeLabel )
    {
        _likeLabel = [[UILabel alloc] init];
      //  _likeLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _likeLabel.backgroundColor = UIColorClear;
        _likeLabel.textColor = ColorWithHexRGB(0xCE212A);
        _likeLabel.font = UIFontSystem(12);
        _likeLabel.textAlignment = MMIATextAlignmentLeft;
        
        [self.contentView addSubview:_likeLabel];
    }
    CGFloat likeLabelY = self.displayLabel.bottom;
    if( self.displayLabel.height > 0 )
    {
        likeLabelY += 8;
    }
    _likeLabel.frame = CGRectMake( self.likeView.right + 4, likeLabelY, self.displayLabel.width - self.likeView.right, 13 );
    
    return _likeLabel;
}

- (UILabel *)priceLabel
{
    if( !_priceLabel )
    {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _priceLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _priceLabel.textColor = UIColorWhite;
        _priceLabel.font = UIFontSystem(12);
        _priceLabel.layer.cornerRadius = 3.0;
        _priceLabel.clipsToBounds = YES;
        _priceLabel.textAlignment = MMIATextAlignmentCenter;
        
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UIButton *)cellButton
{
    if( !_cellButton )
    {
        UIImage* image = UIImageNamed(@"展开_按钮.png");
        _cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cellButton.frame = CGRectMake(self.width - image.size.width, self.height - image.size.height, image.size.width, image.size.height);
        _cellButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_cellButton setBackgroundImage:image forState:UIControlStateNormal];
        _cellButton.backgroundColor = UIColorClear;
        [self.contentView addSubview:_cellButton];
    }
    return _cellButton;
}

//lx add
- (UIImageView *)headImageView
{
    if (!_headImageView)
    {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 12;
        [self.contentView addSubview:_headImageView];
    }
    return _headImageView;
}

- (UIButton *)concernButton
{
    if (!_concernButton)
    {
        _concernButton = [[UIButton alloc]init];
        _concernButton.backgroundColor = [UIColor clearColor];
        [_concernButton addTarget:self action:@selector(concernButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_concernButton];
    }
    return _concernButton;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = UIColorClear;
        if( !_imageView )
        {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.contentView.width, self.contentView.height)];
            _imageView.backgroundColor = UIColorClear;
           // _imageView.contentMode = UIViewContentModeScaleAspectFill;
            _imageView.clipsToBounds = YES;
            
            //            _imageView.layer.borderColor = [UIColor brownColor].CGColor;
            //            _imageView.layer.borderWidth = 2;
            //            UIBezierPath* path = [UIBezierPath bezierPathWithRect:_imageView.bounds];
            //            _imageView.layer.cornerRadius = 3;
            //            _imageView.layer.shadowRadius = 3;
            //            _imageView.layer.shadowOpacity = 0.1;
            //            _imageView.layer.shadowPath = [path CGPath];
            //            _imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
            //            _imageView.layer.shadowOffset = CGSizeMake(0, 0);
                        _imageView.layer.masksToBounds = YES;
            
            [self.contentView addSubview:_imageView];
        }
    }
    return self;
}

// lx add
- (void)concernButtonClick:(UIButton *)button
{
    if (self.concernBlock)
    {
        self.concernBlock(button);
    }
}


- (void)dealloc
{
    [self removeAllSubviews];
}

@end
