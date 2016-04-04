//
//  MmiaDetailGoodsWaterfallHeader.m
//  MmiaHD
//
//  Created by lixiao on 15/3/16.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaDetailGoodsWaterfallHeader.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"
#import "UIImageView+WebCache.h"

#define WIDTH  600

@implementation MmiaDetailGoodsWaterfallHeader

#pragma mark - setter

- (UIImageView *)topImageView
{
    if (!_topImageView)
    {
        _topImageView = [[UIImageView alloc]init];
        _topImageView.clipsToBounds = YES;
        //_topImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_topImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _topImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = MMIATextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = ColorWithHexRGB(0x404040);
    }
    return _titleLabel;
}

- (UIImageView *)headImageView
{
    if (!_headImageView)
    {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.userInteractionEnabled = YES;
        _headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (UILabel *)nikeNameLabel
{
    if (!_nikeNameLabel)
    {
        _nikeNameLabel = [[UILabel alloc]init];
        _nikeNameLabel.backgroundColor = [UIColor clearColor];
        _nikeNameLabel.font = [UIFont systemFontOfSize:15];
        _nikeNameLabel.textColor = ColorWithHexRGB(0x404040);
        _nikeNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nikeNameLabel;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel)
    {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.numberOfLines = 0;
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont systemFontOfSize:13];
        _infoLabel.textColor = ColorWithHexRGB(0x696969);
    }
    return _infoLabel;
}

- (UIButton *)collectionButton
{
    if (!_collectionButton)
    {
        _collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 130, 50)];
        _collectionButton.backgroundColor = ColorWithHexRGB(0x272832);
        [_collectionButton setTitleColor:ColorWithHexRGB(0xffffff) forState:UIControlStateNormal];
        [_collectionButton.titleLabel setFont:UIFontSystem(30)];
        [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        _collectionButton.layer.masksToBounds = YES;
        _collectionButton.tag = 101;
        _collectionButton.layer.cornerRadius = 25.0f;
        [_collectionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionButton;
}

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = ColorWithHexRGB(0xf1f1f1);
        _buttonArr = [[NSMutableArray alloc]init];
        _topBgView = [[UIView alloc]init];
        _topBgView = [[UIView alloc]init];
        _topBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topBgView];
        
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = ColorWithHexRGB(0x272832);
        [self addSubview:_lineLabel];
        
        _middleView = [[UIView alloc]init];
        _middleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_middleView];
        
        _lastView = [[UIView alloc]init];
        _lastView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lastView];
        
        [_topBgView addSubview:self.topImageView];
        [_topBgView addSubview:self.titleLabel];
        [_topBgView addSubview:_lineLabel];
        
        _likeButton = [[UIButton alloc]init];
        _likeButton.tag = 100;
        _likeButton.backgroundColor = [UIColor clearColor];
        [_likeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topBgView addSubview:_likeButton];
        
        [_middleView addSubview:self.headImageView];
        [_middleView addSubview:self.nikeNameLabel];
        [_middleView addSubview:self.collectionButton];
        self.collectionButton.hidden = YES;
        
        [_lastView addSubview:self.infoLabel];
    }
    return self;
}

#pragma mark - Public

