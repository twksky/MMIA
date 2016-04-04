//
//  MMiaAdboardView.h
//  MMIA
//
//  Created by MMIA-Mac on 14-7-3.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

// 首页广告位

@interface MMiaAdboardView : UIView <UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
    UIPageControl* _pageControl;
    NSMutableArray* _pictureArr;
    NSInteger _currentNum;
}

- (void)setAdboardViewForImage;

@end
