//
//  MMiaErrorTipView.h

//
//  Created by WuZixun on 14-4-11.
//  Copyright (c) 2014年 WuZixun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMiaErrorTipViewDelegate <NSObject>
@optional
-(void) onErrorTipViewRefreshBtnClicked:(UIButton* )sender;
@end

@interface MMiaErrorTipView : UIView

- (void)setErrorTipText:(NSString *)text;
- (void)setDelegate:(id<MMiaErrorTipViewDelegate>)delegate;
- (void)showRefreshButton:(BOOL)bShow;
@end
