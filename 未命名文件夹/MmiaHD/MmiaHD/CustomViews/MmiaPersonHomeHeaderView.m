//
//  MmiaPersonHomeHeaderView.m
//  MmiaHD
//
//  Created by lixiao on 15/3/11.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaPersonHomeHeaderView.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"

#define ButtonHeight     46

@interface MmiaPersonHomeHeaderView ()
{
    UIView   *_setBackView;
    UIView   *_concernBackView;
    UIView   *_funsBackView;
    UILabel  *_lineLabel;
    NSMutableArray *_buttonArr;
}

@property (nonatomic, retain) UIImageView *sexImageView;
@property (nonatomic, retain) UILabel     *signatureLabel;
@property (nonatomic, retain) UILabel     *funsLabel;
@property (nonatomic, retain) UILabel     *funsContent;
@property (nonatomic, retain) UILabel     *concernLabel;
@property (nonatomic, retain) UILabel     *concernContent;

@end

@implementation MmiaPersonHomeHeaderView

#pragma mark - getter

-(UIImageView *)backGroundImageView
{
    if (!_backGroundImageView)
    {
       
        UIImage *backImage = [UIImage imageNamed:@"personalcenter_topbg.png"];
        _backGroundImageView = [[UIImageView alloc]init];
        _backGroundImageView.image = backImage;
        _backGroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _backGroundImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _backGroundImageView.clipsToBounds = YES;
        _backGroundImageView.layer.masksToBounds = YES;
        _backGroundImageView.image = backImage;
    }
    return _backGroundImageView;
}

-(UIImageView *)headImageView
{
    if (!_headImageView)
    {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.backgroundColor = [UIColor clearColor];
        _headImageView.image = [UIImage imageNamed:@"personalcenter_DefaultPersonPic.png"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *concernTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_headImageView addGestureRecognizer:concernTap];
    }
    return _headImageView;
}

-(UIButton *)addConcernButton
{
    if (!_addConcernButton)
    {
        _addConcernButton = [[UIButton alloc]init];
        UIImage *addImage = [UIImage imageNamed:@"personalcenter_plusicon.png"];
        [_addConcernButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addConcernButton setImage:addImage forState:UIControlStateNormal];
    }
    return _addConcernButton;
}

-(UIImageView *)sexImageView
{
    if (!_sexImageView)
    {
        _sexImageView = [[UIImageView alloc]init];
        _sexImageView.backgroundColor = [UIColor clearColor];
    }
    return _sexImageView;
}

-(UILabel *)nikeNameLabel
{
    if (!_nikeNameLabel)
    {
        _nikeNameLabel = [[UILabel alloc]init];
        _nikeNameLabel.frame = CGRectMake(0,CGRectGetMaxY(self.headImageView.frame) + 7, _setBackView.width, 15);
        _nikeNameLabel.backgroundColor = [UIColor clearColor];
        _nikeNameLabel.textAlignment = MMIATextAlignmentCenter;
        _nikeNameLabel.font = [UIFont systemFontOfSize:21];
        _nikeNameLabel.textColor = ColorWithHexRGB(0xffffff);
    }
    return _nikeNameLabel;
}

-(UILabel *)signatureLabel
{
    if (!_signatureLabel)
    {
        _signatureLabel = [[UILabel alloc]init];
        _signatureLabel.backgroundColor = [UIColor clearColor];
        _signatureLabel.textAlignment = MMIATextAlignmentCenter;
        _signatureLabel.font = [UIFont systemFontOfSize:11];
        _signatureLabel.textColor = ColorWithHexRGB(0xffffff);
    }
    return _signatureLabel;
}

-(UILabel *)concernLabel
{
    if (!_concernLabel)
    {
        _concernLabel = [[UILabel alloc]init];
        _concernLabel.frame = CGRectMake(0, 0, 40, 20);
        _concernLabel.backgroundColor = [UIColor clearColor];
        _concernLabel.text = @"0";
        _concernLabel.textAlignment = MMIATextAlignmentCenter;
        _concernLabel.font = [UIFont boldSystemFontOfSize:14];
        _concernLabel.textColor = ColorWithHexRGB(0xffffff);
    }
    return _concernLabel;
}

