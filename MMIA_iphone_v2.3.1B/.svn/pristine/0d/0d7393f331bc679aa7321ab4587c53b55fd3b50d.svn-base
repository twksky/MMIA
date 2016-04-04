//
//  MMiaAdboardView.m
//  MMIA
//
//  Created by MMIA-Mac on 14-7-3.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaAdboardView.h"
#import "MagezineItem.h"
#import "UIImageView+WebCache.h"

#define AD_SCROLL_RunloopTime 5.0

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
        // test
        _scrollView.backgroundColor = [UIColor clearColor];
        
        UIImageView* defaultImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.bounds.size.height)];
        defaultImage.tag = 7;
        defaultImage.contentMode = UIViewContentModeScaleAspectFill;
        defaultImage.clipsToBounds = YES;
        defaultImage.image = [UIImage imageNamed:@"banner_icon.jpg"];
 
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - 80) / 2, CGRectGetMaxY(self.frame) - 25, 80, 19)];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.alpha = 0.8;
        
        [self addSubview:defaultImage];
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
        
        _pictureArr = [[NSArray alloc] init];
    }
    return self;
}

- (void)setBannerPictureArr:(NSArray *)bannerArr
{
    if( ![self.pictureArr isEqualToArray:bannerArr] )
    {
        if( bannerArr.count <= 0 )
            return;
        
        if( [self viewWithTag:7] )
        {
            [[self viewWithTag:7] removeFromSuperview];
        }
        // 关闭定时器
        [self stopTimer];
        _pageControl.currentPage = 0;

        self.pictureArr = bannerArr;
        for( int i = 0; i < self.pictureArr.count + 2; i++ )
        {
            UIImageView* imageView =[[UIImageView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, self.bounds.size.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            if( i == 0 )
            {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[_pictureArr objectAtIndex:_pictureArr.count-1]] placeholderImage:[UIImage imageNamed:@"banner_icon.jpg"]];
            }
            else if( i == _pictureArr.count + 1 )
            {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[_pictureArr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"banner_icon.jpg"]];
            }
            else
            {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[_pictureArr objectAtIndex:i-1]] placeholderImage:[UIImage imageNamed:@"banner_icon.jpg"]];
            }
            
            [_scrollView addSubview:imageView];
        }
        
        _pageControl.numberOfPages = self.pictureArr.count;
        [_scrollView setContentSize:CGSizeMake(320 * (_pictureArr.count+2), self.bounds.size.height)];
        [_scrollView setContentOffset:CGPointMake(320, 0)];
        
        // 开启定时器
        [self startTimer];
    }
}

- (void)startTimer
{
    if( !_myTimer )
    {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:AD_SCROLL_RunloopTime target:self selector:@selector(playForAd) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    if( _myTimer )
    {
        [_myTimer invalidate];
        _myTimer = nil;
    }
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
    if( _pageControl.numberOfPages <= 0 )
        return;
    
    if ( [self.delegate respondsToSelector:@selector(MMiaAdboardViewTap:)] )
    {
        [_delegate MMiaAdboardViewTap:_pageControl.currentPage];
    }
}

#pragma mark - UIScrollViewDelegate

// 结束拖拽
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self stopTimer];
}

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
    
    [self startTimer];
}

- (void)dealloc
{
    [self stopTimer];
}

@end
