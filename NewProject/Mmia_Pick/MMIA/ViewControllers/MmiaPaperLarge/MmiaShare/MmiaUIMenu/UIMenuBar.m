//
//  UIMenuBar.m
//  TesdXcodeUserGuideDemo
//
//  Created by twk on 15-5-19.
//  Copyright (c) 2015年 tanwenkai. All rights reserved.
//

#import "UIMenuBar.h"
#import <QuartzCore/QuartzCore.h>
#import "MmiaDetailsCollectionViewController.h"

#define kSemiModalAnimationDuration 0.3f

@interface UIMenuBar ()


- (void)_initCommonUI;
- (void)_resetSubViewsLayout;
- (void)_resetContainerViewLayout;
- (void)_presentModelView;
- (void)_dismissModalView;

@property ( nonatomic , strong ) UIWindow *keywindow;

@end


@implementation UIMenuBar

@synthesize items = _items;
@synthesize tintColor = _tintColor;

-(UIWindow *)keywindow{
    if (_keywindow == nil) {
        _keywindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_keywindow makeKeyAndVisible];
    }
    return _keywindow;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        CGSize size = [[UIScreen mainScreen] applicationFrame].size;
        self.frame = CGRectMake(0, 0, size.width, size.height);
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _containerScrollViews = [[NSMutableArray alloc] initWithCapacity:0];
        [self _initCommonUI];
        [self _resetSubViewsLayout];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    if(self = [super initWithFrame:frame]){
        _items = [[NSMutableArray alloc] initWithArray:items];
        _containerScrollViews = [[NSMutableArray alloc] initWithCapacity:0];
        [self _initCommonUI];
        [self _resetSubViewsLayout];
    }
    return self;
}


- (void)setItems:(NSMutableArray *)items
{
    for(UIMenuBarItem *item in _items){
        [item.containView removeFromSuperview];
    }
    
    [_items removeAllObjects];
    [_items addObjectsFromArray:items];
    
    [self _resetSubViewsLayout];
    
}

- (void)_initCommonUI
{
    _originalSize = self.frame.size;
    _halfOriginalSize = CGSizeMake(_originalSize.width, _originalSize.height);
//    设置分享view背景颜色
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    
    _pages = (_items.count / 4) + (_items.count % 4 == 0 ? 0 : 1);
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                   self.bounds.size.height-20.f,
                                                                   self.bounds.size.width,
                                                                   20.0f)];
    _pageControl.numberOfPages = _pages;
    _pageControl.currentPage = 1;
    [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    _pageControl.backgroundColor =  [UIColor clearColor];
    [self addSubview:_pageControl];
    
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.bounds.size.width,
                                                                    self.bounds.size.height - _pageControl.bounds.size.height)];
    _containerView.delegate = self;
    _containerView.pagingEnabled = YES;
    
    [self addSubview:_containerView];
    
    
}

- (void)_resetContainerViewLayout
{
    if(_items.count <= 4){
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _halfOriginalSize.width, _halfOriginalSize.height);
    }else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _originalSize.width, _originalSize.height);
    }
    
    if(_pages > 1) {
        
        _pageControl.hidden = FALSE;
        _containerView.scrollEnabled = TRUE;
        _containerView.frame = CGRectMake(0,
                                          0,
                                          self.bounds.size.width,
                                          self.bounds.size.height - _pageControl.bounds.size.height);
    }else {
        
        _pageControl.hidden = TRUE;
        _containerView.scrollEnabled = FALSE;
        _containerView.frame = CGRectMake(0,
                                          0,
                                          self.bounds.size.width,
                                          self.bounds.size.height);
    }
    
    _containerView.contentSize = CGSizeMake(_pages * _containerView.bounds.size.width,
                                            _containerView.bounds.size.height);
}

