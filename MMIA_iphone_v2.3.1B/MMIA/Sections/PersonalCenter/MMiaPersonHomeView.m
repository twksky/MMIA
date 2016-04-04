//
//  MMiaPersonHomeView.m
//  MMIA
//
//  Created by lixiao on 15/1/29.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMiaPersonHomeView.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+WebCache.h"

#define rad(degrees) ((degrees) / (180.0 / M_PI))
@interface MMiaPersonHomeView ()
@property (nonatomic, retain) UIImageView *backGroundImageView;
@property (nonatomic, retain) UIView      *setBackView;
@property (nonatomic, retain) UIView      *concernBackView;
@property (nonatomic, retain) UIView      *funsBackView;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UIImageView *sexImageView;
@property (nonatomic, retain) UILabel     *signatureLabel;
@property (nonatomic, retain) UILabel     *concernLabel;
@property (nonatomic, retain) UILabel     *funsLabel;
@property (nonatomic, retain) UILabel     *lineLabel;
@property (nonatomic, retain) UILabel     *funsContent;
@property (nonatomic, retain) UILabel     *concernContent;

@end

@implementation MMiaPersonHomeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.backGroundImageView];
        [self addSubview:self.setBackView];
        [self.setBackView addSubview:self.headImageView];
        [self.setBackView addSubview:self.nikeNameLabel];
        [self.setBackView addSubview:self.signatureLabel];
        [self.setBackView addSubview:self.sexImageView];
        [self addSubview:self.concernBackView];
        [self.concernBackView addSubview:self.concernLabel];
        [self.concernBackView addSubview:self.concernContent];
        [self addSubview:self.funsBackView];
        [self.funsBackView addSubview:self.funsLabel];
        [self.funsBackView addSubview:self.funsContent];
        [self addSubview:self.lineLabel];
        [self.setBackView addSubview:self.addConcernButton];
    }
    return self;
}

#pragma mark - Public
-(void)resetSubViewsWithDictionary:(LoginInfoItem *)loginItem
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:loginItem.headImageUrl] placeholderImage:[UIImage imageNamed:@"personal_03.png"]];
    self.nikeNameLabel.text = loginItem.nikeName;
   if (loginItem.userType == 0)
   {
       CGFloat width = [self.nikeNameLabel.text sizeWithFont:self.nikeNameLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.nikeNameLabel.frame)) lineBreakMode:NSLineBreakByWordWrapping].width + 4;
       UIImage *sexImage;
       if (loginItem.sex == 0)
       {
           sexImage = [UIImage imageNamed:@"personalcenter_sexmanicon.png"];
       }else
       {
           sexImage = [UIImage imageNamed:@"personalcenter_sexwomanicon.png"];
       }
       self.nikeNameLabel.frame = CGRectMake((CGRectGetWidth(self.setBackView.frame) - width)/2.0, CGRectGetHeight(self.headImageView.frame) + 6 + 4, width, 19);
       self.sexImageView.image = sexImage;
       self.sexImageView.bounds = CGRectMake(0, 0, sexImage.size.width, sexImage.size.height);
       self.sexImageView.center = CGPointMake(width/2 + 2 + sexImage.size.width/2 + self.nikeNameLabel.center.x, self.nikeNameLabel.center.y);
    }else
    {
        self.nikeNameLabel.frame = CGRectMake(0, CGRectGetHeight(self.headImageView.frame) + 6 + 4, 200, 19);
        self.sexImageView.hidden = YES;
    }
    self.signatureLabel.text = loginItem.signature;
    NSString *concernText = [NSString stringWithFormat:@"%d",loginItem.focusPersonNumber];
    CGFloat concernWidth = [concernText sizeWithFont:self.concernLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.concernLabel.frame)) lineBreakMode:NSLineBreakByWordWrapping].width + 20;
    self.concernBackView.frame = CGRectMake(App_Frame_Width/2-12-concernWidth, CGRectGetHeight(self.frame)-27, concernWidth, 27);
    self.concernLabel.frame = CGRectMake(0, 0, concernWidth, 12.5);
    self.concernLabel.text = concernText;
    self.concernContent.bounds = self.concernLabel.bounds;
    self.concernContent.center = CGPointMake(self.concernLabel.center.x, self.concernLabel.center.y +  12.5);
    NSString *funsText = [NSString stringWithFormat:@"%d", loginItem.fansNumber];
    CGFloat funsWidth = [funsText sizeWithFont:self.funsLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.funsLabel.frame)) lineBreakMode:NSLineBreakByWordWrapping].width + 20;
    self.funsBackView.frame = CGRectMake(App_Frame_Width/2 + 12, CGRectGetHeight(self.frame)-27, funsWidth, 27);
    self.funsLabel.frame = CGRectMake(0, 0, funsWidth, 12.5);
    self.funsLabel.text = funsText;
    self.funsContent.bounds = self.funsLabel.bounds;
    self.funsContent.center = CGPointMake(self.funsLabel.center.x, self.funsLabel.center.y +  12.5);
}


