//
//  BaseViewController.h
//  MMIA
//
//  Created by zixun on 6/10/14.
//  Copyright (c) 2014 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MMiaBaseViewController : UIViewController
//{
//    UILabel* titleLbl;
//}

@property (nonatomic,retain) UIButton *leftBarButton;
@property (nonatomic,retain) UIButton *rightBarButton;
@property (nonatomic,retain) UIImageView *navigationImageView;

// yhx
@property (nonatomic,retain) UIView*  navigationView;
@property (nonatomic,retain) UILabel* titleLabel;


- (void)initNavigationView;
- (void)setTitleString:(NSString*)title;
- (void)addBackBtnWithTarget:(id)target selector:(SEL)selector;
- (void)addRightBtnWithTarget:(id)target selector:(SEL)selector;
- (void)removeBackBtn;
- (void)removeRightkBtn;
- (void)hideNavigationBar;
- (void)hideToolBarView;

//lx change
-(void)initNewNavigationView;
-(void)addNewBackBtnWithTarget:(id)target selector:(SEL)selector;
-(void)addNewRightBtnWithImage:(UIImage *)rigthImage Target:(id)target selector:(SEL)selector;
//设置navigationBar颜色
-(void)setNaviBarViewBackgroundColor:(UIColor *)backColor;
@end
