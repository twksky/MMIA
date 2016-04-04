//
//  MMIADetailSpecialViewWaterfallHeader.m
//  MMIA
//
//  Created by Jack on 15/1/30.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMIADetailSpecialViewWaterfallHeader.h"
#import "MMiaDetailSpecialViewController.h"



@interface MMIADetailSpecialViewWaterfallHeader()
{
    
}
@end

@implementation MMIADetailSpecialViewWaterfallHeader
- (id)init
{
    self = [super init];
    if (self)
    {
        _bgImgView = [[UIImageView alloc] init];
        [self addSubview:_bgImgView];
        _createTimeView = [[UILabel alloc] init];
        [self addSubview:_createTimeView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.frame = frame;
        [self addSubview:_bgImgView];
        _createTimeView = [[UILabel alloc] init];
        _createTimeView.frame = CGRectMake((frame.size.width - 100) / 2, 115, 100, 26);
        _createTimeView.textColor = [UIColor whiteColor];
        _createTimeView.font = [UIFont fontWithName:@"createTime" size:13];
        _createTimeView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_createTimeView];
        _attentionBut = [[UIButton alloc] init];
        _attentionBut.frame = CGRectMake((frame.size.width - 90) / 2, 153, 90, 30);
        [self isAttention:0];
        [self.attentionBut addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_attentionBut];
    }
    return self;
}

-(void) attentionClick:(id)but
{
    if ([self.delegate respondsToSelector:@selector(attentionButClinck)])
    {
        [self.delegate attentionButClinck];
    }
}

-(void) isAttention:(NSInteger) attention
{
    UIImage* img = attention == 1 ? [UIImage imageNamed:@"attention_but_selecte.png"] : [UIImage imageNamed:@"attention_but.png"];
    [_attentionBut setImage:img forState:UIControlStateNormal];
}

@end
