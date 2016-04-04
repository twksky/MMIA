//
//  MmiaSampleViewController.m
//  MMIA
//
//  Created by lixiao on 15/6/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaSampleViewController.h"

@interface MmiaSampleViewController ()

@end

@implementation MmiaSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationView = [[UIView alloc]init];
    self.navigationView.backgroundColor = ColorWithHexRGBA(0xffffff, 0.1);
    [self.view addSubview:self.navigationView];
    
    self.statusView = [[UIView alloc]init];
    self.statusView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:self.statusView];
    
    self.naviBarView = [[UIView alloc]init];
    self.naviBarView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:self.naviBarView];
    
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = ColorWithHexRGBA(0x999999, 1);
    [self.naviBarView addSubview:self.lineLabel];
    
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(VIEW_OFFSET + kNavigationBarHeight));
    }];
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.navigationView);
        make.height.equalTo(@(VIEW_OFFSET));
    }];
    
    [self.naviBarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.statusView.mas_bottom);
        make.left.right.equalTo(self.navigationView);
        make.height.equalTo(@(kNavigationBarHeight));
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.navigationView);
        make.height.equalTo(@0.5f);
    }];

}

- (void)addBackBtnWithTarget:(id)target selector:(SEL)selector
{
    UIButton *backButton = [[UIButton alloc]init];
    backButton.tag = 1001;
    UIImage *backImage = [UIImage imageNamed:@"detail_back.png"];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.naviBarView addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.equalTo(self.naviBarView);
        make.size.mas_equalTo(CGSizeMake(50, kNavigationBarHeight));
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
