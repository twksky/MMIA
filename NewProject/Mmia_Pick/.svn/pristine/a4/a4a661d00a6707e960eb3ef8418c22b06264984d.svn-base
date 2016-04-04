//
//  UIMenuBar.h
//  TesdXcodeUserGuideDemo
//
//  Created by twk on 15-5-19.
//  Copyright (c) 2015年 tanwenkai. All rights reserved.
//

// UITabBar
// UIToolbar
// UINavigationBar

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIMenuBarItem.h"

//@class UIMenuBar;
//
//@protocol UIMenuBarDelegate <NSObject>
//@optional
//- (void)menuBar:(UIMenuBar *)menuBar didSelectAtIndex:(int)index;
//
//@end

@interface UIMenuBar : UIView <UIScrollViewDelegate>//,UIAppearance>
{
@private
    NSMutableArray        *_items;
    UIColor               *_tintColor;
    
    NSInteger              _pages;
    UIScrollView          *_containerView;
    UIPageControl         *_pageControl;
    NSMutableArray        *_containerScrollViews;
    CGSize                 _originalSize;
    CGSize                 _halfOriginalSize;
}

@property (nonatomic, copy)   NSMutableArray       *items;
@property (nonatomic, retain) UIColor              *tintColor;    // Default is black.
@property ( nonatomic , strong ) id target;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)setItems:(NSMutableArray *)items;
- (void)show;
- (void)dismiss;
-(void)initWithTarget:(id)target;

@end
