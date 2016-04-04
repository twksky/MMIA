//
//  MMiaPagesContainer.m
//  MMIA
//
//  Created by MMIA-Mac on 14-8-12.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaPagesContainer.h"
#import "MMiaPageIndicatorView.h"

@interface MMiaPagesContainer () <MMiaPagesContainerTopBarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView* scrollView;
@property (weak,   nonatomic) UIScrollView* observingScrollView;
@property (strong, nonatomic) UIButton* topButton;              // 回到顶部按钮

@property (          assign, nonatomic) BOOL shouldObserveContentOffset;
@property (readonly, assign, nonatomic) CGFloat scrollWidth;
@property (readonly, assign, nonatomic) CGFloat scrollHeight;

- (void)addHeaderView;
- (void)layoutSubviews;
- (void)resetHeaderViewSuperview;
- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView;
- (void)stopObservingContentOffset;
- (void)createNotifications;
- (void)destroyNotifications;
- (void)topBtnClicked:(UIButton *)sender;
- (void)layoutTopBtn:(id)object;

@end


@implementation MMiaPagesContainer

- (UIButton *)topButton
{
    if( !_topButton )
    {
        UIImage* image = [UIImage imageNamed:@"backTop.png"];
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.frame = CGRectMake(self.scrollWidth - image.size.width, self.scrollHeight - image.size.height - 10, image.size.width, image.size.height);
        _topButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_topButton setBackgroundImage:image forState:UIControlStateNormal];
        _topButton.backgroundColor = [UIColor clearColor];
        [_topButton addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_topButton];
    }
    return _topButton;
}

- (MMiaPagesContainerTopBar *)topBar
{
    if( !_topBar )
    {
        _topBar = [[MMiaPagesContainerTopBar alloc] initWithFrame:CGRectMake(0., CGRectGetMaxY(self.headerImageView.frame), CGRectGetWidth(self.view.frame), self.topBarHeight)];
        _topBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _topBar.itemTitleColor = self.pageItemsTitleColor;
        _topBar.delegate = self;
        _topBar.backgroundColor = self.topBarBackgroundColor;
        _topBar.itemImage = self.selectedPageItemImage;
    }
    return _topBar;
}

- (UIView *)headerView
{
    if( !_headerView )
    {
        CGFloat headerY = CGRectGetHeight(self.headerImageView.bounds) + self.topBarHeight;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -headerY, CGRectGetWidth(self.view.frame), headerY)];
        _headerView.backgroundColor = [UIColor clearColor];
        
        // 添加顶部轮播图和分类标签信息
        if( self.headerImageView )
        {
            [_headerView addSubview:self.headerImageView];
        }
        [_headerView addSubview:self.topBar];
    }
    return _headerView;
}

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setUp];
    }
    return self;
}

- (void)dealloc
{
    [self stopObservingContentOffset];
    [self destroyNotifications];
}

- (void)setUp
{
    _topBarHeight = 30.;
    _topBarBackgroundColor = [UIColor colorWithRed:0xef/255.0 green:0xef/255.0 blue:0xef/255.0 alpha:1.0];
    _topBarItemLabelsFont = [UIFont systemFontOfSize:13];
    _pageItemsTitleColor = [UIColor colorWithRed:0x5e/255.0 green:0x5e/255.0 blue:0x5d/255.0 alpha:1.0];
    _selectedPageItemTitleColor = [UIColor whiteColor];
    _selectedPageItemImage = [UIImage imageNamed:@"首页_标签_背景.png"];
    //lx add
   // _pageIndicatorViewSize = CGSizeMake(15, 15);
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0xef/255.0 green:0xef/255.0 blue:0xef/255.0 alpha:1.0];
    self.shouldObserveContentOffset = YES;

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // Observing
    [self startObservingContentOffsetForScrollView:self.scrollView];
    [self createNotifications];
}

- (void)viewDidUnload
{
    [self stopObservingContentOffset];
    self.scrollView = nil;
    self.topBar = nil;
    //lx add
    self.pageIndicatorView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutSubviews];
}

#pragma mark - Private

- (void)addHeaderView
{
    [self.headerView removeFromSuperview];

    CGRect frame = self.headerView.frame;
    frame.origin.y = -CGRectGetHeight(frame);
    self.headerView.frame = frame;

    UICollectionView* collectionView = [self.viewControllers[self.selectedIndex] collectionView];
    [collectionView addSubview:self.headerView];
    
    [self layoutTopBtn:collectionView];
}

