//
//  MmiaDetailSpecialViewWaterfallHeader.m
//  MmiaHD
//
//  Created by lixiao on 15/3/10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaDetailSpecialViewWaterfallHeader.h"
#import "AdditionHeader.h"
#import "UIImageView+WebCache.h"

@interface MmiaDetailSpecialViewWaterfallHeader ()<UIScrollViewDelegate>{
    UIScrollView  *_usersScrollView;
    UIButton      *_nextButton;
    UIButton      *_preButton;
}

@property (nonatomic, retain) NSArray *idArr;

@end

@implementation MmiaDetailSpecialViewWaterfallHeader


- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.frame), 30)];
        _titleLabel.textAlignment = MMIATextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = ColorWithHexRGB(0xffffff);
        _titleLabel.font = UIFontSystem(30);
    }
    return _titleLabel;
}

- (UILabel *)creatLabel
{
    if (!_creatLabel)
    {
        _creatLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, CGRectGetWidth(self.frame), 20)];
        _creatLabel.textAlignment = MMIATextAlignmentCenter;
        _creatLabel.backgroundColor = [UIColor clearColor];
        _creatLabel.textColor = ColorWithHexRGB(0xffffff);
        _creatLabel.font = UIFontSystem(20);
    }
    return _creatLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
         self.bgImageView = [[UIImageView alloc]initWithFrame:frame];
        [self addContentToHeader];
    }
    return self;
}

- (void)addContentToHeader
{
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.creatLabel];
    
    UIImage *concernImage = [UIImage imageNamed:@"personalcenter_addConcernbtn.png"];
    self.concernButton = [[UIButton alloc]initWithFrame:CGRectMake((self.width - concernImage.size.width - 20)/2, self.creatLabel.bottom + 15, concernImage.size.width + 20, concernImage.size.height)];
    [self.concernButton setImage:concernImage forState:UIControlStateNormal];
    [self.concernButton addTarget:self action:@selector(concernButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.concernButton];
    
    _usersScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake((self.width - 390) / 2, self.height - 70 - 10, 390, 70)];
    _usersScrollView.delegate = self;
    _usersScrollView.backgroundColor = [UIColor clearColor];
    _usersScrollView.pagingEnabled = YES;
    _usersScrollView.bounces = NO;
    _usersScrollView.alwaysBounceVertical = NO;
    _usersScrollView.alwaysBounceHorizontal = YES;
    _usersScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_usersScrollView];
    
    UIImage *preImage = [UIImage imageNamed:@"personalcenter_perBtn.png"];
    _preButton = [[UIButton alloc]initWithFrame:CGRectMake(_usersScrollView.left - preImage.size.width - 10, self.height - 70 - 10, preImage.size.width, 70)];
     _preButton.layer.opacity = 0;
    _preButton.tag = 100;
    [_preButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_preButton setImage:preImage forState:UIControlStateNormal];
    [_preButton setTitle:@"pre" forState:UIControlStateNormal];
    [self addSubview:_preButton];
    
    _nextButton = [[UIButton alloc]initWithFrame:CGRectMake(_usersScrollView.right,self.height - 70 - 10, 70, 70)];
    _nextButton.tag = 101;
    [_nextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setImage:[UIImage imageNamed:@"personalcenter_nextBtn.png"] forState:UIControlStateNormal];
    [self addSubview:_nextButton];
}

#pragma mark - Public

