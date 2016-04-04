//
//  MMiaSingleCategoryContainer.m
//  MMIA
//
//  Created by yhx on 14-10-29.
//  Copyright (c) 2014年 广而告之. All rights reserved.
//

#import "MMiaSingleCategoryContainer.h"
#import "MMiaPagesContainerTopBar.h"
#import "MMiaPageIndicatorView.h"
#import "MMiaHotMagzineViewController.h"
#import "MMiaNewMagzineViewController.h"
#import "MagezineItem.h"
#import "MMiaDetailGoodsViewController.h"

static const NSInteger Top_TagView_Height = 35;

@interface MMiaSingleCategoryContainer () <UIScrollViewDelegate, MMiaPagesContainerTopBarDelegate>
{
    NSInteger categoryId;
    NSString* categoryTitle;
}

@property (strong, nonatomic) UIScrollView* scrollView;
@property (weak,   nonatomic) UIScrollView* observingScrollView;
@property (strong, nonatomic) UIView* topTagView;
@property (strong, nonatomic) UIView* pageIndicatorView;
@property (strong, nonatomic) MMiaPagesContainerTopBar* topBar;
@property (strong, nonatomic) UIButton* topButton;

@property (          assign, nonatomic) BOOL shouldObserveContentOffset;
@property (readonly, assign, nonatomic) CGFloat scrollWidth;
@property (readonly, assign, nonatomic) CGFloat scrollHeight;

- (void)getSingleCategoryDataForRequest;
- (void)netWorkWithError:(NSError *)error;

- (void)layoutSubviews;
- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView;
- (void)stopObservingContentOffset;
- (void)createNotifications;
- (void)destroyNotifications;
- (void)topBtnClicked:(UIButton *)sender;
- (void)layoutTopBtn:(id)object;
- (void)addViewControllers;

@end

@implementation MMiaSingleCategoryContainer

- (UIButton *)topButton
{
    if( !_topButton )
    {
        UIImage* image = [UIImage imageNamed:@"backTop.png"];
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.frame = CGRectMake(self.scrollWidth - image.size.width, CGRectGetHeight(self.view.bounds) - image.size.height - 20, image.size.width, image.size.height);
        _topButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_topButton setBackgroundImage:image forState:UIControlStateNormal];
        _topButton.backgroundColor = [UIColor clearColor];
        [_topButton addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _topButton.hidden = YES;
        [self.view addSubview:_topButton];
    }
    return _topButton;
}

#pragma mark - Initialization

#pragma mark - Life Cycle

- (id)initWithInfo:(NSInteger)info title:(NSString*)titleName
{
    self = [self init];
    if( self )
    {
        categoryId  = info;
        categoryTitle = titleName;
        
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
    _topBarHeight = Top_TagView_Height;
    _topBarBackgroundColor = [UIColor whiteColor];
    _topBarItemLabelsFont = [UIFont systemFontOfSize:12];
    _pageIndicatorViewSize = CGSizeMake(80., 1.);
    self.pageItemsTitleColor = [UIColor colorWithRed:0xd2/255.0 green:0xd2/255.0 blue:0xd2/255.0 alpha:1.0];
    self.selectedPageItemTitleColor = [UIColor colorWithRed:0x56/255.0 green:0x56/255.0 blue:0x56/255.0 alpha:1.0];
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleString:categoryTitle];
    [self addBackBtnWithTarget:self selector:@selector(back)];
    
    self.view.backgroundColor = [UIColor colorWithRed:0xef/255.0 green:0xef/255.0 blue:0xef/255.0 alpha:1.0];
    self.shouldObserveContentOffset = YES;
    
    // add topBarView
    _topTagView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, CGRectGetWidth(self.view.bounds), Top_TagView_Height)];
    _topTagView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topTagView];
    
    _topBar = [[MMiaPagesContainerTopBar alloc] initWithFrame:CGRectMake(0., 0, CGRectGetWidth(self.view.frame), self.topBarHeight)];
    _topBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _topBar.itemTitleColor = self.pageItemsTitleColor;
    _topBar.delegate = self;
    _topBar.backgroundColor = self.topBarBackgroundColor;
    UIImage* image = [[UIImage imageNamed:@"topBar_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5) resizingMode:UIImageResizingModeStretch];
    self.topBarBackgroundImage = image;
    [_topTagView addSubview:_topBar];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topTagView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_topTagView.frame))];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self addViewControllers];
    [self getSingleCategoryDataForRequest];
    
    [self startObservingContentOffsetForScrollView:self.scrollView];
    [self createNotifications];
}