- (void)resetHeaderViewSuperview
{
    [self.headerView removeFromSuperview];
    
    CGFloat offset = [self.viewControllers[self.selectedIndex] collectionView].contentOffset.y;
    CGRect frame = self.headerView.frame;
    frame.origin.x = 0;
    frame.origin.y = -offset - CGRectGetHeight(frame);
    self.headerView.frame = frame;
   [self.view addSubview:self.headerView];
    //lx change
   // [self.view insertSubview:self.headerView belowSubview:self.pageIndicatorView];
    //////
    // 将StatusBar置为View上层
    if( frame.origin.y != 0 )
    {
        [self.view.superview bringSubviewToFront:[self.view.superview viewWithTag:1000]];
    }
}

- (void)layoutSubviews
{
    CGFloat headerY = CGRectGetHeight(self.headerImageView.bounds) + self.topBarHeight;
    self.headerView.frame = CGRectMake(0, -headerY, CGRectGetWidth(self.view.frame), headerY);
    
    CGFloat x = 0.;
    for (UIViewController *viewController in self.viewControllers)
    {
        viewController.view.frame = CGRectMake(x, 0, CGRectGetWidth(self.scrollView.frame), self.scrollHeight);
        x += CGRectGetWidth(self.scrollView.frame);
    }
    self.scrollView.contentSize = CGSizeMake(x, self.scrollHeight);
    [self.scrollView setContentOffset:CGPointMake(self.selectedIndex * self.scrollWidth, 0.) animated:YES];
    /*
    self.topBar.itemImageView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x, [self pageIndicatorCenterY]);
     */
    //lx change
    if (self.selectedPageItemImage != nil)
    {
        self.topBar.itemImageView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x, [self pageIndicatorCenterY]);
    }else
    {
        self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x, [self newPageIndicatorCenterY]);
    }
    self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:self.selectedIndex];
    self.scrollView.userInteractionEnabled = YES;
    
    self.topButton.frame = CGRectMake(self.scrollWidth - 50, self.scrollHeight - 50 - 10, 50, 50);
}

- (CGFloat)pageIndicatorCenterY
{
    return CGRectGetHeight(self.topBar.bounds) / 2.0;//CGRectGetHeight(self.topBar.bounds) - self.selectedPageItemImage.size.height + self.selectedPageItemImage.size.height / 2.;
}

- (CGFloat)scrollHeight
{
    return CGRectGetHeight(self.view.frame);
}

- (CGFloat)scrollWidth
{
    return CGRectGetWidth(self.scrollView.frame);
}

- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView
{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    self.observingScrollView = scrollView;
}

- (void)stopObservingContentOffset
{
    if (self.observingScrollView)
    {
        [self.observingScrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.observingScrollView = nil;
    }
}

- (void)createNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTopBtn:) name:@"ShowTopButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTopBtn:) name:@"HideTopButton" object:nil];
}

- (void)destroyNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowTopButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HideTopButton" object:nil];
}

- (void)topBtnClicked:(UIButton *)sender
{
    self.topButton.hidden = YES;

    [self.viewControllers[self.selectedIndex] viewBackToOriginalPosition];
}

- (void)layoutTopBtn:(id)object
{
    UICollectionView* collectionView = (UICollectionView *)object;
    if( collectionView.contentOffset.y >= CGRectGetHeight(self.view.frame) )
    {
        if( self.topButton.hidden )
        {
            [UIView animateWithDuration:0. animations:^{
                self.topButton.hidden = NO;
            }];
        }
    }
    else
    {
        if( !self.topButton.hidden )
        {
            [UIView animateWithDuration:0. animations:^{
                self.topButton.hidden = YES;
            }];
        }
    }
}

- (void)showTopBtn:(NSNotification*)notification
{
    if( self.topButton.hidden )
    {
        [UIView animateWithDuration:0. animations:^{
            self.topButton.hidden = NO;
        }];
    }
}

- (void)hideTopBtn:(NSNotification*)notification
{
    if( !self.topButton.hidden )
    {
        [UIView animateWithDuration:0. animations:^{
            self.topButton.hidden = YES;
        }];
    }
}