-(UILabel *)concernContent
{
    if (!_concernContent)
    {
        _concernContent = [[UILabel alloc]init];
        _concernContent.frame = CGRectMake(0, 20, 40, 20);
        _concernContent.text = @"关注";
        _concernContent.backgroundColor = [UIColor clearColor];
        _concernContent.textAlignment = MMIATextAlignmentCenter;
        _concernContent.font = [UIFont systemFontOfSize:11];
        _concernContent.textColor = ColorWithHexRGB(0xffffff);
    }
    return _concernContent;
}

-(UILabel *)funsLabel
{
    if (!_funsLabel)
    {
        _funsLabel = [[UILabel alloc]init];
        _funsLabel.frame = CGRectMake(0, 0, 40, 20);
        _funsLabel.text = @"0";
        _funsLabel.backgroundColor = [UIColor clearColor];
        _funsLabel.textAlignment = MMIATextAlignmentCenter;
        _funsLabel.font = [UIFont boldSystemFontOfSize:14];
        _funsLabel.textColor = ColorWithHexRGB(0xffffff);
    }
    return _funsLabel;
}

-(UILabel *)funsContent
{
    if (!_funsContent)
    {
        _funsContent = [[UILabel alloc]init];
        _funsContent.frame = CGRectMake(0, 20, 40, 20);
        _funsContent.text = @"粉丝";
        _funsContent.backgroundColor = [UIColor clearColor];
        _funsContent.textAlignment = MMIATextAlignmentCenter;
        _funsContent.font = [UIFont systemFontOfSize:11];
        _funsContent.textColor = ColorWithHexRGB(0xffffff);
    }
    return _funsContent;
}


- (void)resetFrame:(CGRect)frame
{
    self.frame = frame;
    self.backGroundImageView.frame = CGRectMake(0, 0, self.width, self.height - ButtonHeight);
     UIImage *setImage = [UIImage imageNamed:@"personalcenter_settingicon.png"];
    
    self.setButton.frame = CGRectMake(0, self.height - ButtonHeight - 20 - setImage.size.height, setImage.size.width + 40, setImage.size.height);
    
    _setBackView.frame = CGRectMake((self.width- 400)/2, 0, 400, 175);
    _signatureLabel.frame = CGRectMake(5, CGRectGetHeight(_setBackView.frame) - 12, _setBackView.width - 10, 12);
    _headImageView.frame = CGRectMake((_setBackView.width - 110) / 2, 20, 110, 110);
    _headImageView.layer.cornerRadius = (CGRectGetHeight(_headImageView.frame))/2.0 ;
    UIImage *addImage = [UIImage imageNamed:@"personalcenter_plusicon.png"];
    _addConcernButton.frame = CGRectMake((400-110)/2 + 90 - addImage.size.width, 130 - addImage.size.height - 10, addImage.size.width + 20, addImage.size.height + 20);
    _concernBackView.frame = CGRectMake(self.width / 2- 12 - 40, CGRectGetHeight(self.frame) - 45 - ButtonHeight, 40, 40);
    _lineLabel.frame = CGRectMake(self.width / 2 - 0.5, self.height - 40 - ButtonHeight, 1, 30);
    _funsBackView.frame = CGRectMake(self.width / 2+ 12, CGRectGetHeight(self.frame) - 45 - ButtonHeight, 40, 40);
    
}

#pragma mark - Init

-(id)init
{
    self = [super init];
    if (self)
    {
        _buttonArr = [[NSMutableArray alloc]init];
        [self addContentToView];
    }
    return self;
}

- (void)addContentToView
{
    [self addSubview:self.backGroundImageView];
    
    UIImage *setImage = [UIImage imageNamed:@"personalcenter_settingicon.png"];
    self.setButton = [[UIButton alloc]init];
    [self.setButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.setButton setImage:setImage forState:UIControlStateNormal];
    [self addSubview:self.setButton];
    //设置页面作用区域
    _setBackView = [[UIView alloc]init];
    _setBackView.backgroundColor = [UIColor clearColor];
    _setBackView.userInteractionEnabled = YES;
    [self addSubview:_setBackView];
    [_setBackView addSubview:self.headImageView];
    [_setBackView addSubview:self.nikeNameLabel];
    [_setBackView addSubview:self.sexImageView];
    [_setBackView addSubview:self.signatureLabel];
    [_setBackView addSubview:self.addConcernButton];
    
    //关注页面作用设置
    _concernBackView = [[UIView alloc]init];
    _concernBackView.backgroundColor = [UIColor clearColor];
    _concernBackView.userInteractionEnabled = YES;
    [self addSubview:_concernBackView];
    [_concernBackView addSubview:self.concernContent];
    [_concernBackView addSubview:self.concernLabel];
    
    _lineLabel = [[UILabel alloc]init];
    _lineLabel.backgroundColor = ColorWithHexRGB(0xffffff);
    [self addSubview:_lineLabel];
    
    //粉丝页面作用设置
    _funsBackView = [[UIView alloc]init];
    _funsBackView.backgroundColor = [UIColor clearColor];
    _funsBackView.userInteractionEnabled = YES;
    [self addSubview:_funsBackView];
    [_funsBackView addSubview:self.funsContent];
    [_funsBackView addSubview:self.funsLabel];
}

