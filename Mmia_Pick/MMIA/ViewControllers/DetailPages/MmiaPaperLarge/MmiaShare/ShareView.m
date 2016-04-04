//
//  ShareView.m
//  MMIA
//
//  Created by twksky on 15/5/18.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "ShareView.h"



@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self createBottomBtn];
        
    }
    return self;
}

-(void)createBottomBtn{
    //点赞按钮
    self.goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodBtn.backgroundColor = [UIColor redColor];
    [self.goodBtn addTarget:self action:@selector(goodClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.goodBtn.frame = CGRectMake(0, 0, 80, 40);
    
    //分享按钮
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.backgroundColor = [UIColor redColor];
    [self.shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.shareBtn.frame = CGRectMake(0, 0, 80, 40);
    
    [self addSubview:self.shareBtn];
    [self addSubview:self.goodBtn];
    [self.goodBtn mas_makeConstraints:^(MASConstraintMaker *make){
        //            make.width.equalTo(@(setImage.size.width + 10));
        //            make.height.equalTo(@(setImage.size.height + 10));
        //            make.right.equalTo(@(setImage.size.width - 30));
        //            make.top.equalTo(@(top));
        make.left.equalTo(@(10));
        make.top.equalTo(@(10));
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make){
        //            make.width.equalTo(@(setImage.size.width + 10));
        //            make.height.equalTo(@(setImage.size.height + 10));
        //            make.right.equalTo(@(setImage.size.width - 30));
        //            make.top.equalTo(@(top));
        make.left.equalTo(self.goodBtn.mas_right).offset(10);
        make.top.equalTo(@(10));
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
   
}

//btnClick
-(void)goodClick:(UIButton *)btn{
    NSLog(@"点赞");
}

-(void)shareClick:(UIButton *)btn{
    UIMenuBarItem *menuItem1 = [[UIMenuBarItem alloc] initWithTitle:nil target:self image:[UIImage imageNamed:@"微信分享"] action:@selector(clickAction:)tag:11];
    UIMenuBarItem *menuItem2 = [[UIMenuBarItem alloc] initWithTitle:nil target:self image:[UIImage imageNamed:@"朋友圈分享"] action:@selector(clickAction:)tag:12];
    UIMenuBarItem *menuItem3 = [[UIMenuBarItem alloc] initWithTitle:nil target:self image:[UIImage imageNamed:@"微博分享"] action:@selector(clickAction:)tag:13];
    UIMenuBarItem *menuItem4 = [[UIMenuBarItem alloc] initWithTitle:nil target:self image:[UIImage imageNamed:@"QQ分享"] action:@selector(clickAction:)tag:14];
    
    
    NSMutableArray *items = [NSMutableArray arrayWithObjects:menuItem1, menuItem2, menuItem3, menuItem4 ,nil];
    
    _menuBar = [[UIMenuBar alloc] initWithFrame:CGRectMake(0, 0, 320, 80.0f) items:items];

    _menuBar.items = [NSMutableArray arrayWithObjects:menuItem1, menuItem2, menuItem3, menuItem4, nil];
    [_menuBar show];
}

- (void)clickAction:(UIButton *)btn
{
    if (btn.tag == 11) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"WXShare" object:nil
         ];
    }
    if (btn.tag == 12) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FriendShare" object:nil
         ];
    }
    if (btn.tag == 13) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"WBShare" object:nil
         ];
    }
    if (btn.tag == 14) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"QQShare" object:nil
         ];
    }
    
    [_menuBar dismiss];
}





@end