//lx add 设置图标
-(UIView *)pageIndicatorView
{
    if (!_pageIndicatorView)
    {
        if (self.pageIndicatorImage)
        {
            _pageIndicatorView = [[UIImageView alloc]initWithImage:self.pageIndicatorImage];
        }else
        {
            _pageIndicatorView = [[MMiaPageIndicatorView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.topBar.frame) - self.pageIndicatorViewSize.height, self.pageIndicatorViewSize.width, self.pageIndicatorViewSize.height)];
            [(MMiaPageIndicatorView *)_pageIndicatorView setColor:[UIColor whiteColor]];
        }
        [self.topBar addSubview:self.pageIndicatorView];
    }
    return _pageIndicatorView;
}
//设置个人中心图标的中心
- (CGFloat)newPageIndicatorCenterY
{
    //return CGRectGetMaxY(self.topBar.frame) - CGRectGetHeight(self.pageIndicatorView.frame) / 2.;
    return CGRectGetHeight(self.topBar.frame) - CGRectGetHeight(self.pageIndicatorView.frame) / 2.;
}


#pragma mark - Public

/**
 * 刷新轮播图位置数据
 */
- (void)refreshAdboardData:(NSArray *)dataArr
{
    if( dataArr.count > 0 )
    {
        if( [self.view viewWithTag:10])
        {
            [(MMiaAdboardView *)[self.view viewWithTag:10] setBannerPictureArr:dataArr];
        }
    }
}

/**
 * 当前选中/滑动的标签
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    
    NSAssert(selectedIndex < self.viewControllers.count, @"selectedIndex should belong within the range of the view controllers array");
    
    UIButton *previosSelectdItem = self.topBar.itemViews[self.selectedIndex];
    UIButton *nextSelectdItem = self.topBar.itemViews[selectedIndex];
    // 相邻的两个Tab滑动
    if (abs(self.selectedIndex - selectedIndex) <= 1)
    {
        [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.) animated:animated];

        if (selectedIndex == _selectedIndex)
        {
            /*
             self.topBar.itemImageView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
             [self pageIndicatorCenterY]);
             
             */
            //lx change
            if (self.selectedPageItemImage != nil)
            {
                self.topBar.itemImageView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                               [self pageIndicatorCenterY]);
            }else
            {
                self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x, [self newPageIndicatorCenterY]);
            }
           
        }

        [UIView animateWithDuration:(animated) ? 0.3 : 0. delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             [previosSelectdItem setTitleColor:self.pageItemsTitleColor forState:UIControlStateNormal];
             [nextSelectdItem setTitleColor:self.selectedPageItemTitleColor forState:UIControlStateNormal];
             
         } completion:^(BOOL finished){
             
         }];
    }
    // 不相邻的两个Tab滑动
    else
    {
        self.shouldObserveContentOffset = NO;
        BOOL scrollingRight = (selectedIndex > self.selectedIndex);
        UIViewController *leftViewController = self.viewControllers[MIN(self.selectedIndex, selectedIndex)];
        UIViewController *rightViewController = self.viewControllers[MAX(self.selectedIndex, selectedIndex)];
        leftViewController.view.frame = CGRectMake(0., 0., self.scrollWidth, self.scrollHeight);
        rightViewController.view.frame = CGRectMake(self.scrollWidth, 0., self.scrollWidth, self.scrollHeight);
        self.scrollView.contentSize = CGSizeMake(2 * self.scrollWidth, self.scrollHeight);
        
        CGPoint targetOffset;
        if (scrollingRight)
        {
            self.scrollView.contentOffset = CGPointZero;
            targetOffset = CGPointMake(self.scrollWidth, 0.);
        }
        else
        {
            self.scrollView.contentOffset = CGPointMake(self.scrollWidth, 0.);
            targetOffset = CGPointZero;
        }
        [self.scrollView setContentOffset:targetOffset animated:YES];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            /*
            self.topBar.itemImageView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                        [self pageIndicatorCenterY]);
             */
            //lx change
             if (self.selectedPageItemImage != nil)
             {
                 self.topBar.itemImageView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                                [self pageIndicatorCenterY]);
             }else
             {
                 self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x, [self newPageIndicatorCenterY]);
             }
            self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:selectedIndex];
            [previosSelectdItem setTitleColor:self.pageItemsTitleColor forState:UIControlStateNormal];
            [nextSelectdItem setTitleColor:self.selectedPageItemTitleColor forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            for (NSUInteger i = 0; i < self.viewControllers.count; i++)
            {
                UIViewController *viewController = self.viewControllers[i];
                viewController.view.frame = CGRectMake(i * self.scrollWidth, 0., self.scrollWidth, self.scrollHeight);
                [self.scrollView addSubview:viewController.view];
            }
            self.scrollView.contentSize = CGSizeMake(self.scrollWidth * self.viewControllers.count, self.scrollHeight);
            [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.) animated:NO];
            self.scrollView.userInteractionEnabled = YES;
            self.shouldObserveContentOffset = YES;
        }];
    }
    _selectedIndex = selectedIndex;
   
}

