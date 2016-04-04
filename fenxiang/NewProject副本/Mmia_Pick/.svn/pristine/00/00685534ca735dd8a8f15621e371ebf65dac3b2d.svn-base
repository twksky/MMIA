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
    UIMenuBarItem *menuItem1 = [[UIMenuBarItem alloc] initWithTitle:@"QQ分享" target:self image:[UIImage imageNamed:nil] action:@selector(clickAction:)tag:1];
    UIMenuBarItem *menuItem2 = [[UIMenuBarItem alloc] initWithTitle:@"新浪分享" target:self image:[UIImage imageNamed:nil] action:@selector(clickAction:)tag:2];
    UIMenuBarItem *menuItem3 = [[UIMenuBarItem alloc] initWithTitle:@"微博分享" target:self image:[UIImage imageNamed:nil] action:@selector(clickAction:)tag:3];
    UIMenuBarItem *menuItem4 = [[UIMenuBarItem alloc] initWithTitle:@"微信分享" target:self image:[UIImage imageNamed:nil] action:@selector(clickAction:)tag:4];
    UIMenuBarItem *menuItem5 = [[UIMenuBarItem alloc] initWithTitle:@"空间分享" target:self image:[UIImage imageNamed:nil] action:@selector(clickAction:)tag:5];
    UIMenuBarItem *menuItem6 = [[UIMenuBarItem alloc] initWithTitle:@"好友分享" target:self image:[UIImage imageNamed:nil] action:@selector(clickAction:)tag:6];
    
    
    NSMutableArray *items =
    //[NSMutableArray arrayWithObjects:menuItem1, menuItem2, menuItem3,nil];
    //[NSMutableArray arrayWithObjects:menuItem1, menuItem2, menuItem3,  menuItem4, menuItem5, menuItem6, nil];
    [NSMutableArray arrayWithObjects:menuItem1, menuItem2, menuItem3, menuItem4, menuItem5,menuItem6 ,nil];
    
    _menuBar = [[UIMenuBar alloc] initWithFrame:CGRectMake(0, 0, 320, 80.0f) items:items];
//    _menuBar.delegate = self;

    _menuBar.items = [NSMutableArray arrayWithObjects:menuItem1, menuItem2, menuItem3, menuItem4, menuItem5,menuItem6 ,nil];
    [_menuBar show];
}

- (void)clickAction:(UIMenuBarItem *)sender
{
    [_menuBar dismiss];
}





@end
