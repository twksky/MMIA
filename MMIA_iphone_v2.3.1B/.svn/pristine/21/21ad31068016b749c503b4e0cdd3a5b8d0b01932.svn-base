//
//  MMiaPopListView.h
//  SplitTwoViewController
//
//  Created by MMIA-Mac on 15-1-14.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 一个带有动画的弹出列表视图
 */

@class MMiaPopListView;
@protocol MMiaPopListViewDelegate <NSObject>

- (void)popListView:(MMiaPopListView *)popListView didSelectedIndex:(NSInteger)aIndex;
- (void)popListViewDidCancel;

@end

@interface MMiaPopListView : UIView

@property (nonatomic, weak) id <MMiaPopListViewDelegate> delegate;

- (id)initWithTitle:(NSString *)title dataArray:(NSArray *)listArray isRound:(BOOL)round;
- (void)showInSuperView:(UIView *)superView animated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated;

@end
