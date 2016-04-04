//
//  MyCustomTabBarMainVIew.h
//  MMIA
//
//  Created by lixiao on 14-9-25.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCustomTabBarMainVIew;
@protocol MyCustomTabBarMainVIewDelegate <NSObject>

-(void)tapCenterButtonImageView:(UIImageView *)imageView inView:(MyCustomTabBarMainVIew *)view;

@end

@interface MyCustomTabBarMainVIew : UIView
@property (nonatomic, strong) UIWindow* alertWindow1;
@property(nonatomic,assign)id <MyCustomTabBarMainVIewDelegate>delegate;
- (id)initWithLoseScopeHeight:(CGFloat)height;
- (void)show;
- (void)dismissTabBarMainView;
- (void)closeWindow;
@end