#pragma mark - setter

-(UIImageView *)backGroundImageView
{
    if (!_backGroundImageView)
    {
        _backGroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
       
        UIImage *backImage = [UIImage imageNamed:@"personalcenter_head_bg.png"];
      // backImage = [backImage applyLightEffect];
        _backGroundImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _backGroundImageView.clipsToBounds = YES;
        _backGroundImageView.layer.masksToBounds = YES;
        _backGroundImageView.image = backImage;
    }
    return _backGroundImageView;
}

-(UIView *)setBackView
{
    if (!_setBackView)
    {
        _setBackView = [[UIView alloc]initWithFrame:CGRectMake((App_Frame_Width - 200)/2, 44 + VIEW_OFFSET, 200, 250/2)];
        _setBackView.backgroundColor = [UIColor clearColor];
        _setBackView.userInteractionEnabled = YES;
        _setBackView.tag = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_setBackView addGestureRecognizer:tap];
    }
    return _setBackView;
}

-(UIView *)concernBackView
{
    if (!_concernBackView)
    {
        _concernBackView = [[UIView alloc]initWithFrame:CGRectMake(App_Frame_Width/2-12-20, CGRectGetHeight(self.frame)-27, 20, 25)];
        _concernBackView.backgroundColor = [UIColor clearColor];
        _concernBackView.userInteractionEnabled = YES;
        _concernBackView.tag = 1;
        UITapGestureRecognizer *concernTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_concernBackView addGestureRecognizer:concernTap];
    }
    return _concernBackView;
}

-(UIView *)funsBackView
{
    if (!_funsBackView)
    {
        _funsBackView = [[UIView alloc]initWithFrame:CGRectMake(App_Frame_Width/2+12, CGRectGetHeight(self.frame)-27, 20, 25)];
        _funsBackView.backgroundColor = [UIColor clearColor];
        _funsBackView.userInteractionEnabled = YES;
        _funsBackView.tag = 2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_funsBackView addGestureRecognizer:tap];
    }
    return _funsBackView;
}

-(UIImageView *)headImageView
{
    if (!_headImageView)
    {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.backgroundColor = [UIColor clearColor];
        _headImageView.frame = CGRectMake((200-80)/2, 3, 80, 80);
        _headImageView.image = [UIImage imageNamed:@"personal_03.png"];
        _headImageView.layer.cornerRadius = (CGRectGetHeight(_headImageView.frame))/2.0 ;
         _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.masksToBounds = NO;
        _headImageView.clipsToBounds = YES;
       
//        CGPoint addCenter = CGPointMake(CGRectGetMidX(_headImageView.bounds)+3, CGRectGetMidY(_headImageView.bounds) + 3);
//        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:addCenter radius:CGRectGetMidX(_headImageView.bounds) + 3 startAngle:-rad(90) endAngle:rad(360-90) clockwise:YES];
//        
//        CAShapeLayer* backgroundLayer = [CAShapeLayer layer];
//        backgroundLayer.path          = circlePath.CGPath;
//        backgroundLayer.strokeColor   = [UIColor greenColor].CGColor;
//        backgroundLayer.fillColor     = [[UIColor clearColor] CGColor];
//        backgroundLayer.lineWidth     = 3;
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_headImageView.frame) - 3, CGRectGetMinY(_headImageView.frame)- 3, CGRectGetWidth(_headImageView.frame) + 6 , CGRectGetHeight(_headImageView.frame) + 6)];
        backgroundView.layer.cornerRadius = CGRectGetWidth(backgroundView.frame)/2.f;
        backgroundView.layer.masksToBounds = NO;
        backgroundView.clipsToBounds = YES;
        backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        //[backgroundView.layer addSublayer:backgroundLayer];
       [self.setBackView addSubview:backgroundView];

    }
    return _headImageView;
}

