//
//  MMiaMainViewWaterfallCell.m
//  MMIA
//
//  Created by MMIA-Mac on 14-7-3.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaMainViewWaterfallCell.h"
#import "UIImageView+MKNetworkKitAdditions.h"

#define WATERFALL_CELL_CONTENT_MARGIN 8.0f

@implementation MMiaMainViewWaterfallCell

#pragma mark - Accessors

- (UIImageView *)logoImageView
{
    if( !_logoImageView )
    {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_logoImageView];
    }
    return _logoImageView;
}

- (UILabel *)displayLabel
{
    if( !_displayLabel )
    {
        _displayLabel = [[UILabel alloc] init];
//        _displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _displayLabel.backgroundColor = [UIColor clearColor];
        _displayLabel.textColor = [UIColor darkGrayColor];
        _displayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        _displayLabel.textAlignment = NSTextAlignmentCenter;
        _displayLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.contentView addSubview:_displayLabel];
    }
    return _displayLabel;
}

- (UIImageView *)likeView
{
    UIImage* img = [UIImage imageNamed:@"like_small.png"];
    if( !_likeView )
    {
        _likeView = [[UIImageView alloc] initWithImage:img];
        _likeView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_likeView];
    }
    CGFloat likeViewY = CGRectGetMaxY(self.displayLabel.frame);
    if( CGRectGetHeight(self.displayLabel.bounds) > 0 )
    {
        likeViewY += 8;
    }
    _likeView.frame = CGRectMake( CGRectGetMinX(self.displayLabel.frame), likeViewY + (13 - img.size.height)/2, img.size.width, img.size.height );
    
    return _likeView;
}

- (UILabel *)likeLabel
{
    if( !_likeLabel )
    {
        _likeLabel = [[UILabel alloc]init];
        //  _likeLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _likeLabel.backgroundColor = [UIColor clearColor];
        _likeLabel.textColor = [UIColor colorWithRed:0xCE/255.0 green:0x21/255.0 blue:0x2A/255.0 alpha:1.0];
        _likeLabel.font = [UIFont systemFontOfSize:12];
        _likeLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_likeLabel];
    }
    CGFloat likeLabelY = CGRectGetMaxY(self.displayLabel.frame);
    if( CGRectGetHeight(self.displayLabel.bounds) > 0 )
    {
        likeLabelY += 8;
    }
    _likeLabel.frame = CGRectMake( CGRectGetMaxX(self.likeView.frame) + 4, likeLabelY, CGRectGetWidth(self.displayLabel.frame) - CGRectGetMaxX(self.likeView.frame), 13 );
    
    return _likeLabel;
}

- (UILabel *)priceLabel
{
    if( !_priceLabel )
    {
        _priceLabel = [[UILabel alloc] init];
//        _priceLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _priceLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.layer.cornerRadius = 3.0;
        _priceLabel.clipsToBounds = YES;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UIButton *)openButton
{
    if( !_openButton )
    {
        UIImage* image = [UIImage imageNamed:@"展开_按钮.png"];
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - image.size.width, CGRectGetHeight(self.bounds) - image.size.height, image.size.width, image.size.height);
        _openButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_openButton setBackgroundImage:image forState:UIControlStateNormal];
        _openButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_openButton];
    }
    return _openButton;
}

//LX add
- (UILabel *)supportNumLabel
{
    if( !_supportNumLabel )
    {
        _supportNumLabel = [[UILabel alloc] init];
//        _supportNumLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _supportNumLabel.backgroundColor = [UIColor clearColor];
        _supportNumLabel.textColor = [UIColor darkGrayColor];
        _supportNumLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        _supportNumLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_supportNumLabel];
    }
    return _supportNumLabel;
}

- (UIButton *)button
{
    if( !_button )
    {
        _button = [[UIButton alloc] init];
        _button.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_button];
    }
    return _button;
}

#pragma mark - Life Cycle

- (void)dealloc
{
    [_imageView removeFromSuperview];
    _imageView = nil;
    
    [_logoImageView removeFromSuperview];
    _logoImageView = nil;
    
    [_displayLabel removeFromSuperview];
    _displayLabel = nil;
    
    [_supportNumLabel removeFromSuperview];
    _supportNumLabel=nil;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        if( !_imageView )
        {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetMaxX(self.contentView.bounds), CGRectGetMaxY(self.contentView.bounds))];
            _imageView.backgroundColor = [UIColor clearColor];
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
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
//            _imageView.layer.masksToBounds = YES;
            
            [self.contentView addSubview:_imageView];
        }
    }
    return self;
}

@end
