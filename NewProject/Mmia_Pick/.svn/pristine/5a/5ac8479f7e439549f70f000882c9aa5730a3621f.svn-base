//
//  MmiaBaseViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/18.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaBaseViewController.h"

@interface MmiaBaseViewController ()
@end

@implementation MmiaBaseViewController

- (UILabel *)rightLabel
{
    if (!_rightLabel)
    {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.backgroundColor = [UIColor clearColor];
        [_rightLabel setShadowColor:[UIColor blackColor]];
        [_rightLabel setShadowOffset:CGSizeMake(0.0f, 0.5f)];
        _rightLabel.textColor = ColorWithHexRGB(0xffffff);
        _rightLabel.textAlignment = MMIATextAlignmentRight;
        _rightLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.naviBarView addSubview:_rightLabel];
        
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.naviBarView);
            make.right.equalTo(self.naviBarView).offset(-10);
            make.left.equalTo(self.naviBarView).offset(100);
            make.height.equalTo(self.naviBarView);
        }];
    }
    return _rightLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ColorWithHexRGB(0xeeeeee);
    
    self.navigationView = [[UIView alloc]init];
    self.navigationView.backgroundColor = ColorWithHexRGBA(0xffffff, 0.1);
    [self.view insertSubview:self.navigationView aboveSubview:self.collectionView];

    self.statusView = [[UIView alloc]init];
    self.statusView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:self.statusView];
    
    self.naviBarView = [[UIView alloc]init];
    self.naviBarView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:self.naviBarView];
    
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = ColorWithHexRGBA(0xffffff, 0.3);
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
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
     [self.naviBarView addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.equalTo(self.naviBarView);
        make.size.mas_equalTo(CGSizeMake(50, kNavigationBarHeight));
    }];
}

- (void)addRightBtnWithImage:(UIImage *)rightImage Target:(id)target selector:(SEL)selector
{
    UIButton *rightButton = [[UIButton alloc]init];
    rightButton.tag = 1002;
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.naviBarView addSubview:rightButton];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(@-10);
        make.top.equalTo(@0);
         make.size.mas_equalTo(CGSizeMake(50, kNavigationBarHeight));
    }];
}

- (void)addRightLabelWithText:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:20];
    label.text = text;
    [self.naviBarView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(@-10);
        make.top.equalTo(@0);
        make.bottom.equalTo(@10);
        make.size.mas_lessThanOrEqualTo(CGSizeMake(120, kNavigationBarHeight));
    }];

}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
