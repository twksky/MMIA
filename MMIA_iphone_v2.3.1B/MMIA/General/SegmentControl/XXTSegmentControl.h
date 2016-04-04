//
//  XXTSegmentControl.h
//  mySegmentControl
//
//  Created by Vivian's Office MAC on 14-5-7.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import <UIKit/UIKit.h>


// define some macros
#ifndef __has_feature
#define __has_feature(x) 0
#endif
#ifndef __has_extension
#define __has_extension __has_feature // Compatibility with pre-3.0 compilers.
#endif

#if __has_feature(objc_arc) && __clang_major__ >= 3
#define XXT_ARC_ENABLED 1
#endif // __has_feature(objc_arc)

#if XXT_ARC_ENABLED
#define XXT_RETAIN(xx) (xx)
#define XXT_RELEASE(xx)  xx = nil
#define XXT_AUTORELEASE(xx)  (xx)
#define XXT_DEALLOC(xx) (xx)

#else
#define XXT_RETAIN(xx)           [xx retain]
#define XXT_RELEASE(xx)          [xx release], xx = nil
#define XXT_AUTORELEASE(xx)      [xx autorelease]
#define XXT_DEALLOC(xx)          [xx dealloc]
#endif

#ifdef __IPHONE_6_0
# define UILineBreakModeWordWrap  NSLineBreakByWordWrapping
# define UITextAlignmentCenter    NSTextAlignmentCenter
#else
# define UILineBreakModeWordWrap  UILineBreakModeWordWrap
# define UITextAlignmentCenter    UITextAlignmentCenter
#endif


/*
 class XXTSegmentItem
*/
#pragma mark XXTSegmentItem
@class XXTSegmentItem;
@protocol XXTSegmentItemDelegate <NSObject>
- (void)didTapOnItem:(XXTSegmentItem*)item;
@end
@interface XXTSegmentItem : UIView
{
    UIImageView *gripImgView;
    UIImageView *backgroundImgView;
    UIImageView *sepratorLine;
    UILabel *titleLabel;
    
    NSInteger index;
}
@property (nonatomic,retain)UIImageView *sepratorLine;
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic)NSInteger index;
@property (nonatomic,assign)id<XXTSegmentItemDelegate> delegate;
@property (nonatomic,retain)UIImageView *backgroundImgView;

- (id)initWithFrame:(CGRect)frame withSepratorLine:(NSString*)sepImageName withTitle:(NSString*)title isLastRightItem:(BOOL)state withBackgroundImage:(NSString*)bgImageName withNomalTitleColor:(UIColor *)nomalColor wihtSelectedTitleColor:(UIColor *)selectedColor;

- (void)switchToSelected;
- (void)switchToNormal;

@end

/*
 class XXTSegmentControl
 */
#pragma mark XXTSegmentControl


@class XXTSegmentControl;
@protocol XXTSegmentControlDataSource <NSObject>

@optional
//me
//每一项得宽度是多少
- (CGFloat)segmentControl:(XXTSegmentControl*)sgmCtrl widthForItemAtIndex:(NSInteger)index;


///////////
@required
//菜单里面有多少项
- (NSInteger)numberOfItemsInSegmentControl:(XXTSegmentControl*)sgmCtrl;


//对应索引项得标题是什么
- (NSString*)segmentControl:(XXTSegmentControl*)sgmCtrl titleForItemAtIndex:(NSInteger)index;

//菜单选中了哪一项
- (void)segmentControl:(XXTSegmentControl*)sgmCtrl didSelectAtIndex:(NSInteger)index;
@end

@interface XXTSegmentControl : UIView<XXTSegmentItemDelegate,UIScrollViewDelegate>

@property (nonatomic,assign)id<XXTSegmentControlDataSource> dataSource;

@property (nonatomic,retain)UIView *leftTagView;
@property (nonatomic,retain)UIView *rightTagView;

@property (nonatomic,retain)UIFont *titleFont;

@property (nonatomic,retain)NSString *itemBackgroundImage;
@property (nonatomic,retain)NSString *selectedLineActiveImage;
@property (nonatomic,retain)NSString *selectedItemBgImage;

@property (nonatomic,retain)NSString *gripUnSelectedImage;

/*
设置左右视图的宽度 
*/
@property (nonatomic,assign)CGFloat leftViewWidth;
@property (nonatomic,assign)CGFloat rightViewWidth;
@property (nonatomic,assign)BOOL hideSideViewWhenScroll;

//使用这个方法初始化这个控件
- (id)initWithFrame      :   (CGRect)frame
     withDataSource      :   (id<XXTSegmentControlDataSource>)mDataSource
withSepratorLineImageName:   (NSString *)sepratorImage
withBackgroundImageName  :   (NSString*)backImage
withTitleNomalColor      :   (UIColor *)nomalColor
withTitleSelectdColor     :   (UIColor *)selectdColor;
//使用这个初始化，配置统一的UI
- (id)initWithFrame:(CGRect)frame withDataSource:(id<XXTSegmentControlDataSource>)mDataSource;
//获取item
- (XXTSegmentItem*)itemForIndex:(NSInteger)index;
//重新载入控件数据
- (void)reloadData;
@end