- (void)viewDidUnload
{
    [self stopObservingContentOffset];
    self.scrollView = nil;
    self.topBar = nil;
    self.pageIndicatorView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
    [self layoutSubviews];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)getSingleCategoryDataForRequest
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary* dict = @{@"categoryId":[NSNumber numberWithLong:categoryId]};
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_SINGL_CATEGROY_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary* dataDict)
     {
         if( [dataDict[@"result"] intValue] == 0 )
         {
             NSDictionary* dict = [dataDict objectForKey:@"data"];
             NSArray* newArr = [dict objectForKey:@"newMagazine"];
             NSArray* hotArr = [dict objectForKey:@"hotMagazine"];
             
            // NSLog( @"newArr = %@", newArr );
             //NSLog( @"hotArr = %@", hotArr );

             // 解析最新杂志图片数据
             NSMutableArray* newestMagArr = [[NSMutableArray alloc] initWithCapacity:newArr.count];
             for( NSDictionary* newDict in newArr )
             {
                 MagezineItem* newItem = [[MagezineItem alloc] init];
                 newItem.aId = [newDict[@"id"] intValue];
                 newItem.pictureImageUrl = newDict[@"pictureUrl"];
                 newItem.logoWord = newDict[@"logoWord"];
                 newItem.userId = [newDict[@"userId"] intValue];
                 newItem.magazineId = [newDict[@"productId"] intValue];
                 newItem.imageWidth = [newDict[@"width"] floatValue];
                 newItem.imageHeight = [newDict[@"height"] floatValue];
                 newItem.imgPrice = [newDict[@"price"] floatValue];
                 newItem.likeNum = [newDict[@"supportNum"] intValue];
                 [newestMagArr addObject:newItem];
             }
             
             // 解析最热杂志图片数据
             NSMutableArray* hotMagazineArr = [[NSMutableArray alloc] initWithCapacity:hotArr.count];
             for( NSDictionary* hotDict in hotArr )
             {
                 MagezineItem* hotItem = [[MagezineItem alloc] init];
                 hotItem.aId = [hotDict[@"id"] intValue];
                 hotItem.pictureImageUrl = hotDict[@"pictureUrl"];
                 hotItem.logoWord = hotDict[@"logoWord"];
                 hotItem.userId = [hotDict[@"userId"] intValue];
                 hotItem.magazineId = [hotDict[@"productId"] intValue];
                 hotItem.imageWidth = [hotDict[@"width"] floatValue];
                 hotItem.imageHeight = [hotDict[@"height"] floatValue];
                 hotItem.imgPrice = [hotDict[@"price"] floatValue];
                 hotItem.likeNum = [hotDict[@"supportNum"] intValue];
                 [hotMagazineArr addObject:hotItem];
             }
             
             for (UIViewController* viewController in self.viewControllers)
             {
                 if( [viewController isKindOfClass:[MMiaHotMagzineViewController class]] )
                 {
                     [(MMiaHotMagzineViewController *)viewController refreshPageData:hotMagazineArr downNum:hotArr.count];
                 }
                 else if( [viewController isKindOfClass:[MMiaNewMagzineViewController class]] )
                 {
                     [(MMiaNewMagzineViewController *)viewController refreshPageData:newestMagArr downNum:newArr.count];
                 }
             }
         }
         else
         {
             [self netWorkWithError:nil];
         }
         
     } errorHandler:^(NSError* error)
     {
         [self netWorkWithError:error];
     }];
}

