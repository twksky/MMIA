//
//  MmiaDetailSearchViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/20.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaDetailSearchViewController.h"

@interface MmiaDetailSearchViewController ()

@end

@implementation MmiaDetailSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     // Do any additional setup after loading the view.
    [self.view bringSubviewToFront:self.navigationView];
    //self.navigationView.backgroundColor = UIColorClear;
    self.topDataArray = @[@"photo1.jpg", @"photo2.jpg", @"photo3.jpg"];
    self.contentLabel.text = @"福特野马GT500";
    self.subContentLabel.text = @"福特的工程师在野马的4.6升v8发动机上加入BULLITT车型的元素";
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.layer.borderColor = UIColorWhite.CGColor;
    bgView.layer.borderWidth = 1.0f;
    [self.naviBarView addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackClick:)];
    [bgView addGestureRecognizer:tap];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.naviBarView);
        make.height.equalTo(@30);
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"搜索你喜欢得商品/商家";
    [self.navigationView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.bottom.equalTo(bgView);
    }];

    UIImageView *searchImageView = [[UIImageView alloc]init];
    searchImageView.backgroundColor = [UIColor redColor];
    [self.naviBarView addSubview:searchImageView];
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.right.equalTo(bgView);
        make.width.height.equalTo(bgView.mas_height);
    }];
    [label mas_updateConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(searchImageView.mas_left);
    }];
}

- (void)tapBackClick:(UITapGestureRecognizer *)tap
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
