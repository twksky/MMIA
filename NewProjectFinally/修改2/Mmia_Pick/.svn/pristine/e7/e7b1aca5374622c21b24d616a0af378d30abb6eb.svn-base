//
//  MmiaTabBarViewController.m
//  MMIA
//
//  Created by lixiao on 15/6/27.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaTabBarViewController.h"
#import "MmiaMainViewController.h"
#import "MmiaSearchViewController.h"
#import "MmiaCategoryViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaMainViewLayout.h"
#import "GlobalConfig.h"

@interface MmiaTabBarViewController ()

@end

@implementation MmiaTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _btnArr = [[NSMutableArray alloc]init];
    
    _tabBarBg = [[UIImageView alloc]init];
    _tabBarBg.userInteractionEnabled = YES;
    _tabBarBg.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_tabBarBg];
    
    [_tabBarBg mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
        
    }];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = ColorWithHexRGB(0xb81c1c);
    [_tabBarBg addSubview:lineLabel];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.equalTo(_tabBarBg);
        make.height.equalTo(@0.5);
    }];
    
    NSArray *imageArr = [NSArray arrayWithObjects:@"main.png",@"search.png", @"category.png", nil];
    NSArray *selectImageArr = [NSArray arrayWithObjects:@"main_select.png",@"search_select.png",@"category_select.png", nil];
    CGFloat buttonWidth = (App_Frame_Width - 10)/imageArr.count;
    
    UIButton *lastButton = nil;
    for (int i = 0; i < imageArr.count; i++)
    {
        UIButton *subButton = [UIButton new];
        subButton.tag = i;
        [subButton setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]] forState:UIControlStateNormal];
        [subButton setImage:[UIImage imageNamed:[selectImageArr objectAtIndex:i]] forState:UIControlStateSelected];
        [subButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
         [subButton setShowsTouchWhenHighlighted:YES];
        [_tabBarBg addSubview:subButton];
        
        [subButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(lastButton ? lastButton.mas_right : @5).offset(0);
            make.bottom.height.equalTo(_tabBarBg);
            make.width.equalTo(@(buttonWidth));
            
        }];
        
        if (i == 0)
        {
            [subButton setSelected:YES];
        }
        [_btnArr addObject:subButton];
        lastButton = subButton;
    }
    
    //首页
    MmiaMainViewLayout* mainLayout = [[MmiaMainViewLayout alloc] init];
    mainLayout.sectionInset = UIEdgeInsetsMake(KHomeCollectionViewMargin, KHomeCollectionViewMargin, KHomeCollectionViewMargin, KHomeCollectionViewMargin);
    mainLayout.minimumLineSpacing = KHomeCollectionViewCell_Spacing;
    mainLayout.minimumInteritemSpacing = KHomeCollectionViewCell_Spacing;
    MmiaMainViewController* homePageController = [[MmiaMainViewController alloc] initWithCollectionViewLayout:mainLayout];
    UINavigationController *nav1 = [GlobalConfig createNavWithRootVC:homePageController];
    
    //搜索
    CHTCollectionViewWaterfallLayout *searchLayout = [[CHTCollectionViewWaterfallLayout alloc]init];
    searchLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    searchLayout.minimumInteritemSpacing = 0;
    searchLayout.columnCount = 1;
    MmiaSearchViewController *searchViewController = [[MmiaSearchViewController alloc]initWithCollectionViewLayout:searchLayout];
    UINavigationController *nav2 = [GlobalConfig createNavWithRootVC:searchViewController];

    //类目
    CHTCollectionViewWaterfallLayout* waterLayout = [[CHTCollectionViewWaterfallLayout alloc]init];
    waterLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    waterLayout.columnCount = 3;
    waterLayout.minimumColumnSpacing = 30;
    waterLayout.minimumInteritemSpacing = 20;
    MmiaCategoryViewController *categoryViewController = [[MmiaCategoryViewController alloc]initWithCollectionViewLayout:waterLayout];
    UINavigationController *nav3 = [GlobalConfig createNavWithRootVC:categoryViewController];
    
    [self setViewControllers:[NSArray arrayWithObjects:nav1,nav2, nav3, nil]];
    [self hideTabBar];
}

- (void)buttonTapped:(UIButton *)button
{
    for (UIButton *btn in _btnArr)
    {
        [btn setSelected:NO];
    }
    [button setSelected:YES];
    [self setSelectedIndex:button.tag];
}

- (void)hideTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
        }
        else if ([view isKindOfClass:NSClassFromString(@"UITransitionView")])
        {
            view.frame = self.view.bounds;
        }
    }
}

- (void)hideOrNotTabBar:(BOOL)hidden
{
    _tabBarBg.hidden = hidden;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