- (void)netWorkWithError:(NSError *)error
{
    for( int i = 0; i < self.viewControllers.count; ++i )
    {
        [self.viewControllers[i] netWorkError:error];
    }
}

- (void)addViewControllers
{
    MMiaHotMagzineViewController* hotViewController = [[MMiaHotMagzineViewController alloc] init];
    hotViewController.title = @"最热";
    hotViewController.channelId = categoryId;
    
    MMiaNewMagzineViewController* newViewController = [[MMiaNewMagzineViewController alloc] init];
    newViewController.title = @"最新";
    newViewController.channelId = categoryId;
    
    self.viewControllers = @[hotViewController, newViewController];
}

- (void)layoutSubviews
{
    self.topTagView.frame = CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, CGRectGetWidth(self.view.bounds), Top_TagView_Height);
    
    CGFloat x = 0.;
    for (UIViewController *viewController in self.viewControllers)
    {
        viewController.view.frame = CGRectMake(x, 0, CGRectGetWidth(self.scrollView.frame), self.scrollHeight);
        x += CGRectGetWidth(self.scrollView.frame);
    }
    self.scrollView.contentSize = CGSizeMake(x, self.scrollHeight);
    [self.scrollView setContentOffset:CGPointMake(self.selectedIndex * self.scrollWidth, 0.) animated:YES];
    self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x, [self pageIndicatorCenterY]);
    self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:self.selectedIndex];
    self.scrollView.userInteractionEnabled = YES;
    
    self.topButton.frame = CGRectMake(self.scrollWidth - 50, CGRectGetHeight(self.view.bounds) - 50 - 20, 50, 50);
}

- (CGFloat)pageIndicatorCenterY
{
    return CGRectGetMaxY(self.topBar.frame) - self.pageIndicatorViewSize.height + CGRectGetHeight(self.pageIndicatorView.frame) / 2.;
}

// 初始化每页指示箭头View
- (UIView *)pageIndicatorView
{
    if (!_pageIndicatorView)
    {
        if (self.pageIndicatorImage)
        {
            _pageIndicatorView = [[UIImageView alloc] initWithImage:self.pageIndicatorImage];
        }
        else
        {
            _pageIndicatorView = [[MMiaPageIndicatorView alloc] initWithFrame:CGRectMake(0., CGRectGetMaxY(self.topBar.frame), self.pageIndicatorViewSize.width, self.pageIndicatorViewSize.height)];
            [(MMiaPageIndicatorView *)_pageIndicatorView setColor:[UIColor colorWithRed:0xc4/255.0 green:0x1e/255.0 blue:0x1e/255.0 alpha:1.0]];//c41e1e
        }
        [self.topTagView addSubview:_pageIndicatorView];
    }
    return _pageIndicatorView;
}

- (CGFloat)scrollHeight
{
    return CGRectGetHeight(self.scrollView.bounds);
}

- (CGFloat)scrollWidth
{
    return CGRectGetWidth(self.scrollView.bounds);
}

- (void)topBtnClicked:(UIButton *)sender
{
    self.topButton.hidden = YES;
    
    [self.viewControllers[self.selectedIndex] backToViewTopPosition];
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

- (void)didSelectItemInPageAtIndexPath:(NSNotification*)notification
{
    NSDictionary* dict = [notification userInfo];
    MagezineItem* item = dict[@"item"];
    MMiaDetailGoodsViewController *detailGoodsVC=[[MMiaDetailGoodsViewController alloc]initWithTitle:item.logoWord Id:item.aId goodsImage:item.pictureImageUrl Width:item.imageWidth Height:item.imageHeight price:item.imgPrice productId:item.magazineId];
    [self.navigationController pushViewController:detailGoodsVC animated:YES];
}

#pragma mark - Public

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
            self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                        [self pageIndicatorCenterY]);
        }
        
        [UIView animateWithDuration:(animated) ? 0.3 : 0. delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             [previosSelectdItem setTitleColor:self.pageItemsTitleColor forState:UIControlStateNormal];
             [nextSelectdItem setTitleColor:self.selectedPageItemTitleColor forState:UIControlStateNormal];
             
         } completion:nil];
    }
    // 不相邻的两个Tab滑动
    else
    {
        // This means we should "jump" over at least one view controller
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
            self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                        [self pageIndicatorCenterY]);
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

- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation
{
    [self layoutSubviews];
}

#pragma mark * Overwritten setters

- (void)setViewControllers:(NSArray *)viewControllers
{
    if( _viewControllers != viewControllers )
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
        [self layoutSubviews];
    }
}

- (void)setPageIndicatorViewSize:(CGSize)size
{
    if ([self.pageIndicatorView isKindOfClass:[MMiaPageIndicatorView class]])
    {
        if (!CGSizeEqualToSize(self.pageIndicatorView.frame.size, size))
        {
            _pageIndicatorViewSize = size;
            [self layoutSubviews];
        }
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

- (void)setTopBarBackgroundColor:(UIColor *)topBarBackgroundColor
{
    _topBarBackgroundColor = topBarBackgroundColor;
    self.topBar.backgroundColor = topBarBackgroundColor;
    if ([self.pageIndicatorView isKindOfClass:[MMiaPageIndicatorView class]])
    {
        [(MMiaPageIndicatorView *)self.pageIndicatorView setColor:topBarBackgroundColor];
    }
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

- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage
{
    _pageIndicatorImage = pageIndicatorImage;
    self.pageIndicatorViewSize = (pageIndicatorImage) ? pageIndicatorImage.size : self.pageIndicatorViewSize;
    if ((pageIndicatorImage && [self.pageIndicatorView isKindOfClass:[MMiaPageIndicatorView class]]) || (!pageIndicatorImage && [self.pageIndicatorView isKindOfClass:[UIImageView class]]))
    {
        [self.pageIndicatorView removeFromSuperview];
        self.pageIndicatorView = nil;
    }
    if (pageIndicatorImage)
    {
        if ([self.pageIndicatorView isKindOfClass:[MMiaPageIndicatorView class]])
        {
            [self.pageIndicatorView removeFromSuperview];
            self.pageIndicatorView = nil;
        }
        [(UIImageView *)self.pageIndicatorView setImage:pageIndicatorImage];
    }
    else
    {
        if ([self.pageIndicatorView isKindOfClass:[UIImageView class]])
        {
            [self.pageIndicatorView removeFromSuperview];
            self.pageIndicatorView = nil;
        }
        [(MMiaPageIndicatorView *)self.pageIndicatorView setColor:[UIColor redColor]];
    }
}

#pragma mark - 通知

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemInPageAtIndexPath:) name:@"didSelectItemAtPage" object:nil];
}

- (void)destroyNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowTopButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HideTopButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemAtPage" object:nil];
}

#pragma mark - DAPagesContainerTopBar delegate

- (void)itemAtIndex:(NSUInteger)index didSelectInPagesContainerTopBar:(MMiaPagesContainerTopBar *)bar
{
    [self setSelectedIndex:index animated:YES];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    self.scrollView.userInteractionEnabled = YES;
    [self layoutTopBtn:[self.viewControllers[self.selectedIndex] collectionView]];
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollView.userInteractionEnabled = NO;
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
                self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX +
                                                            (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                            [self pageIndicatorCenterY]);
                
            }
            else
            {
                self.topBar.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX -
                                                                   (nextItemContentOffsetX - previousItemContentOffsetX) * ratio , 0.);
                self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX -
                                                            (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                            [self pageIndicatorCenterY]);
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