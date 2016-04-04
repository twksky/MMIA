//
//  MmiaAdboardView.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-3-20.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaAdboardView.h"
#import "GlobalDef.h"
#import "AdditionHeader.h"
#import "UIImageView+WebCache.h"
#import "DMPagingScrollView.h"

#define AD_SCROLL_RunloopTime 5.0

@interface MmiaAdboardView () <UIScrollViewDelegate>
{
    NSTimer* _myTimer;
}

@property (nonatomic, strong) DMPagingScrollView* scrollView;
@property (nonatomic, strong) UIPageControl*  pageControl;
@property (nonatomic, strong) NSMutableArray* contentViews;

@end

@implementation MmiaAdboardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _alphaOfobjs = 1.0;
        
        _imageArray = [[NSMutableArray alloc] init];
        _contentViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(self.width - 100, self.height - 25, 80, 19);
    
    CGFloat x = 0.;
    for( UIImageView* imageView in self.contentViews )
    {
        imageView.left = x + (self.width - self.itemSize.width)/2;
        x += self.itemSize.width;
    }
}

- (DMPagingScrollView *)scrollView
{
    if( !_scrollView )
    {
        _scrollView = [[DMPagingScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = ColorWithHexRGB(0xfbfbfb);
        _scrollView.pageWidth = MainPage_Banner_Image_Width;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if( !_pageControl )
    {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.width - 100, self.height - 25, 80, 19)];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.alpha = 0.8;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

#pragma mark - 私有函数

- (void)initInfiniteScrollView
{
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self startTimer];
    
    NSInteger imageCount = self.imageArray.count;
    if( imageCount > 0 )
    {
        [self setScrollViewContentDataSource];
        
        self.scrollView.contentSize = CGSizeMake(imageCount * 5 * self.itemSize.width, self.height);
        
        CGFloat viewMiddle = imageCount * 2 * self.itemSize.width;
        [self.scrollView setContentOffset:CGPointMake(viewMiddle, 0)];
        
        [self reloadView:viewMiddle + (self.width - _itemSize.width)/2];
    }
    
    self.pageControl.numberOfPages = imageCount;
    [_myTimer resumeTimerAfterTimeInterval:AD_SCROLL_RunloopTime];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    if( _itemSize.width == 0 && _itemSize.height == 0 )
    {
        _itemSize = CGSizeMake(MainPage_Banner_Image_Width, MainPage_Banner_Image_Hight);
    }
    
    NSAssert((_itemSize.height <= self.height), @"item's height must not bigger than scrollpicker's height");
    
    for( NSInteger i = 0; i < (self.imageArray.count * 5); ++i )
    {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _itemSize.width + (self.width - _itemSize.width)/2, self.height - _itemSize.height, _itemSize.width, _itemSize.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = ColorWithHexRGB(0xfbfbfb).CGColor;
        imageView.layer.borderWidth = 1;
        imageView.tag = i;
        [imageView sd_setImageWithURL:NSURLWithString(self.imageArray[i % self.imageArray.count]) placeholderImage:UIImageNamed(@"banner_icon.jpg")];
        
        // 添加遮罩层
        CALayer* subLayer = [CALayer layer];
        subLayer.frame = imageView.bounds;
        subLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        subLayer.masksToBounds = YES;
        [imageView.layer addSublayer:subLayer];
        
        // 添加点击事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [imageView addGestureRecognizer:tapGesture];
        imageView.userInteractionEnabled = YES;
        
        [self.contentViews addObject:imageView];
        [self.scrollView addSubview:imageView];
    }
}

- (void)reloadView:(CGFloat)offset
{
    UIImageView* biggestView;
    NSInteger currentPageIndex = 0;
    
    for( NSInteger i = 0; i < self.contentViews.count; ++i )
    {
        UIImageView* imageView = self.contentViews[i];
        if( imageView.centerX >= offset && imageView.centerX <= (offset + self.itemSize.width) )
        {
            biggestView = imageView;
            currentPageIndex = i % self.imageArray.count;
        }
        
        // 改变imageView透明度
//        imageView.alpha = self.alphaOfobjs;
        CALayer* subLayer = [imageView.layer.sublayers lastObject];
        if( !subLayer )
        {
            subLayer = [CALayer layer];
            subLayer.frame = imageView.bounds;
            subLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            subLayer.masksToBounds = YES;
            [imageView.layer addSublayer:subLayer];
            
            CATransition* transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = 0.5;
            [imageView.layer addAnimation:transition forKey:@"image"];
        }
    }
    
    [[biggestView.layer.sublayers lastObject] removeFromSuperlayer];
    CATransition* curTransition = [CATransition animation];
    curTransition.type = kCATransitionFade;
    curTransition.duration = 0.5;
    [biggestView.layer addAnimation:curTransition forKey:@"curImage"];
//    [biggestView setAlpha:1.0];
    self.pageControl.currentPage = currentPageIndex;
}

- (void)snapToAnEmotion
{
    CGFloat offsetX = self.scrollView.contentOffset.x;
    if( offsetX > 0 )
    {
        CGFloat sectionSize = self.imageArray.count * self.itemSize.width;
        
        if( offsetX <= (sectionSize - sectionSize/2) )
        {
            offsetX = sectionSize * 2 - sectionSize/2;
        }
        else if( offsetX >= (sectionSize * 3 + sectionSize/2) )
        {
            offsetX = sectionSize * 2 + sectionSize/2;
        }
        
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0)];
        [self reloadView:offsetX];
    }
}

- (void)startTimer
{
    if( !_myTimer )
    {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:AD_SCROLL_RunloopTime target:self selector:@selector(playForAd:) userInfo:nil repeats:YES];
        
        [_myTimer pauseTimer];
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

#pragma mark - setter方法

- (void)setImageArray:(NSArray *)imageArray
{
    if( ![_imageArray isEqualToArray:imageArray] )
    {
        _imageArray = imageArray;
        
        [self initInfiniteScrollView];
    }
}

- (void)setItemSize:(CGSize)itemSize
{
    if( !CGSizeEqualToSize(_itemSize, itemSize) )
    {
        _itemSize = itemSize;
        
        [self initInfiniteScrollView];
    }
}

#pragma mark - 响应事件

- (void)playForAd:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + self.itemSize.width, self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if( self.TapActionBlock )
    {
        NSInteger index = tap.view.tag % self.imageArray.count;
        self.TapActionBlock(index);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_myTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if( decelerate == 0 && !self.scrollView.snapping )
    {
        [self snapToAnEmotion];
    }
    [_myTimer resumeTimerAfterTimeInterval:AD_SCROLL_RunloopTime];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if( !self.scrollView.snapping )
    {
        [self snapToAnEmotion];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if( !self.scrollView.snapping )
    {
        [self snapToAnEmotion];
    }
}

- (void)dealloc
{
    [self stopTimer];
}

@end
