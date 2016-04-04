//
//  MmiaAdboardView.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-27.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaAdboardView.h"
#import "NSTimer+Addition.h"
#import "UIView+Additions.h"
#import "MPageControl.h"

@interface MmiaAdboardView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView*   scrollView;
@property (nonatomic, strong) MPageControl*   pageControl;
@property (nonatomic, strong) NSMutableArray* contentViews;
@property (nonatomic, assign) NSInteger       currentPageIndex;

@property (nonatomic, strong) NSTimer*       animationTimer;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@end

@implementation MmiaAdboardView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        self.autoresizesSubviews = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentMode = UIViewContentModeCenter;
        [self addSubview:_scrollView];
        
        _pageControl = MPageControl.new;
        _pageControl.numberOfPages = 4;
        _pageControl.indicatorMargin = (self.width - 4 * 76) / 5;//2.0f;
        _pageControl.indicatorDiameter = 0.0f;
        [_pageControl setPageIndicatorImage:UIImageNamed(@"轮播横线_icon")];
        [_pageControl setCurrentPageIndicatorImage:UIImageNamed(@"轮播横线_sel_icon.png")];
        [self addSubview:_pageControl];
        
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-1);
            make.height.equalTo(@2);
        }];
        
        _animationDuration = 5.0f;
        _currentPageIndex = 0;
        _pageControl.currentPage = 0;
    }
    return self;
}

- (NSTimer *)animationTimer
{
    if( !_animationTimer )
    {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:_animationDuration
                                                           target:self
                                                         selector:@selector(animationTimerDidFired:)
                                                         userInfo:nil
                                                          repeats:YES];
        [_animationTimer pauseTimer];
    }
    return _animationTimer;
}

- (void)setTotalPageCount:(NSInteger)totalPageCount
{
    _totalPageCount = totalPageCount;
    
    if( _totalPageCount > 0 )
    {
        _scrollView.contentSize = CGSizeMake(3 * _scrollView.width, _scrollView.height);
        
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

#pragma mark - 私有函数

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    
    for( UIView* contentView in self.contentViews )
    {
        contentView.userInteractionEnabled = YES;
        contentView.contentMode = UIViewContentModeScaleAspectFill;
        contentView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        
        CGRect rightRect = self.scrollView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.bounds) * (counter ++), 0);
        contentView.frame = rightRect;
        
        [self.scrollView addSubview:contentView];
    }
    self.pageControl.currentPage = self.currentPageIndex;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0)];
}

- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if ( !self.contentViews )
    {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if( self.fetchContentViewAtIndex )
    {
        // 只有一张图片时copy数据到不同UIImageView*中
        if( self.currentPageIndex == previousPageIndex && self.currentPageIndex == rearPageIndex )
        {
            UIImageView* preView = [[UIImageView alloc] init];
            preView.image = ((UIImageView *)self.fetchContentViewAtIndex(previousPageIndex)).image;
            [self.contentViews addObject:preView];
            
            UIImageView* curView = [[UIImageView alloc] init];
            curView.image = ((UIImageView *)self.fetchContentViewAtIndex(_currentPageIndex)).image;
            [self.contentViews addObject:curView];
            
            UIImageView* rearView = [[UIImageView alloc] init];
            rearView.image = ((UIImageView *)self.fetchContentViewAtIndex(rearPageIndex)).image;
            [self.contentViews addObject:rearView];
        }
        else
        {
            [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
            [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
            [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
        }
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if( currentPageIndex == -1 )
    {
        return self.totalPageCount - 1;
    }
    else if( currentPageIndex == self.totalPageCount )
    {
        return 0;
    }
    else
    {
        return currentPageIndex;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    if( contentOffsetX >= (2 * scrollView.width) ) //640
    {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
//        NSLog(@"next，当前页:%ld",self.currentPageIndex);
        
        [self configContentViews];
    }
    if( contentOffsetX <= 0 )
    {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
//        NSLog(@"previous，当前页:%ld",self.currentPageIndex);
        
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(scrollView.width, 0) animated:YES];
}

#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + self.scrollView.width, self.scrollView.contentOffset.y);
    
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock)
    {
        self.TapActionBlock(self.currentPageIndex);
    }
}

@end
