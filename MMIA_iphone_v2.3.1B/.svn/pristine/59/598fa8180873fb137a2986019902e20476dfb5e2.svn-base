//
//  MMiaPagesContainerTopBar.h
//  MMIA
//
//  Created by MMIA-Mac on 14-8-12.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMiaPagesContainerTopBar;

@protocol MMiaPagesContainerTopBarDelegate <NSObject>

- (void)itemAtIndex:(NSUInteger)index didSelectInPagesContainerTopBar:(MMiaPagesContainerTopBar *)bar;

@end

@interface MMiaPagesContainerTopBar : UIView

@property (strong, nonatomic) UIImage* backgroundImage;
@property (strong, nonatomic) UIColor* itemTitleColor;
@property (strong, nonatomic) NSArray* itemTitles;
@property (strong, nonatomic) UIFont*  font;

@property (strong, nonatomic) UIImage*      itemImage;    // 标签背景图
@property (strong, nonatomic) UIImageView*  itemImageView;// 标签背景

@property (readonly, strong, nonatomic) NSArray *itemViews;
@property (readonly, strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) id<MMiaPagesContainerTopBarDelegate> delegate;

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index;
- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index;

@end