-(UIButton *)addConcernButton
{
    if (!_addConcernButton)
    {
        _addConcernButton = [[UIButton alloc]init];
        UIImage *addImage = [UIImage imageNamed:@"personalcenter_plusicon.png"];
        _addConcernButton.frame = CGRectMake((200-80)/2 + 73 - addImage.size.width, 81 - addImage.size.height, addImage.size.width + 10, addImage.size.height + 10);
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
        _nikeNameLabel.frame = CGRectMake(0, CGRectGetHeight(self.headImageView.frame) + 6 +4, 200, 19);
        _nikeNameLabel.backgroundColor = [UIColor clearColor];
        _nikeNameLabel.textAlignment = MMIATextAlignmentCenter;
        _nikeNameLabel.font = [UIFont systemFontOfSize:15];
        _nikeNameLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _nikeNameLabel;
}

-(UILabel *)signatureLabel
{
    if (!_signatureLabel)
    {
        _signatureLabel = [[UILabel alloc]init];
        _signatureLabel.frame = CGRectMake(5, CGRectGetHeight(self.setBackView.frame) - 12, 200 - 10, 12);
        _signatureLabel.backgroundColor = [UIColor clearColor];
        _signatureLabel.textAlignment = MMIATextAlignmentCenter;
        _signatureLabel.font = [UIFont systemFontOfSize:10];
        _signatureLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _signatureLabel;
}

-(UILabel *)concernLabel
{
    if (!_concernLabel)
    {
        _concernLabel = [[UILabel alloc]init];
        _concernLabel.frame = CGRectMake(0, 0, 20, 12.5);
        _concernLabel.backgroundColor = [UIColor clearColor];
        _concernLabel.text = @"0";
        _concernLabel.textAlignment = MMIATextAlignmentCenter;
        _concernLabel.font = [UIFont boldSystemFontOfSize:12];
        _concernLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _concernLabel;
}

-(UILabel *)concernContent
{
    if (!_concernContent)
    {
        _concernContent = [[UILabel alloc]init];
        _concernContent.frame = CGRectMake(0, 12.5, 20, 12.5);
        _concernContent.text = @"关注";
        _concernContent.backgroundColor = [UIColor clearColor];
        _concernContent.textAlignment = MMIATextAlignmentCenter;
        _concernContent.font = [UIFont systemFontOfSize:10];
        _concernContent.textColor = UIColorFromRGB(0xffffff);
    }
    return _concernContent;
}


-(UILabel *)funsLabel
{
    if (!_funsLabel)
    {
        _funsLabel = [[UILabel alloc]init];
        _funsLabel.frame = CGRectMake(0, 0, 20, 12.5);
        _funsLabel.text = @"0";
        _funsLabel.backgroundColor = [UIColor clearColor];
        _funsLabel.textAlignment = MMIATextAlignmentCenter;
        _funsLabel.font = [UIFont boldSystemFontOfSize:12];
        _funsLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _funsLabel;
}


-(UILabel *)funsContent
{
    if (!_funsContent)
    {
        _funsContent = [[UILabel alloc]init];
        _funsContent.frame = CGRectMake(0, 12.5, 20, 12.5);
        _funsContent.text = @"粉丝";
        _funsContent.backgroundColor = [UIColor clearColor];
        _funsContent.textAlignment = MMIATextAlignmentCenter;
        _funsContent.font = [UIFont systemFontOfSize:10];
        _funsContent.textColor = UIColorFromRGB(0xffffff);
    }
    return _funsContent;
}

-(UILabel *)lineLabel
{
    if (!_lineLabel)
    {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = UIColorFromRGB(0xffffff);
        _lineLabel.frame = CGRectMake(App_Frame_Width/2 - 0.5, CGRectGetHeight(self.frame)-27, 1, 24);
    }
    return _lineLabel;
}

#pragma mark - Private

-(void)buttonClick:(UIButton *)addBtn
{
    if ([self.delegate respondsToSelector:@selector(addConcernPerson:)])
    {
        [self.delegate addConcernPerson:addBtn];
    }
}

//总背景
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag)
    {
            //设置
        case 0:
            if ([self.delegate respondsToSelector:@selector(tapInsertSetViewControllerClick)])
            {
                [self.delegate tapInsertSetViewControllerClick];
            }

            break;
            //关注
        case 1:
            if ([self.delegate respondsToSelector:@selector(tapConcernViewClick)])
            {
                [self.delegate tapConcernViewClick];
            }
            break;
            //粉丝
        case 2:
            if ([self.delegate respondsToSelector:@selector(tapFunsViewClick)])
            {
                [self.delegate tapFunsViewClick];
            }
        default:
            break;
    }
    }



@end
