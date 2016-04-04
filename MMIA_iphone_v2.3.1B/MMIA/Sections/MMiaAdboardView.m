//
//  MMiaAdboardView.m
//  MMIA
//
//  Created by MMIA-Mac on 14-7-3.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaAdboardView.h"

#define AD_SCROLL_RunloopTime 3.0

@implementation MMiaAdboardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
 
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.origin.x + 120, self.bounds.origin.y + 80, 80, 19)];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.alpha = 0.8;
        
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
        
        _pictureArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setAdboardViewForImage
{
    // 添加image, 需要从网络获取
    for( int i = 0; i < 4; i++ )
    {
        NSString* picStr = [NSString stringWithFormat:@"cat%d.jpg", i + 1];
        [_pictureArr addObject:picStr];
    }
    
    for( int i = 0; i < _pictureArr.count + 2; i++ )
    {
        UIImageView* imageView =[[UIImageView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, self.bounds.size.height)];
        if( i == 0 )
        {
            imageView.image = [UIImage imageNamed:[_pictureArr objectAtIndex:_pictureArr.count-1]];
        }
        else if( i == _pictureArr.count + 1 )
        {
            imageView.image = [UIImage imageNamed:[_pictureArr objectAtIndex:0]];
        }
        else
        {
            imageView.image = [UIImage imageNamed:[_pictureArr objectAtIndex:i-1]];
        }

        [_scrollView addSubview:imageView];
    }

    _pageControl.numberOfPages = _pictureArr.count;
    [_scrollView setContentSize:CGSizeMake(320 * (_pictureArr.count+2), self.bounds.size.height)];
    [_scrollView setContentOffset:CGPointMake(320, 0)];
    
    [NSTimer scheduledTimerWithTimeInterval:AD_SCROLL_RunloopTime target:self selector:@selector(playForAd) userInfo:nil repeats:YES];
}

- (void)playForAd
{
    _currentNum = (NSInteger)_scrollView.contentOffset.x / self.frame.size.width;
    
    if( _currentNum == _pictureArr.count + 1 )
    {
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, _scrollView.contentOffset.y);
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x + _scrollView.frame.size.width, _scrollView.contentOffset.y);
    
    [UIView commitAnimations];
    
    _currentNum = (NSInteger)_scrollView.contentOffset.x / _scrollView.frame.size.width;
    if( _currentNum == _pictureArr.count + 1 )
    {
        _pageControl.currentPage = 0;
    }
    else
    {
        _pageControl.currentPage = _currentNum - 1;
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    // TODO:跳转到广告页面
    [self performSelector:@selector(gotoAdWebView) withObject:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentNum = (NSInteger)scrollView.contentOffset.x / scrollView.frame.size.width;
    if( _currentNum == 0 )
    {
        scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - 2 * scrollView.bounds.size.width, scrollView.contentOffset.y);
    }
    if( _currentNum == scrollView.contentSize.width / scrollView.bounds.size.width - 1 )
    {
        [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, scrollView.contentOffset.y)];
    }
    _currentNum = (NSInteger)scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = _currentNum - 1;
}

@end
