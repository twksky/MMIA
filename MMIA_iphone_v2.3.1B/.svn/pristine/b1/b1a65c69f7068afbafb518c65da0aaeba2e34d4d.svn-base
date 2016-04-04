//
//  MMiaPagesContainerTopBar.m
//  MMIA
//
//  Created by MMIA-Mac on 14-8-12.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaPagesContainerTopBar.h"

#define DAPagesContainerTopBarItemViewWidth 100.
#define DAPagesContainerTopBarItemsOffset 30.

@interface MMiaPagesContainerTopBar ()

@property (strong, nonatomic) UIImageView*  backgroundImageView;
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) NSArray*      itemViews;

- (void)layoutItemViews;

@end

@implementation MMiaPagesContainerTopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        self.font = [UIFont systemFontOfSize:14];
        self.itemTitleColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Public

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index
{
    CGPoint center = ((UIView *)self.itemViews[index]).center;
    CGPoint offset = [self contentOffsetForSelectedItemAtIndex:index];
    center.x -= offset.x - (CGRectGetMinX(self.scrollView.frame));
    return center;
}

- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index
{
    if (self.itemViews.count < index || self.itemViews.count == 1)
    {
        return CGPointZero;
    }
    else
    {
        CGFloat totalOffset = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame);
        return CGPointMake(index * totalOffset / (self.itemViews.count - 1), 0.);
    }
}

#pragma mark * Overwritten setters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundImageView.image = backgroundImage;
}

- (void)setItemTitles:(NSArray *)itemTitles
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
    if (![_itemTitleColor isEqual:itemTitleColor])
    {
        _itemTitleColor = itemTitleColor;
        for (UIButton *button in self.itemViews)
        {
            [button setTitleColor:itemTitleColor forState:UIControlStateNormal];
        }
    }
}

- (void)setFont:(UIFont *)font
{
    if (![_font isEqual:font])
    {
        _font = font;
        for (UIButton *itemView in self.itemViews)
        {
            [itemView.titleLabel setFont:font];
        }
    }
}

- (void)setItemImage:(UIImage *)itemImage
{
    if( ![_itemImage isEqual:itemImage] )
    {
        _itemImage = itemImage;
        
        if( !_itemImageView )
        {
            _itemImageView = [[UIImageView alloc] initWithImage:itemImage];
            [self.scrollView addSubview:_itemImageView];
        }
        else
        {
            self.itemImageView.image = itemImage;
        }
    }
}

#pragma mark - Private

- (UIButton *)addItemView
{
    CGRect frame = CGRectMake(0., 0., DAPagesContainerTopBarItemViewWidth, CGRectGetHeight(self.frame));
    UIButton *itemView = [[UIButton alloc] initWithFrame:frame];
    [itemView addTarget:self action:@selector(itemViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    itemView.titleLabel.font = self.font;
    [itemView setTitleColor:self.itemTitleColor forState:UIControlStateNormal];
//    itemView.layer.borderWidth = 1;
//    itemView.layer.borderColor = [UIColor redColor].CGColor;
//    itemView.layer.cornerRadius = 1;

    [self.scrollView addSubview:itemView];
    return itemView;
}

- (void)itemViewTapped:(UIButton *)sender
{
    [self.delegate itemAtIndex:[self.itemViews indexOfObject:sender] didSelectInPagesContainerTopBar:self];
}

// 对scrollView上的UIButton布局
- (void)layoutItemViews
{
    CGFloat itemWidth = CGRectGetWidth(self.frame) / self.itemViews.count;
    CGFloat x = CGRectGetMinX(self.frame);
    for ( UIButton* itemView in self.itemViews )
    {
        itemView.frame = CGRectMake(x, CGRectGetMinY(self.bounds) + 3, itemWidth, CGRectGetHeight(self.bounds) - 6);
        x += itemWidth;

        // 添加分割线
        UIImage *lineImg = [UIImage imageNamed:@"分割线竖.png"];
        CGFloat height = [itemView.titleLabel.text sizeWithFont:self.font].height + 6;
        UIImageView* lineView = [[UIImageView alloc] initWithFrame:CGRectMake(x, CGRectGetMinY(self.frame) + height/2, 1, height)];
        lineView.image = lineImg;
        
        [self.scrollView addSubview:lineView];
    }
    self.scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.scrollView.frame));
    CGRect frame = self.scrollView.frame;
    if (CGRectGetWidth(self.frame) > x)
    {
        frame.origin.x = (CGRectGetWidth(self.frame) - x) / 2.;
        frame.size.width = x;
    }
    else
    {
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

#pragma mark * Lazy getters

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:_backgroundImageView belowSubview:self.scrollView];
    }
    return _backgroundImageView;
}

@end
