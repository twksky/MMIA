//
//  MPageControl.h
//  TestMainViewDemo
//
//  Created by MMIA-Mac on 15-6-1.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MPageControlAlignment)
{
    MPageControlAlignmentLeft = 1,
    MPageControlAlignmentCenter,
    MPageControlAlignmentRight
};

typedef NS_ENUM(NSUInteger, MPageControlVerticalAlignment)
{
    MPageControlVerticalAlignmentTop = 1,
    MPageControlVerticalAlignmentMiddle,
    MPageControlVerticalAlignmentBottom
};

@interface MPageControl : UIControl

@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGFloat indicatorMargin							UI_APPEARANCE_SELECTOR; // deafult is 10
@property (nonatomic) CGFloat indicatorDiameter							UI_APPEARANCE_SELECTOR; // deafult is 6
@property (nonatomic) MPageControlAlignment alignment					UI_APPEARANCE_SELECTOR; // deafult is Center
@property (nonatomic) MPageControlVerticalAlignment verticalAlignment	UI_APPEARANCE_SELECTOR;	// deafult is Middle

@property (nonatomic, strong) UIImage *pageIndicatorImage				UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor			UI_APPEARANCE_SELECTOR; // ignored if pageIndicatorImage is set
@property (nonatomic, strong) UIImage *currentPageIndicatorImage		UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor	UI_APPEARANCE_SELECTOR; // ignored if currentPageIndicatorImage is set

@property (nonatomic) BOOL hidesForSinglePage;			// hide the the indicator if there is only one page. default is NO
@property (nonatomic) BOOL defersCurrentPageDisplay;	// if set, clicking to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO

- (void)updateCurrentPageDisplay;						// update page display to match the currentPage. ignored if defersCurrentPageDisplay is NO. setting the page value directly will update immediately

- (CGRect)rectForPageIndicator:(NSInteger)pageIndex;
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

- (void)setImage:(UIImage *)image forPage:(NSInteger)pageIndex;
- (void)setCurrentImage:(UIImage *)image forPage:(NSInteger)pageIndex;
- (UIImage *)imageForPage:(NSInteger)pageIndex;
- (UIImage *)currentImageForPage:(NSInteger)pageIndex;

- (void)updatePageNumberForScrollView:(UIScrollView *)scrollView;


@end