- (void)resetMagezineItem:(MagazineItem *)item infoDict:(NSDictionary *)infoDict
{
    NSDictionary *picDict = [infoDict objectForKey:@"pictures"];
    NSDictionary *userDict = [infoDict objectForKey:@"user"];
    
    self.width = 600;
    CGFloat imageHeight = self.width / item.imageWidth * item.imageHeight;
    self.topImageView.backgroundColor = [UIColor clearColor];
    self.topImageView.frame = CGRectMake(0, 0, self.width, imageHeight);
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
    
    UIImage *likeImage = UIImageNamed(@"personalCenter_likebuttonselected.png");
    self.likeButton.frame = CGRectMake(self.topImageView.right - likeImage.size.width - 40 - 10, self.topImageView.bottom - likeImage.size.height - 20 -10, likeImage.size.width + 20, likeImage.size.height + 20);
    if ([picDict[@"isLike"]integerValue] == 1 )
    {
        [self.likeButton setImage:likeImage forState:UIControlStateNormal];
    }else
    {
        [self.likeButton setImage:UIImageNamed(@"personalCenter_likebutton.png") forState:UIControlStateNormal];
    }
    
    CGFloat labelH = [GlobalFunction getTextHeightWithSystemFont:[UIFont systemFontOfSize:18] ConstrainedToSize:CGSizeMake(self.width - 80, MAXFLOAT) string:item.titleText];
    self.titleLabel.frame = CGRectMake(40, self.topImageView.bottom + 30, self.width - 80, labelH);
    self.titleLabel.text = item.titleText;
    _lineLabel.frame = CGRectMake(40, self.titleLabel.bottom + 24, self.width - 80, 1);
    for (int i = 0; i < _buttonArr.count; i++)
    {
        UIButton *button = (UIButton *)[_buttonArr objectAtIndex:i];
        [button removeFromSuperview];
    }
    
    NSMutableArray *titleArr = [[NSMutableArray alloc]init];
    if ([[picDict objectForKey:@"magazineName"]length] != 0)
    {
        [titleArr addObject:[picDict objectForKey:@"magazineName"]];
    }
    if ([[picDict objectForKey:@"brandName"]length] != 0)
    {
        [titleArr addObject:[picDict objectForKey:@"brandName"]];
    }
    if ([[picDict objectForKey:@"categoryName"]length] != 0)
    {
        [titleArr addObject:[picDict objectForKey:@"categoryName"]];
    }
    int lanscapeWidth = 40, rowSpace = 26, count = 0;
    
    for (int i = 0; i < titleArr.count; i++)
    {
        NSString *str = [titleArr objectAtIndex:i];
        CGFloat width = [GlobalFunction getTextWidthWithSystemFont:[UIFont systemFontOfSize:16] ConstrainedToSize:CGSizeMake(MAXFLOAT, 36) string:str] + 30;
        if ((lanscapeWidth + width + rowSpace) > (self.width - 40))
        {
            count ++;
            lanscapeWidth = 40;
        }
        UIButton *labelButton = [[UIButton alloc]initWithFrame:CGRectMake(lanscapeWidth , _lineLabel.bottom + 30 + count * (36 + 30), width, 36)];
        labelButton.layer.masksToBounds = YES;
        labelButton.layer.borderWidth = 1.0;
        labelButton.layer.borderColor = [ColorWithHexRGB(0x272832)CGColor];
        labelButton.layer.cornerRadius = 18;
        [labelButton addTarget:self action:@selector(searchLabelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [labelButton setTitle:str forState:UIControlStateNormal];
        [labelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [labelButton setTitleColor:ColorWithHexRGB(0x404040) forState:UIControlStateNormal];
        lanscapeWidth += (rowSpace + width);
        [_buttonArr addObject:labelButton];
        [_topBgView addSubview:labelButton];
    }
    CGFloat topHeight = _lineLabel.bottom + (count + 1) * (30 + 36) + 30;
    _topBgView.frame = CGRectMake(0, 0, self.width, topHeight);
    
    _middleView.frame = CGRectMake(0, _topBgView.bottom + 10, self.width, 110);
    _collectionButton.frame = CGRectMake(self.width - 40 - 130 , (110 - 50)/2.0, 130, 50);
    self.headImageView.frame = CGRectMake(40, (_middleView.height - 94) / 2, 94, 94);
    
    _userId = [[userDict objectForKey:@"userId"]integerValue];
    self.headImageView.layer.cornerRadius = 94 / 2;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userDict[@"userPictureUrl"]]];
    self.nikeNameLabel.frame = CGRectMake(0, 0, 200, 20);
    self.nikeNameLabel.center = CGPointMake(self.headImageView.centerX + self.headImageView.width / 2 + 35 + 100, self.headImageView.centerY);
    self.nikeNameLabel.text = userDict[@"nickName"];
    
    NSString *descStr = [picDict objectForKey:@"desc"];
    if (descStr.length == 0)
    {
        return;
    }
    CGFloat descripHeight = [GlobalFunction getTextHeightWithSystemFont:[UIFont systemFontOfSize:13] ConstrainedToSize:CGSizeMake(self.width - 80, MAXFLOAT) string:descStr];
    _lastView.frame = CGRectMake(0, _middleView.bottom + 10, self.width, descripHeight  + 34 *2);
    self.infoLabel.frame = CGRectMake(40, 34, self.width - 80, descripHeight);
    self.infoLabel.text = picDict[@"desc"];
}

+ (CGFloat)getHeightMagezineItem:(MagazineItem *)item infoDict:(NSDictionary *)infoDict
{
    NSDictionary *picDict = [infoDict objectForKey:@"pictures"];
    
    CGFloat imageHeight =  WIDTH / item.imageWidth * item.imageHeight;
    CGFloat labelH = [GlobalFunction getTextHeightWithSystemFont:[UIFont systemFontOfSize:18] ConstrainedToSize:CGSizeMake(WIDTH - 80, MAXFLOAT) string:item.titleText];
    NSMutableArray *titleArr = [[NSMutableArray alloc]init];
    if ([[infoDict objectForKey:@"magazineName"]length] != 0)
    {
        [titleArr addObject:[infoDict objectForKey:@"magazineName"]];
    }
    if ([[infoDict objectForKey:@"brandName"]length] != 0)
    {
        [titleArr addObject:[infoDict objectForKey:@"brandName"]];
    }
    if ([[infoDict objectForKey:@"categoryName"]length] != 0)
    {
        [titleArr addObject:[infoDict objectForKey:@"categoryName"]];
    }
    int lanscapeWidth = 40, rowSpace = 26, count = 0;
    for (int i = 0; i < titleArr.count; i++)
    {
        NSString *str = [titleArr objectAtIndex:i];
        CGFloat width = [GlobalFunction getTextWidthWithSystemFont:[UIFont systemFontOfSize:16] ConstrainedToSize:CGSizeMake(MAXFLOAT, 36) string:str] + 30;
        if ((lanscapeWidth + width + rowSpace) > (WIDTH - 40))
        {
            count ++;
            lanscapeWidth = 40;
        }
        lanscapeWidth += (rowSpace + width);
    }
    CGFloat topHeight = imageHeight + 30 + labelH + 24 + 1 + (count + 1) * (30 + 36) + 30;
    CGFloat midleHeight = 110;
    
    CGFloat lastHeight;
    NSString *descStr = [picDict objectForKey:@"desc"];
    CGFloat descripHeight = [GlobalFunction getTextHeightWithSystemFont:[UIFont systemFontOfSize:13] ConstrainedToSize:CGSizeMake(WIDTH - 80, MAXFLOAT) string:descStr];
    if (descStr.length != 0)
    {
        lastHeight = 68 + descripHeight;
    }else
    {
        lastHeight = 0;
    }
    
    CGFloat height = topHeight + 10 + midleHeight + 10 + lastHeight;
    return height;
}

- (void)buttonClick:(UIButton *)button
{
    switch (button.tag)
    {
      //喜欢
        case 100:
            
            if (self.likeButtonBlock)
            {
                self.likeButtonBlock(button);
            }
            break;
            
        case 101:
            
            if (self.collectionButtonBlock)
            {
                self.collectionButtonBlock(button);
            }
            break;
            
        default:
            break;
    }
}

//搜索
- (void)searchLabelButtonClick:(UIButton *)button
{
    if (self.searchLabelButtonBlock)
    {
        self.searchLabelButtonBlock(button);
    }
}

//点击头像
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    if (self.tapHeadImageViewBlock)
    {
        self.tapHeadImageViewBlock(_userId);
    }
}

@end
