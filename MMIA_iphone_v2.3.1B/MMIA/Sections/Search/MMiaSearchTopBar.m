//
//  MMiaSearchTopBar.m
//  MMIA
//
//  Created by lixiao on 15/1/9.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMiaSearchTopBar.h"

#define TopBarItemsOffset (App_Frame_Width-362/2)/2.0
@interface MMiaSearchTopBar ()


@end
@implementation MMiaSearchTopBar

CGFloat const MMiaSearchPageContainerTopBarItemViewWidth = 181/2.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-5)];
        self.scrollView.backgroundColor = UIColorFromRGB(0x76767d);
        self.scrollView.layer.cornerRadius = 12;
        self.scrollView.clipsToBounds = YES;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.showsHorizontalScrollIndicator = NO;
       
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.indicatorView];

    }
    return self;
}
#pragma mark - init
-(UIView *)indicatorView
{
    if (!_indicatorView) {
        CGRect frame = CGRectMake(0., 0., MMiaSearchPageContainerTopBarItemViewWidth, CGRectGetHeight(self.scrollView.frame));
        _indicatorView = [[UIView alloc]initWithFrame:frame];
        _indicatorView.backgroundColor = UIColorFromRGB(0xe14a4a);
        _indicatorView.clipsToBounds = YES;
        _indicatorView.layer.cornerRadius = 12;
    }
    return _indicatorView;
}

#pragma mark - Public
- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index
{
    CGPoint center = ((UIView *)self.itemViews[index]).center;
    CGPoint offset = [self contentOffsetForSelectedItemAtIndex:index];
   // center.x -= offset.x - (CGRectGetMinX(self.scrollView.frame));
    center.x -= offset.x;
    return center;
}

- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index
{
    //计算有误
    if (self.itemViews.count < index || self.itemViews.count == 1) {
        return CGPointZero;
    } else {
        CGFloat totalOffset = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame);
    
        return CGPointMake(index * totalOffset / (self.itemViews.count - 1), 0.);
    }
}

#pragma mark * Overwritten setters
//-(void)setBackgroundColor:(UIColor *)backgroundColor
//{
//    self.backgroundColor = backgroundColor;
//}
-(void)setItemTitles:(NSArray *)itemTitles
{
    if (_itemTitles != itemTitles)
    {
        _itemTitles = itemTitles;
        NSMutableArray *mutableItemViews = [NSMutableArray arrayWithCapacity:itemTitles.count];
        for (NSUInteger i = 0; i < itemTitles.count; i++)
        {
            UIButton *itemView = [self addItemView];
            [itemView setTitle:itemTitles[i] forState:UIControlStateNormal];
            [mutableItemViews addObject:itemView];
        }
        self.itemViews = [NSArray arrayWithArray:mutableItemViews];
        [self layoutItemViews];
        
    }
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor
{
    if (![_itemTitleColor isEqual:itemTitleColor]) {
        _itemTitleColor = itemTitleColor;
        for (UIButton *button in self.itemViews) {
            [button setTitleColor:itemTitleColor forState:UIControlStateNormal];
        }
    }
}

-(void)setItemTitleFont:(UIFont *)itemTitleFont
{
    if (![_itemTitleFont isEqual:itemTitleFont])
    {
        _itemTitleFont = itemTitleFont;
        for (UIButton *button in self.itemViews) {
            [button.titleLabel setFont:itemTitleFont];
        }
        
    }
}


#pragma mark - Private
-(UIButton *)addItemView
{
    CGRect frame = CGRectMake(0., 0., MMiaSearchPageContainerTopBarItemViewWidth, CGRectGetHeight(self.scrollView.frame));
    UIButton *itemView = [[UIButton alloc] initWithFrame:frame];
    [itemView addTarget:self action:@selector(itemViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.itemTitleFont = [UIFont systemFontOfSize:15];
    itemView.titleLabel.font =  self.itemTitleFont;
    [itemView setTitleColor:self.itemTitleColor forState:UIControlStateNormal];
    [self.scrollView addSubview:itemView];
    return itemView;
}
- (void)itemViewTapped:(UIButton *)sender
{
    [self.delegate itemAtIndex:[self.itemViews indexOfObject:sender] didSelectInPagesContainerTopBar:self];
}
- (void)layoutItemViews
{
    CGFloat x = 0;
    for (NSUInteger i = 0; i < self.itemViews.count; i++) {
      //CGFloat width = [self.itemTitles[i] sizeWithFont:self.itemTitleFont].width;
        CGFloat width = MMiaSearchPageContainerTopBarItemViewWidth;
        UIView *itemView = self.itemViews[i];
        itemView.frame = CGRectMake(x, 0., width, CGRectGetHeight(self.scrollView.frame));
        x += width ;
    }
    self.scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.scrollView.frame));
    CGRect frame = self.scrollView.frame;
    if (CGRectGetWidth(self.frame) > x) {
        frame.origin.x = (CGRectGetWidth(self.frame) - x) / 2.;
        frame.size.width = x;
    } else {
        frame.origin.x = 0.;
        frame.size.width = CGRectGetWidth(self.frame);
    }
    
    self.scrollView.frame = frame;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutItemViews];
}



@end