- (void)resetInfoAtHeaderUserDict:(NSDictionary *)userDict MagezineFans:(NSArray *)magezineFans
{
    
    self.titleLabel.text = [userDict objectForKey:@"title"];
    self.creatLabel.text = [userDict objectForKey:@"createTime"];
    
    NSInteger isAttention = [[userDict objectForKey:@"isAttention"]integerValue];
    if (isAttention == 0)
    {
        [self.concernButton setImage:[UIImage imageNamed:@"personalcenter_addConcernbtn.png"] forState:UIControlStateNormal];
        self.concernButton.hidden = YES;
        
    }else if (isAttention == 1)
    {
        [self.concernButton setImage:[UIImage imageNamed:@"personalcenter_concernbtn.png"] forState:UIControlStateNormal];
        self.concernButton.hidden = YES;
        
    }else
    {
        self.concernButton.hidden = YES;
    }

    if (self.bgImageView.image == nil)
    {
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[userDict objectForKey:@"magazineCover"]]];
    }
    
    NSDictionary *ownDict = [NSDictionary dictionaryWithObjectsAndKeys:[userDict objectForKey:@"usericon"], @"headPicture",[userDict objectForKey:@"userId"], @"id", nil];
    NSMutableArray *userArr = [NSMutableArray arrayWithArray:magezineFans];
    [userArr insertObject:ownDict atIndex:0];
    self.userArr = userArr;
  
    for (int i = 0; i < userArr.count ; i++)
    {
        NSString *imageName = [[userArr objectAtIndex:i]objectForKey:@"headPicture"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(80 * i, 0, 70, _usersScrollView.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = CGRectGetHeight(imageView.frame) / 2.0;
        imageView.tag = i;
       [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
        [_usersScrollView addSubview:imageView];
        if (i == 0)
        {
            UILabel *ownLabel = [[UILabel alloc]initWithFrame:CGRectMake((70 - 63)/2.0, 70 - 18, 63, 18)];
            ownLabel.backgroundColor = ColorWithHexRGB(0xd51024);
            ownLabel.textAlignment = MMIATextAlignmentCenter;
            [ownLabel setText:@"创建者"];
            [ownLabel setTextColor:ColorWithHexRGB(0xffffff)];
            [_usersScrollView addSubview:ownLabel];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapClick:)];
        [imageView addGestureRecognizer:tap];
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
//        titleLabel.textAlignment = MMIATextAlignmentCenter;
//        titleLabel.text = [NSString stringWithFormat:@"%d", i];
        //[imageView addSubview:titleLabel];
    }

    if (userArr.count < 5)
    {
        _usersScrollView.frame = CGRectMake((self.width - (80 * userArr.count - 10)) / 2,self.height - 70 -10, 80 * userArr.count - 10, _usersScrollView.height);
        _nextButton.layer.opacity = 0;
    }else
    {
        _usersScrollView.frame = CGRectMake((self.width - 390) / 2, self.height - 70 -10 , 390, 70);
        _nextButton.layer.opacity = 1;
    }
    
    [_usersScrollView setContentSize:CGSizeMake(80 * userArr.count - 10, _usersScrollView.height)];
    
}

#pragma mark - Private

- (void)concernButtonClick:(UIButton *)concernButton
{
    if ([self.specialDelegate respondsToSelector:@selector(doClickConcernButton:)])
    {
        [self.specialDelegate doClickConcernButton:concernButton];
    }
}

- (void)buttonClick:(UIButton *)button
{
    CGFloat offSetX = _usersScrollView.contentOffset.x;
    
    CGFloat width = _usersScrollView.frame.size.width;
    CGFloat sizeWidth = _usersScrollView.contentSize.width;
    switch (button.tag)
    {
        case 100:
            if (offSetX - width < 0)
            {
                [_usersScrollView setContentOffset:CGPointMake(0, 0)];
            }else
            {
                [_usersScrollView setContentOffset:CGPointMake(offSetX - width, 0)];
            }
            break;
        case 101:
            if (offSetX + width * 2 > sizeWidth)
            {
                [_usersScrollView setContentOffset:CGPointMake(sizeWidth - width,0)];
            }else{
                [_usersScrollView setContentOffset:CGPointMake(offSetX + width, 0)];
            }
            break;
        default:
            break;
    }
}

- (void)imageViewTapClick:(UITapGestureRecognizer *)tap
{
    if ([self.specialDelegate respondsToSelector:@selector(tapUserImageViewUserId:)])
    {
        UIImageView *imageView = (UIImageView *)tap.view;
        NSDictionary *userDict = [self.userArr objectAtIndex:imageView.tag];
        NSInteger userId = [[userDict objectForKey:@"id"]integerValue];
        [self.specialDelegate tapUserImageViewUserId:userId];
    }
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x + 80 * 5 - 10 >=  scrollView.contentSize.width )
    {
        if (_nextButton.layer.opacity != 0)
        {
            [UIView animateWithDuration:1 animations:^{
                _nextButton.layer.opacity = 0;
            }];
        }

    }else
    {
         if (_nextButton.layer.opacity == 0)
         {
             [UIView animateWithDuration:1 animations:^{
                 _nextButton.layer.opacity = 1;
             }];
         }
        
    }
    
    if (scrollView.contentOffset.x <= 0)
    {
        [UIView animateWithDuration:1 animations:^{
            _preButton.layer.opacity = 0;
        }];
    }else
    {
        [UIView animateWithDuration:1 animations:^{
            _preButton.layer.opacity = 1;
        }];
    }
}

@end
