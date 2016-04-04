//
//  MmiaAdboardView.h
//  MMIA
//
//  Created by MMIA-Mac on 15-5-27.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MmiaAdboardView : UIView

@property (nonatomic, readonly) UIScrollView*  scrollView;
@property (nonatomic, assign  ) NSInteger      totalPageCount;

@property (nonatomic, strong) NSTimer*       animationTimer;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, getter=isHiddenPageControl) BOOL hiddenPageControl;
@property (nonatomic, copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
@property (nonatomic, copy) void (^reflectedViewAtIndex)(NSInteger pageIndex);
@property (nonatomic, copy) void (^TapActionBlock)(NSInteger pageIndex);

- (void)startTimer;
- (void)stopTimer;

@end
