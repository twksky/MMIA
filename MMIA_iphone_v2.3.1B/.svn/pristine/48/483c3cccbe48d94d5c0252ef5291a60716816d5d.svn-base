//
//  MMiaSearchPageContainer.m
//  MMIA
//
//  Created by lixiao on 15/1/9.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMiaSearchPageContainer.h"
#import "MMiaSearchTopBar.h"


@interface MMiaSearchPageContainer ()<MMiaSearchTopBarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) MMiaSearchTopBar *topBar;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak,   nonatomic) UIScrollView *observingScrollView;

@property (          assign, nonatomic) BOOL shouldObserveContentOffset;
@property (readonly, assign, nonatomic) CGFloat scrollWidth;
@property (readonly, assign, nonatomic) CGFloat scrollHeight;
@end

@implementation MMiaSearchPageContainer

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)dealloc
{
    [self stopObservingContentOffset];
}

- (void)setUp
{
    _topBarHeight = 29.;
    self.topBarBackgroundColor = UIColorFromRGB(0x393b49);
    _topBarItemLabelsFont = [UIFont systemFontOfSize:12];
    self.pageItemsTitleColor = UIColorFromRGB(0xffffff);
    
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldObserveContentOffset = YES;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.,
                                                                     self.topBarHeight,
                                                                     CGRectGetWidth(self.view.frame),
                                                                     CGRectGetHeight(self.view.frame) - self.topBarHeight)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self startObservingContentOffsetForScrollView:self.scrollView];
    
    self.topBar = [[MMiaSearchTopBar alloc] initWithFrame:CGRectMake(0.,
                                                                           0.,
                                                                          CGRectGetWidth(self.view.frame),
                                                                           self.topBarHeight)];
   self.topBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
  self.topBar.itemTitleColor = self.pageItemsTitleColor;
  self.topBar.delegate = self;
  self.topBar.backgroundColor = self.topBarBackgroundColor;
  [self.view addSubview:self.topBar];
  
}


- (void)viewDidUnload
{
    [self stopObservingContentOffset];
    self.scrollView = nil;
    self.topBar = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutSubviews];
}

#pragma mark - Public
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    UIButton *previosSelectdItem = self.topBar.itemViews[self.selectedIndex];
    UIButton *nextSelectdItem = self.topBar.itemViews[selectedIndex];
    if (abs(self.selectedIndex - selectedIndex) <=1) {
         [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.) animated:animated];
        if (selectedIndex == _selectedIndex)
        {
            self.topBar.indicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                        [self pageIndicatorCenterY]);
        }

        [UIView animateWithDuration:(animated) ? 0.3 : 0. delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             [previosSelectdItem setTitleColor:self.pageItemsTitleColor forState:UIControlStateNormal];
             [nextSelectdItem setTitleColor:self.selectedPageItemTitleColor forState:UIControlStateNormal];
         } completion:nil];
    }else
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
        } else
        {
            self.scrollView.contentOffset = CGPointMake(self.scrollWidth, 0.);
            targetOffset = CGPointZero;
        }
        [self.scrollView setContentOffset:targetOffset animated:YES];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
           self.topBar.indicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                       [self pageIndicatorCenterY]);
            self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:selectedIndex];
            [previosSelectdItem setTitleColor:self.pageItemsTitleColor forState:UIControlStateNormal];
            [nextSelectdItem setTitleColor:self.selectedPageItemTitleColor forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            for (NSUInteger i = 0; i < self.viewControllers.count; i++) {
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

#pragma mark - Private

- (void)layoutSubviews
{
    self.topBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.topBarHeight);
    CGFloat x = 0.;
    for (UIViewController *viewController in self.viewControllers)
    {
        viewController.view.frame = CGRectMake(x, 0, CGRectGetWidth(self.scrollView.frame), self.scrollHeight);
        x += CGRectGetWidth(self.scrollView.frame);
    }
    self.scrollView.contentSize = CGSizeMake(x, self.scrollHeight);
    [self.scrollView setContentOffset:CGPointMake(self.selectedIndex * self.scrollWidth, 0) animated:YES];
 self.topBar.indicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,
                                                [self pageIndicatorCenterY]);
    self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:self.selectedIndex];
    self.scrollView.userInteractionEnabled = YES;
    
}
- (CGFloat)pageIndicatorCenterY
{
    return CGRectGetHeight(self.topBar.scrollView.bounds) / 2.0;
}

#pragma mark * Overwritten setters

- (CGFloat)scrollHeight
{
    return CGRectGetHeight(self.view.frame) - self.topBarHeight;
}

- (CGFloat)scrollWidth
{
    return CGRectGetWidth(self.scrollView.frame);
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView
{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    self.observingScrollView = scrollView;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (_viewControllers != viewControllers) {
        _viewControllers = viewControllers;
        self.topBar.itemTitles = [viewControllers valueForKey:@"title"];
        for (UIViewController *viewController in viewControllers) {
            [viewController willMoveToParentViewController:self];
            viewController.view.frame = CGRectMake(0., 0., CGRectGetWidth(self.scrollView.frame), self.scrollHeight);
            [self.scrollView addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        }
        [self layoutSubviews];
        self.selectedIndex = 0;
       self.topBar.indicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,
                                                    [self pageIndicatorCenterY]);
    }
}


- (void)stopObservingContentOffset
{
    if (self.observingScrollView)
    {
        [self.observingScrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.observingScrollView = nil;
    }
}

#pragma mark - MMiaSearchTopBar delegate
- (void)itemAtIndex:(NSUInteger)index didSelectInPagesContainerTopBar:(MMiaSearchTopBar *)bar
{
    [self setSelectedIndex:index animated:YES];
}

#pragma mark - UIScrollView delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    self.scrollView.userInteractionEnabled = YES;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
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
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat oldX = self.selectedIndex * CGRectGetWidth(self.scrollView.frame);
    if (oldX != self.scrollView.contentOffset.x && self.shouldObserveContentOffset)
    {
        BOOL scrollingTowards = (self.scrollView.contentOffset.x > oldX);
        NSInteger targetIndex = (scrollingTowards) ? self.selectedIndex +1 : self.selectedIndex -1;
        if (targetIndex >= 0 && targetIndex < self.viewControllers.count)
        {
            CGFloat ratio = (self.scrollView.contentOffset.x - oldX) / CGRectGetWidth(self.scrollView.frame);
            CGFloat previousItemContentOffsetX = [self.topBar contentOffsetForSelectedItemAtIndex:self.selectedIndex].x;
            CGFloat nextItemContentOffsetX = [self.topBar contentOffsetForSelectedItemAtIndex:targetIndex].x;
            CGFloat previousItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x;
            CGFloat nextItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:targetIndex].x;
            UIButton *previosSelectedItem = self.topBar.itemViews[self.selectedIndex];
            UIButton *nextSelectedItem = self.topBar.itemViews[targetIndex];
            if (scrollingTowards)
            {
                self.topBar.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX + (nextItemContentOffsetX-previousItemContentOffsetX)*ratio, 0);
                self.topBar.indicatorView.center = CGPointMake(previousItemPageIndicatorX +
                                                            (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                               [self pageIndicatorCenterY]);
            }else
            {
                self.topBar.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX - (nextItemContentOffsetX - previousItemContentOffsetX) *ratio, 0);
                self.topBar.indicatorView.center = CGPointMake(previousItemPageIndicatorX -
                                                            (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                            [self pageIndicatorCenterY]);
            }
            
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
