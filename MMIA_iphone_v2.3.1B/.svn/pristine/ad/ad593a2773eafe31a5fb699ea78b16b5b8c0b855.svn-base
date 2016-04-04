//
//  MMiaPagesContainer.h
//  MMIA
//
//  Created by MMIA-Mac on 14-8-12.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMiaAdboardView.h"
#import "MMiaFullPageController.h"
#import "MMiaClothesPageController.h"
#import "MMiaFoodPageController.h"
#import "MMiaLivePageController.h"
#import "MMiaTravelPageController.h"
#import "MMiaPagesContainerTopBar.h"
//lx add
typedef void (^SelcetViewControllersBlock) (int index);
typedef void (^DragViewControllerBlock) ();

@class MMiaPagesContainer;

@interface MMiaPagesContainer : UIViewController

@property (strong, nonatomic) NSArray*   viewControllers;
@property (assign, nonatomic) NSUInteger selectedIndex;
@property (assign, nonatomic) NSUInteger topBarHeight;
@property (strong, nonatomic) UIImage*   topBarBackgroundImage;
@property (strong, nonatomic) UIColor*   topBarBackgroundColor;
@property (strong, nonatomic) UIFont*    topBarItemLabelsFont;
@property (strong, nonatomic) UIColor*   pageItemsTitleColor;
@property (strong, nonatomic) UIColor*   selectedPageItemTitleColor;
@property (strong, nonatomic) UIImage*   selectedPageItemImage;
@property (strong, nonatomic) UIView*    headerImageView;      // 顶部轮播图
//lx change
@property (strong, nonatomic) MMiaPagesContainerTopBar* topBar;
@property (strong, nonatomic) UIView* headerView;               // 顶部轮播图和标签的superView
//lx add
////个人中心选中小箭头
@property (strong, nonatomic) UIView *pageIndicatorView;
@property (strong, nonatomic) UIImage *pageIndicatorImage;
@property (assign, nonatomic) CGSize pageIndicatorViewSize;
//选中vc
@property (copy, nonatomic) SelcetViewControllersBlock selcectBlock;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;
- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation;
- (void)refreshAdboardData:(NSArray *)dataArr;

@end
