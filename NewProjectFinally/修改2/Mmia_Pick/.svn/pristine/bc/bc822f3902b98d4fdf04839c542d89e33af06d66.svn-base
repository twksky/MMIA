//
//  ShareViewFooter.m
//  MMIA
//
//  Created by lixiao on 15/6/12.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "ShareViewFooter.h"

@implementation ShareViewFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self addContentViewToCell];
    }
    return self;
}

- (void)addContentViewToCell
{
   
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.width - 20, 0.5)];
    lineView.backgroundColor = ColorWithHexRGB(0x999999);
    [self addSubview:lineView];
    
    //点赞button
    UIImage *goodImage = [UIImage imageNamed:@"点赞.png"];
    UIButton *goodButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, goodImage.size.width + 20, goodImage.size.height)];
    goodButton.tag = 200;
    [goodButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [goodButton setImage:goodImage forState:UIControlStateNormal];
    [self addSubview:goodButton];
    
    //分享button
    UIImage *shareImage = [UIImage imageNamed:@"分享.png"];
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(goodButton.frame), 10, shareImage.size.width + 20, shareImage.size.height)];
    [shareButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.tag = 201;
    [shareButton setImage:shareImage forState:UIControlStateNormal];
    [self addSubview:shareButton];

}

- (void)buttonClick:(UIButton *)button
{
    if (self.ClickGoodOrShareButton)
    {
        self.ClickGoodOrShareButton(button);
    }
}
@end
