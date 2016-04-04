//
//  MMiaErrorTipView.h

//
//  Created by yhx on 14-4-11.
//  Copyright (c) 2014年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMiaErrorTipView;
@protocol MMiaErrorTipViewDelegate <NSObject>

@optional
- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender;

@end

@interface MMiaErrorTipView : UIView

+ (void)showErrorTipForErroe:(NSError *)error;
+ (id)showErrorTipForView:(UIView *)view
                   center:(CGPoint)centerPoint
                    error:(NSError *)error
                 delegate:(id)delegate;
+ (void)hideErrorTipForView:(UIView *)view;

@end
