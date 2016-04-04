//
//  MMiaSearchTopBar.h
//  MMIA
//
//  Created by lixiao on 15/1/9.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMiaSearchTopBar;

@protocol MMiaSearchTopBarDelegate <NSObject>

- (void)itemAtIndex:(NSUInteger)index didSelectInPagesContainerTopBar:(MMiaSearchTopBar *)bar;

@end

@interface MMiaSearchTopBar : UIView
@property (nonatomic, retain) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *itemViews;
@property (nonatomic, retain) NSArray *itemTitles;
@property (nonatomic, retain) UIColor *itemTitleColor;
@property (nonatomic, retain) UIFont  *itemTitleFont;
//标志
@property (nonatomic,retain) UIView *indicatorView;


@property (nonatomic, assign) id<MMiaSearchTopBarDelegate> delegate;

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index;
- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index;
@end