#pragma mark - Public

-(void)resetSubViewsWithDictionary:(LoginInfoItem *)loginItem
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:loginItem.headImageUrl] placeholderImage:[UIImage imageNamed:@"personalcenter_DefaultPersonPic.png"]];
    self.nikeNameLabel.text = loginItem.nikeName;
    
    if (loginItem.userType == 0)
    {
        CGFloat width = [GlobalFunction getTextWidthWithSystemFont:self.nikeNameLabel.font ConstrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.nikeNameLabel.frame)) string:self.nikeNameLabel.text] + 4;
        UIImage *sexImage;
        if (loginItem.sex == 0)
        {
            sexImage = [UIImage imageNamed:@"personalcenter_sexMan.png"];
        }else
        {
            sexImage = [UIImage imageNamed:@"personalcenter_sexWoman.png"];
        }
        self.nikeNameLabel.frame = CGRectMake((CGRectGetWidth(_setBackView.frame) - width)/2.0,CGRectGetMaxY(self.headImageView.frame) + 7, width, 15);
        self.sexImageView.image = sexImage;
        self.sexImageView.bounds = CGRectMake(0, 0, sexImage.size.width, sexImage.size.height);
        self.sexImageView.center = CGPointMake(width/2 + 2 + sexImage.size.width/2 + self.nikeNameLabel.center.x, self.nikeNameLabel.center.y);
    }else
    {
        _nikeNameLabel.frame = CGRectMake(0,CGRectGetMaxY(self.headImageView.frame) + 7, _setBackView.width, 15);
        self.sexImageView.hidden = YES;
    }
    self.signatureLabel.text = loginItem.signature;
    
    NSString *concernText = [NSString stringWithFormat:@"%ld",(long)loginItem.focusPersonNumber];
    CGFloat concernWidth = [GlobalFunction getTextWidthWithSystemFont:self.concernLabel.font ConstrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.concernLabel.frame)) string:concernText] + 20;
    _concernBackView.frame = CGRectMake(self.width / 2- 12 - concernWidth, CGRectGetHeight(self.frame) - 45 - ButtonHeight, concernWidth, 40);
    self.concernLabel.frame = CGRectMake(0, 0, concernWidth, 20);
    self.concernLabel.text = concernText;
    self.concernContent.bounds = self.concernLabel.bounds;
    self.concernContent.center = CGPointMake(self.concernLabel.center.x, self.concernLabel.center.y +  20);
    
    
    NSString *funsText = [NSString stringWithFormat:@"%ld", (long)loginItem.fansNumber];
    CGFloat funsWidth =[GlobalFunction getTextWidthWithSystemFont:self.funsLabel.font ConstrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.funsLabel.frame)) string:funsText] + 20;
    
    _funsBackView.frame = CGRectMake(self.width / 2+ 12, CGRectGetHeight(self.frame) - 45 - ButtonHeight, funsWidth, 40);
    self.funsLabel.frame = CGRectMake(0, 0, funsWidth, 20);
    self.funsLabel.text = funsText;
    self.funsContent.bounds = self.funsLabel.bounds;
    self.funsContent.center = CGPointMake(self.funsLabel.center.x, self.funsLabel.center.y +  20);
}

#pragma mark - Private

-(void)buttonClick:(UIButton *)button
{
    if (button == _addConcernButton)
    {
        if ([self.delegate respondsToSelector:@selector(addConcernPerson:)])
        {
            [self.delegate addConcernPerson:button];
        }
    }else if (button == _setButton)
    {
        if ([self.delegate respondsToSelector:@selector(tapSetButton)])
        {
            [self.delegate tapSetButton];
        }
    }
    
}

//总背景
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(tapSetHeadImageViewClickImageView:)])
    {
        UIImageView *imageView = (UIImageView *)tap.view;
        [self.delegate tapSetHeadImageViewClickImageView:imageView];
    }
}


@end