/**
 * 适配横竖屏切换
 */
- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation
{
    [self layoutSubviews];
}

#pragma mark * Overwritten setters

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (_viewControllers != viewControllers)
    {
        _viewControllers = viewControllers;
        self.topBar.itemTitles = [viewControllers valueForKey:@"title"];
        
        for (UIViewController *viewController in viewControllers)
        {
            [viewController willMoveToParentViewController:self];
            viewController.view.frame = CGRectMake(0., 0., self.scrollWidth, self.scrollHeight);
            [self.scrollView addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        }
        self.selectedIndex = 0;
        [self addHeaderView];
    }
}

- (void)setPageItemsTitleColor:(UIColor *)pageItemsTitleColor
{
    if (![_pageItemsTitleColor isEqual:pageItemsTitleColor])
    {
        _pageItemsTitleColor = pageItemsTitleColor;
        self.topBar.itemTitleColor = pageItemsTitleColor;
        [self.topBar.itemViews[self.selectedIndex] setTitleColor:self.selectedPageItemTitleColor forState:UIControlStateNormal];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedPageItemTitleColor:(UIColor *)selectedPageItemTitleColor
{
    if (![_selectedPageItemTitleColor isEqual:selectedPageItemTitleColor])
    {
        _selectedPageItemTitleColor = selectedPageItemTitleColor;
        [self.topBar.itemViews[self.selectedIndex] setTitleColor:selectedPageItemTitleColor forState:UIControlStateNormal];
    }
}

- (void)setSelectedPageItemImage:(UIImage *)selectedPageItemImage
{
    if (![_selectedPageItemImage isEqual:selectedPageItemImage])
    {
        _selectedPageItemImage = selectedPageItemImage;
        self.topBar.itemImage = selectedPageItemImage;
    }
}

- (void)setTopBarBackgroundColor:(UIColor *)topBarBackgroundColor
{
    _topBarBackgroundColor = topBarBackgroundColor;
    self.topBar.backgroundColor = topBarBackgroundColor;
}

- (void)setTopBarBackgroundImage:(UIImage *)topBarBackgroundImage
{
    self.topBar.backgroundImage = topBarBackgroundImage;
}

- (void)setTopBarHeight:(NSUInteger)topBarHeight
{
    if (_topBarHeight != topBarHeight)
    {
        _topBarHeight = topBarHeight;
        [self layoutSubviews];
    }
}

- (void)setTopBarItemLabelsFont:(UIFont *)font
{
    self.topBar.font = font;
}

//lx add
-(void)setPageIndicatorViewSize:(CGSize)pageIndicatorViewSize
{
    if ([self.pageIndicatorView isKindOfClass:[MMiaPageIndicatorView class]])
    {
        if (!CGSizeEqualToSize(self.pageIndicatorView.frame.size, pageIndicatorViewSize))
        {
            _pageIndicatorViewSize = pageIndicatorViewSize;
            self.pageIndicatorView.frame = CGRectMake(0, CGRectGetHeight(self.headerView.frame) - pageIndicatorViewSize.height, pageIndicatorViewSize.width, pageIndicatorViewSize.height);
            [self layoutSubviews];
        }
    }
}



#pragma mark - DAPagesContainerTopBar delegate

- (void)itemAtIndex:(NSUInteger)index didSelectInPagesContainerTopBar:(MMiaPagesContainerTopBar *)bar
{
    if (index != _selectedIndex)
    {
        [self resetHeaderViewSuperview];

    }
    [self setSelectedIndex:index animated:YES];
   
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    self.scrollView.userInteractionEnabled = YES;
    // 重新添加headerView
    [self addHeaderView];
    //lx add
    if (self.selcectBlock)
    {
        self.selcectBlock(self.selectedIndex);
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self resetHeaderViewSuperview];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        self.scrollView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.scrollView.userInteractionEnabled = YES;
    
    // 重新添加headerView
     [self addHeaderView];
    //lx add
     if (self.selcectBlock)
     {
        self.selcectBlock(self.selectedIndex);
     }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollView.userInteractionEnabled = NO;//YES;

}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
                       context:(void *)context
{
    CGFloat oldX = self.selectedIndex * CGRectGetWidth(self.scrollView.frame);

    if (oldX != self.scrollView.contentOffset.x && self.shouldObserveContentOffset)
    {
        BOOL scrollingTowards = (self.scrollView.contentOffset.x > oldX);
        NSInteger targetIndex = (scrollingTowards) ? self.selectedIndex + 1 : self.selectedIndex - 1;
        if (targetIndex >= 0 && targetIndex < self.viewControllers.count)
        {
            CGFloat ratio = (self.scrollView.contentOffset.x - oldX) / CGRectGetWidth(self.scrollView.frame);
            CGFloat previousItemContentOffsetX = [self.topBar contentOffsetForSelectedItemAtIndex:self.selectedIndex].x;
            CGFloat nextItemContentOffsetX = [self.topBar contentOffsetForSelectedItemAtIndex:targetIndex].x;
            CGFloat previousItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x;
            CGFloat nextItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:targetIndex].x;
            UIButton *previosSelectedItem = self.topBar.itemViews[self.selectedIndex];
            UIButton *nextSelectedItem = self.topBar.itemViews[targetIndex];
            
            CGFloat red, green, blue, alpha, highlightedRed, highlightedGreen, highlightedBlue, highlightedAlpha;
            [self getRed:&red green:&green blue:&blue alpha:&alpha fromColor:self.pageItemsTitleColor];
            [self getRed:&highlightedRed green:&highlightedGreen blue:&highlightedBlue alpha:&highlightedAlpha fromColor:self.selectedPageItemTitleColor];
            
            CGFloat absRatio = fabsf(ratio);
            UIColor *prev = [UIColor colorWithRed:red * absRatio + highlightedRed * (1 - absRatio)
                                            green:green * absRatio + highlightedGreen * (1 - absRatio)
                                             blue:blue * absRatio + highlightedBlue  * (1 - absRatio)
                                            alpha:alpha * absRatio + highlightedAlpha  * (1 - absRatio)];
            UIColor *next = [UIColor colorWithRed:red * (1 - absRatio) + highlightedRed * absRatio
                                            green:green * (1 - absRatio) + highlightedGreen * absRatio
                                             blue:blue * (1 - absRatio) + highlightedBlue * absRatio
                                            alpha:alpha * (1 - absRatio) + highlightedAlpha * absRatio];
            
            [previosSelectedItem setTitleColor:prev forState:UIControlStateNormal];
            [nextSelectedItem setTitleColor:next forState:UIControlStateNormal];
            
            
            
            if (scrollingTowards)
            {
                self.topBar.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX +
                                                                   (nextItemContentOffsetX - previousItemContentOffsetX) * ratio , 0.);
                /*
                self.topBar.itemImageView.center = CGPointMake(previousItemPageIndicatorX +
                                                            (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                            [self pageIndicatorCenterY]);
                 */
                //lx change 判断indicator类型
                if (self.selectedPageItemImage)
                {
                    self.topBar.itemImageView.center = CGPointMake(previousItemPageIndicatorX +
                                                                   (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                                   [self pageIndicatorCenterY]);
                }else
                {
                    self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX + (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio, [self newPageIndicatorCenterY]);
                }
                
            }
            else
            {
                //个人中心设置图片为nil
                self.topBar.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX -
                                                                   (nextItemContentOffsetX - previousItemContentOffsetX) * ratio , 0.);
                /*
                self.topBar.itemImageView.center = CGPointMake(previousItemPageIndicatorX -
                                                            (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                            [self pageIndicatorCenterY]);
                 */
                 //lx change 判断indicator类型
                if (self.selectedPageItemImage)
                {
                    self.topBar.itemImageView.center = CGPointMake(previousItemPageIndicatorX -
                                                                   (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                                   [self pageIndicatorCenterY]);
                }else
                {
                    //个人中心用
                    self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX - (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio, [self newPageIndicatorCenterY]);
                }
                
            }
        }
    }
}

- (void)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha fromColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    if (colorSpaceModel == kCGColorSpaceModelRGB && CGColorGetNumberOfComponents(color.CGColor) == 4)
    {
        *red = components[0];
        *green = components[1];
        *blue = components[2];
        *alpha = components[3];
    }
    else if (colorSpaceModel == kCGColorSpaceModelMonochrome && CGColorGetNumberOfComponents(color.CGColor) == 2)
    {
        *red = *green = *blue = components[0];
        *alpha = components[1];
    }
    else
    {
        *red = *green = *blue = *alpha = 0;
    }
}

@end