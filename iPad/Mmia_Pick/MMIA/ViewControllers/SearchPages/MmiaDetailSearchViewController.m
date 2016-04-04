//
//  MmiaDetailSearchViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/20.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaDetailSearchViewController.h"
#import "MmiaBaseViewController.h"

@interface MmiaDetailSearchViewController ()

@end

@implementation MmiaDetailSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     // Do any additional setup after loading the view.
    //修改继承关系后，删掉
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.topDataArray = @[@"photo1.jpg", @"photo2.jpg", @"photo3.jpg"];
    UITextField *searchTextFiled = [[UITextField alloc]init];
    searchTextFiled.backgroundColor = [UIColor clearColor];
    searchTextFiled.delegate = self;
    UIColor *placeHoderColor = ColorWithHexRGB(0x969696);
    searchTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"搜索你喜欢得商品/商家" attributes:@{NSForegroundColorAttributeName:placeHoderColor}];
    searchTextFiled.layer.cornerRadius = 0.5f;
    searchTextFiled.layer.masksToBounds = YES;
    searchTextFiled.layer.borderWidth = 1.0;
    searchTextFiled.layer.borderColor = UIColorWhite.CGColor;
    [self.naviBarView addSubview:searchTextFiled];
    [searchTextFiled mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.naviBarView);
        make.height.equalTo(@30);
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