- (void)_resetSubViewsLayout
{
    if(_items.count==0) return;
    
    _pages = (_items.count / 4) + (_items.count % 4 == 0 ? 0 : 1);
    _pageControl.numberOfPages = _pages;
    _pageControl.currentPage = 0;
    
    [self _resetContainerViewLayout];
    
    
    if(_containerScrollViews && _containerScrollViews.count > 0){
        for(UIView * view in _containerScrollViews){
            [view removeFromSuperview];
        }
        [_containerScrollViews removeAllObjects];
    }
    
    for(int page = 0; page < _pages; page ++){
        
        UIView* pageContent = [[UIView alloc] initWithFrame:CGRectMake(page * _containerView.bounds.size.width,
                                                                       0,
                                                                       _containerView.bounds.size.width,
                                                                       _containerView.bounds.size.height)];
        
        for(int index = (page * 4); index < (page * 4 + 4); index++){
            
            if(index == _items.count) break;
            UIMenuBarItem *item = (UIMenuBarItem *)[_items objectAtIndex:index];
            
            int relativeIndex = index - (page * 4);
            int row = relativeIndex/4 < 1? 0 : 1;
            int coloumn = (relativeIndex % 4);
            
            int width = self.frame.size.width/4.0f;
            int x = (width-item.sizeValue)/2.0f;
            
            int height = (_containerView.frame.size.height)/1.0f;
            int y = (height-item.sizeValue)/2.0f;
            
            item.containView.frame = CGRectMake(OriginX+(item.sizeValue+Gap)*coloumn,
                                                OriginY,
                                                item.sizeValue,
                                                item.sizeValue);
//            NSLog(@"%@",NSStringFromCGRect(item.containView.frame));
            [pageContent addSubview:item.containView];
            
            [item.containView mas_makeConstraints:^(MASConstraintMaker *make){
                            //            make.width.equalTo(@(setImage.size.width + 10));
                            //            make.height.equalTo(@(setImage.size.height + 10));
                            //            make.right.equalTo(@(setImage.size.width - 30));
                            //            make.top.equalTo(@(top));
//                make.left.equalTo(@(10));
//                make.top.equalTo(@(30));
//                make.size.mas_equalTo(CGSizeMake(80, 40));
                        }];
        }
        
        
        [_containerScrollViews addObject:pageContent];
        [_containerView addSubview:pageContent];
        [pageContent release];
    }
}


- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
    CGPoint offset = aScrollView.contentOffset;
    _pageControl.currentPage = offset.x / _containerView.bounds.size.width;
}

- (void) pageTurn: (UIPageControl *) aPageControl
{
    NSInteger whichPage = aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _containerView.contentOffset = CGPointMake(_containerView.bounds.size.width * whichPage, 0.0f);
    [UIView commitAnimations];
}

- (void)setTintColor:(UIColor *)tintColor
{
    if(_tintColor){
        [_tintColor release];
        _tintColor = nil;
    }
    
    _tintColor = [tintColor retain];
    self.backgroundColor = _tintColor;
}

- (void)show
{
    [self _presentModelView];
}

- (void)dismiss
{
    [self _dismissModalView];
}


- (void)_presentModelView
{
    //    NSLog(@"%@", keywindow);
    if (![self.keywindow.subviews containsObject:self]) {
        // Calulate all frames
        CGRect sf = self.frame;
        CGRect vf = self.keywindow.frame;
        CGRect f  = CGRectMake(0, vf.size.height-sf.size.height, vf.size.width, sf.size.height);
        CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);
        
        // Add semi overlay
        UIView * overlay = [[UIView alloc] initWithFrame:self.keywindow.bounds];
//        overlay.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
        
        UIView* ss = [[UIView alloc] initWithFrame:self.keywindow.bounds];
        [overlay addSubview:ss];
        [self.keywindow addSubview:overlay];
        
        UIControl * dismissButton = [[UIControl alloc] initWithFrame:CGRectZero];
        [dismissButton addTarget:self action:@selector(_dismissModalView) forControlEvents:UIControlEventTouchUpInside];
        dismissButton.backgroundColor = [UIColor clearColor];
        dismissButton.frame = of;
        [overlay addSubview:dismissButton];
        
        // Begin overlay animation
        [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
            ss.alpha = 0.5;
        }];
        
        // Present view animated
        self.frame = CGRectMake(0, vf.size.height, vf.size.width, sf.size.height);
        [self.keywindow addSubview:self];
//        self.layer.shadowColor = [[UIColor blackColor] CGColor];
//        self.layer.shadowOffset = CGSizeMake(0, -2);
//        self.layer.shadowRadius = 5.0;
//        self.layer.shadowOpacity = 0.8;
        [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
            self.frame = f;
        }];
    }
}

- (void)_dismissModalView
{
    UIView * modal = [self.keywindow.subviews objectAtIndex:self.keywindow.subviews.count-1];
    UIView * overlay = [self.keywindow.subviews objectAtIndex:self.keywindow.subviews.count-2];
    [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
        modal.frame = CGRectMake(0, self.keywindow.frame.size.height, modal.frame.size.width, modal.frame.size.height);
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [modal removeFromSuperview];
    }];
    // Begin overlay animation
    UIImageView * ss = (UIImageView*)[overlay.subviews objectAtIndex:0];
    [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
        ss.alpha = 1;
    }];
    [NSTimer scheduledTimerWithTimeInterval:kSemiModalAnimationDuration target:self selector:@selector(hide) userInfo:nil repeats:NO];
}
-(void)hide{
    self.keywindow.hidden = YES;
}

-(void)initWithTarget:(id)target{
    _target = target;
}


@end
