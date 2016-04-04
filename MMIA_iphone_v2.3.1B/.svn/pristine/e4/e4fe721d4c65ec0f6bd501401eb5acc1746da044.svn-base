//
//  MMiaAdboardView.h
//  MMIA
//
//  Created by MMIA-Mac on 14-7-3.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

// 首页广告位

@protocol MMiaAdboardViewDelegate <NSObject>

- (void)MMiaAdboardViewTap:(NSInteger)currentNum;

@end

@interface MMiaAdboardView : UIView <UIScrollViewDelegate>
{
    UIScrollView*  _scrollView;
    UIPageControl* _pageControl;
    NSInteger      _currentNum;
    NSTimer*       _myTimer;
}

@property (nonatomic, strong) NSArray* pictureArr;
@property (nonatomic, weak)   id <MMiaAdboardViewDelegate> delegate;

- (void)setBannerPictureArr:(NSArray *)bannerArr;

@end
