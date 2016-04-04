//
//  XXTSegmentControl.m
//  mySegmentControl
//
//  Created by Vivian's Office MAC on 14-5-7.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "XXTSegmentControl.h"


#define TITLE_FONT [UIFont systemFontOfSize:12]


/*

 implementation XXTSegmentItem

 */
#define sepImageWidth 0

@implementation XXTSegmentItem
{
    UIColor *_nomalTitleColor;
    UIColor *_selectedTitleColor;
}
@synthesize titleLabel,sepratorLine;
@synthesize index;
@synthesize delegate;
@synthesize backgroundImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    XXT_RELEASE(self.titleLabel);
    XXT_RELEASE(self.sepratorLine);
    XXT_RELEASE(self.backgroundImgView);
#if !XXT_ARC_ENABLED
    [super dealloc];
#endif
}

- (void)tapOnSelf:(UITapGestureRecognizer*)tapR
{
    NSLog(@"tapOnSelf  %@",tapR.view);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOnItem:)]) {
        [self.delegate didTapOnItem:self];
    }
}

- (void)switchToNormal
{
    self.titleLabel.textColor = _nomalTitleColor?_nomalTitleColor:[UIColor blackColor];
}
- (void)switchToSelected
{
    self.titleLabel.textColor = _selectedTitleColor?_selectedTitleColor:[UIColor colorWithRed:0.0/255.0 green:66.0/255.0 blue:94.0/255.0 alpha:1];
}

- (id)initWithFrame:(CGRect)frame withSepratorLine:(NSString *)sepImageName withTitle:(NSString *)title isLastRightItem:(BOOL)state withBackgroundImage:(NSString *)bgImageName withNomalTitleColor:(UIColor *)nomalColor wihtSelectedTitleColor:(UIColor *)selectedColor
{
    if (self = [super initWithFrame:frame]) {
        
        //set backgroundImageView
        if (bgImageName) {
            NSString *bgImagePath = [[NSBundle mainBundle] pathForResource:[[bgImageName componentsSeparatedByString:@".png"] objectAtIndex:0] ofType:@"png"];
            UIImage *bgImage = [UIImage imageWithContentsOfFile:bgImagePath];
            if (bgImage) {
                self.backgroundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
                self.backgroundImgView.image = bgImage;
                [self addSubview:self.backgroundImgView];
            }

        }
        //set title
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,frame.size.width-sepImageWidth,frame.size.height)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.font = TITLE_FONT;
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
        self.titleLabel.textColor = nomalColor;
        _nomalTitleColor = nomalColor;
        _selectedTitleColor = selectedColor;
        
        
        if (!state) {
            //set line
            if (sepImageName) {
            NSString *sepImagePath = [[NSBundle mainBundle] pathForResource:[[sepImageName componentsSeparatedByString:@".png"] objectAtIndex:0] ofType:@"png"];
            UIImage *sepImage = [UIImage imageWithContentsOfFile:sepImagePath];
            if (sepImage) {
                self.sepratorLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.titleLabel.frame.size.width,0,sepImageWidth,frame.size.height)];
                self.sepratorLine.image = sepImage;
                [self addSubview:self.sepratorLine];
            }
            }
        }
        
        //add tap gesture
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf:)];
        [self addGestureRecognizer:tapR];
        
        
    }
    return self;
}



@end

/*
 implementation XXTSegmentControl
*/

#define EACH_ITEM_WIDTH 60
#define LEFT_VIEW_WIDTH 20
#define RIGHT_VIEW_WIDTH 20

@interface XXTSegmentControl ()
- (void)selectedImgViewShouldMoveToIndex:(NSInteger)index;
- (void)setLeftTagViewHidden:(BOOL)state;
- (void)setRightTagViewHidden:(BOOL)state;
@end

@implementation XXTSegmentControl
{
    UIImageView *backgroundImageView;
    NSInteger _allItemsCount;
    
    UIScrollView *backScrollView;
    UIImageView *_selectedImgView;
    NSInteger lastSelectedIndex;
    NSInteger selectedIndex;
    CGFloat itemWidth;
    NSString *_sepratorLineImageName;
    UIColor *_nomalColor;
    UIColor *_selectedColor;
    
}
@synthesize dataSource = _dataSource;
@synthesize leftTagView = _leftTagView,rightTagView = _rightTagView,leftViewWidth =_leftViewWidth,rightViewWidth = _rightViewWidth;
@synthesize titleFont = _titleFont;
@synthesize selectedItemBgImage = _selectedItemBgImage;
@synthesize itemBackgroundImage = _itemBackgroundImage;
@synthesize selectedLineActiveImage = _selectedLineActiveImage,gripUnSelectedImage;

- (void)dealloc
{
    self.titleFont = nil;
    _sepratorLineImageName = nil;
    self.itemBackgroundImage = nil;
    self.gripUnSelectedImage = nil;
#if !XXT_ARC_ENABLED
    [super dealloc];
#endif
}
////////////////
/*   
setter 方法
*/
- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont) {
        XXT_RELEASE(_titleFont);
    }
    _titleFont = XXT_RETAIN(titleFont);
    [self setItemsTitleFont];
}
- (UIFont *)titleFont
{
    return _titleFont;
}
- (void)setLeftViewWidth:(CGFloat)leftViewWidth
{
    _leftViewWidth = leftViewWidth;
    if (!self.leftTagView) {
        return;
    }
    CGRect frame = self.leftTagView.frame;
    frame.size.width = leftViewWidth;
    self.leftTagView.frame = frame;
    
    backScrollView.frame = CGRectMake(leftViewWidth, 0, self.frame.size.width-self.rightViewWidth-leftViewWidth, self.frame.size.height);
}
- (CGFloat)leftViewWidth
{
    return _leftViewWidth;
}
- (void)setLeftTagView:(UIImageView *)leftTagView
{
    if (_leftTagView) {
        [_leftTagView removeFromSuperview];
        XXT_RELEASE(_leftTagView);
    }
    _leftTagView = XXT_RETAIN(leftTagView);
    [self setLeftViewWidth:_leftViewWidth];
    [self addSubview:_leftTagView];
}
- (UIView *)leftTagView
{
    return _leftTagView;
}
- (void)setRightViewWidth:(CGFloat)rightViewWidth
{
    _rightViewWidth = rightViewWidth;
    if (!self.rightTagView) {
        return;
    }
    CGRect frame = self.rightTagView.frame;
    frame.size.width = rightViewWidth;
    frame.origin.x = self.frame.size.width-rightViewWidth;
    self.rightTagView.frame = frame;
    
    backScrollView.frame = CGRectMake(self.leftViewWidth, 0, self.frame.size.width-rightViewWidth-self.leftViewWidth, self.frame.size.height);
}
- (CGFloat)rightViewWidth
{
    return _rightViewWidth;
}
- (void)setRightTagView:(UIView *)rightTagView
{
    if (_rightTagView) {
        [_rightTagView removeFromSuperview];
        XXT_RELEASE(_rightTagView);
    }
    _rightTagView = XXT_RETAIN(rightTagView);
    [self setRightViewWidth:_rightViewWidth];
    [self addSubview:_rightTagView];
}
- (UIView *)rightTagView
{
    return _rightTagView;
}

- (void)setSelectedLineActiveImage:(NSString *)selectedLineActiveImage
{
    
    _selectedLineActiveImage = selectedLineActiveImage;
    //set selectImageView default on the first
    if (_selectedImgView==nil) {
        _selectedImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-2,30,2)];
        if (selectedLineActiveImage&&selectedLineActiveImage.length!=0) {
            _selectedImgView.image =[UIImage imageNamed:selectedLineActiveImage];
        }
        [backScrollView addSubview:_selectedImgView];
    }else {
        if (selectedLineActiveImage&&selectedLineActiveImage.length!=0) {
            _selectedImgView.image =[UIImage imageNamed:selectedLineActiveImage];
        }
        XXTSegmentItem *item = [self itemForIndex:selectedIndex];
        [backScrollView scrollRectToVisible:item.frame animated:YES];
        [backScrollView bringSubviewToFront:_selectedImgView];
        [self selectedImgViewShouldMoveToIndex:selectedIndex];
    }
}
- (NSString *)selectedLineActiveImage
{
    return _selectedLineActiveImage;
}

////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
计算item的frame
*/

- (NSArray *)segmentItemSizeArrayWithItemsCount:(NSInteger)itemsCount
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<itemsCount; i++) {
        CGSize size = CGSizeMake(0, self.frame.size.height-10);
        if (self.dataSource &&[self.dataSource respondsToSelector:@selector(segmentControl:widthForItemAtIndex:)]) {
            size.width = [self.dataSource segmentControl:self widthForItemAtIndex:i];
            NSString *title = [self.dataSource segmentControl:self titleForItemAtIndex:i];
            CGSize titleSize = [title sizeWithFont:TITLE_FONT constrainedToSize:CGSizeMake(1000, self.frame.size.width-6) lineBreakMode:UILineBreakModeWordWrap];
            if (size.width<titleSize.width) {
                size.width = titleSize.width;
            }
        }
        if (size.width<EACH_ITEM_WIDTH) {
            size.width = EACH_ITEM_WIDTH;
        }
        [array addObject:NSStringFromCGSize(size)];
    }
    return array;
}
- (NSArray *)segmentItemFrameArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    if (_allItemsCount==0) {
        return nil;
    }else{
        CGRect frame = CGRectZero;
        NSArray *sizeArray = [self segmentItemSizeArrayWithItemsCount:_allItemsCount];
        CGFloat totalLength = 0.0f;//总长
        CGFloat offsetSpace = 0.0f;//间隔
        CGFloat originOfX = 0.0f;//起始位置

        for (int i= 0; i<sizeArray.count; i++) {
            CGSize size = CGSizeFromString([sizeArray objectAtIndex:i]);
            totalLength += size.width;
        }
        if (_allItemsCount==1) {
            //only one item
            originOfX = (backScrollView.frame.size.width-totalLength)/2.0f;
        }else if (_allItemsCount==2){
            //only tow item
            originOfX = offsetSpace = (backScrollView.frame.size.width-totalLength)/3;
        }else{
           //more than two
            if (totalLength<backScrollView.frame.size.width) {
                offsetSpace = (backScrollView.frame.size.width-totalLength)/(sizeArray.count-1);
            }
        }
        for (int i= 0; i<sizeArray.count; i++) {
            CGSize size = CGSizeFromString([sizeArray objectAtIndex:i]);
            frame = CGRectMake(originOfX, 3, size.width, size.height);
            originOfX += size.width+offsetSpace;
            [array addObject:NSStringFromCGRect(frame)];
        }
        return array;
    }
}
- (void)initSubViews
{
    
    if (self.dataSource == nil) {
        NSAssert(self.dataSource=nil,@"dataSource can't be nil");
    }
    
    _allItemsCount = 0;
    
    //begin init subview
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInSegmentControl:)]) {
        
        _allItemsCount = [self.dataSource numberOfItemsInSegmentControl:self];
        
    }else {
        NSAssert([self.dataSource respondsToSelector:@selector(numberOfItemsInSegmentControl:)] == NO,@"segment must can response datasource method ");
    }
    
    
    //set items
    CGFloat scrollTotalWidth = 0;
    NSArray *frameArray = [self segmentItemFrameArray];
    for (int i = 0; i < _allItemsCount; i++) {
        
        // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        //item width
        itemWidth = 0;
//        if (self.dataSource &&[self.dataSource respondsToSelector:@selector(segmentControl:widthForItemAtIndex:)]) {
//            itemWidth = [self.dataSource segmentControl:self widthForItemAtIndex:i];
//        }else
//            itemWidth = EACH_ITEM_WIDTH;
//        ////////////
//        CGRect itemFrame = CGRectMake(scrollTotalWidth,3,itemWidth,backScrollView.frame.size.height-6);
//        //set grip view under item
//        CGRect gripFrame = CGRectMake(scrollTotalWidth,self.frame.size.height*1/4-self.frame.size.height*1/15,itemWidth,self.frame.size.height*4/5);
//        UIImageView *gripImgView = [[UIImageView alloc]initWithFrame:gripFrame];
//        gripImgView.image = [UIImage imageNamed:self.gripUnSelectedImage];
//        gripImgView.tag = 9999+i;
//        [backScrollView addSubview:gripImgView];
        ////////
        
        CGRect itemFrame = CGRectFromString([frameArray objectAtIndex:i]);
        if (i==_allItemsCount-1) {
            scrollTotalWidth = itemFrame.origin.x+itemFrame.size.width;
        }
        
        NSString *title = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentControl:titleForItemAtIndex:)]) {
            title = [self.dataSource segmentControl:self titleForItemAtIndex:i];
        }else {
            title = @"";
        }
        
        XXTSegmentItem *item = nil;
        //区分左右是为了设置分割线
        if (i!=_allItemsCount-1 && i!=0) {
            //中间
            item = [[XXTSegmentItem alloc]initWithFrame:itemFrame withSepratorLine:_sepratorLineImageName withTitle:title isLastRightItem:NO withBackgroundImage:self.itemBackgroundImage withNomalTitleColor:_nomalColor wihtSelectedTitleColor:_selectedColor];
        }else if(i==0){
            //左边
            item = [[XXTSegmentItem alloc]initWithFrame:itemFrame withSepratorLine:_sepratorLineImageName withTitle:title isLastRightItem:YES withBackgroundImage:self.itemBackgroundImage withNomalTitleColor:_nomalColor wihtSelectedTitleColor:_selectedColor];
            
        }else if(i==_allItemsCount-1){
            //右边
            item = [[XXTSegmentItem alloc]initWithFrame:itemFrame withSepratorLine:_sepratorLineImageName withTitle:title isLastRightItem:YES withBackgroundImage:self.itemBackgroundImage withNomalTitleColor:_nomalColor wihtSelectedTitleColor:_selectedColor];
            
        }
        item.index = i;
        item.delegate = self;
        item.tag = 8888+i;
        item.titleLabel.font = _titleFont?_titleFont:TITLE_FONT;
        [backScrollView addSubview:item];
        //default selected 0
        if (i==0) {
            [item switchToSelected];
        }
        
        
    }
    
    //set backScroll content
    backScrollView.contentSize = CGSizeMake(scrollTotalWidth,self.frame.size.height*3/4);
    backScrollView.backgroundColor = [UIColor clearColor];
    
    //set default right tag
    if (backScrollView.contentSize.width > backScrollView.frame.size.width) {
        [self setRightTagViewHidden:NO];
    }
    
}

- (id)initWithFrame:(CGRect)frame withDataSource:(id<XXTSegmentControlDataSource>)mDataSource withSepratorLineImageName:(NSString *)sepratorImage withBackgroundImageName:(NSString *)backImage withTitleNomalColor:(UIColor *)nomalColor withTitleSelectdColor:(UIColor *)selectdColor
{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = mDataSource;
        _sepratorLineImageName = sepratorImage;
        self.hideSideViewWhenScroll = NO;
        _selectedColor = selectdColor;
        _nomalColor = nomalColor;
        //set backgroundImageView
        if (backImage&&backImage.length!=0) {
            backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
            backgroundImageView.image = [UIImage imageNamed:backImage];
            [self addSubview:backgroundImageView];
        }
        
        
        //set back scrollView
        backScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        backScrollView.backgroundColor = [UIColor clearColor];
        backScrollView.showsHorizontalScrollIndicator = NO;
        backScrollView.bounces = NO;
        backScrollView.delegate = self;
        [self addSubview:backScrollView];
        
        //设置左右视图宽度
        [self setLeftViewWidth:LEFT_VIEW_WIDTH];
        [self setRightViewWidth:RIGHT_VIEW_WIDTH];
        [self setSelectedLineActiveImage:_selectedLineActiveImage];
        //default
        
        //build subviews
        [self initSubViews];
        [self selectedImgViewShouldMoveToIndex:0];
        
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame withDataSource:(id<XXTSegmentControlDataSource>)mDataSource
{
    return [self initWithFrame:frame withDataSource:mDataSource withSepratorLineImageName:nil withBackgroundImageName:nil withTitleNomalColor:nil withTitleSelectdColor:nil];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - BFSegmentItemDelegate
- (void)didTapOnItem:(XXTSegmentItem *)item
{
    if (selectedIndex == item.index) {
        return;
    }
    //change grip
    lastSelectedIndex = selectedIndex;
    [self showTheHideItemWithLastSelectedIndex:selectedIndex newSelectedIndex:item.index];
    [self selectedImgViewShouldMoveToIndex:item.index];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentControl:didSelectAtIndex:)]) {
        [self.dataSource segmentControl:self didSelectAtIndex:item.index];
    }
    selectedIndex = item.index;
    XXTSegmentItem *lastItem = (XXTSegmentItem*)[backScrollView viewWithTag:8888+lastSelectedIndex];
    [lastItem switchToNormal];
    
}
- (void)showTheHideItemWithLastSelectedIndex:(NSInteger)lastIndex newSelectedIndex:(NSInteger)newIndex
{
    XXTSegmentItem *item = [self itemForIndex:newIndex];
    if (!CGRectContainsRect(backScrollView.frame, item.frame)) {
        [backScrollView scrollRectToVisible:item.frame animated:YES];
        return;
    }

    NSInteger hideIndex = 0;
    if (lastIndex<newIndex) {
        if (newIndex==_allItemsCount-1) {
            return;
        }
        hideIndex = newIndex+1;
    }else{
        if (newIndex==0) {
            return;
        }
        hideIndex = newIndex-1;
    }
    item = [self itemForIndex:hideIndex];
    [backScrollView scrollRectToVisible:item.frame animated:YES];

}
#pragma mark - selectedImgView move action
- (void)hiddenGripAfterAnimation
{
    //    UIImageView *unSelectedGripView = (UIImageView*)[backScrollView viewWithTag:9999+lastSelectedIndex];
    //    unSelectedGripView.image = gripUnSelectedImage;
    //
    //    UIImageView *selectedGripView = (UIImageView*)[backScrollView viewWithTag:9999+selectedIndex];
    //    selectedGripView.image = nil;
    
    XXTSegmentItem *selectItem = (XXTSegmentItem*)[backScrollView viewWithTag:8888+selectedIndex];
    
    [selectItem switchToSelected];
    
}
- (void)selectedImgViewShouldMoveToIndex:(NSInteger)index
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationDidStopSelector:@selector(hiddenGripAfterAnimation)];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    XXTSegmentItem *item = [self itemForIndex:index];
    _selectedImgView.frame = CGRectMake(item.frame.origin.x,self.frame.size.height-2,item.frame.size.width,2);
    [UIView commitAnimations];
    selectedIndex = index;
    
    
}

#pragma mark - reload data
- (void) reloadData
{
    //clear subviews
    for (UIView *subView in backScrollView.subviews) {
        if (subView == _selectedImgView) {
            continue;
        }
        [subView removeFromSuperview];
    }
    backScrollView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    
    [self initSubViews];
}

#pragma mark - scrollViewDelegate
- (void)setLeftTagViewHidden:(BOOL)state
{
    if (!self.leftTagView) {
        return;
    }
//    self.leftTagView.frame = CGRectMake(0,0,self.frame.size.width*1/9,self.frame.size.height*7/8);
    self.leftTagView.hidden = state;
}
- (void)setRightTagViewHidden:(BOOL)state
{
    if (!self.rightTagView) {
        return;
    }
//    self.rightTagView.frame = CGRectMake(self.frame.size.width-self.frame.size.width*1/9,0,self.frame.size.width*1/9,self.frame.size.height*7/8);
    self.rightTagView.hidden = state;
}
//decide if need hide left or right tag view,0.5 is a float value
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.hideSideViewWhenScroll) {
        return;
    }
    CGPoint offset = scrollView.contentOffset;
    if (offset.x == 0 && offset.x <= scrollView.frame.size.width+0.5 && scrollView.contentSize.width > scrollView.frame.size.width+0.5) {
        [self setLeftTagViewHidden:YES];
        [self setRightTagViewHidden:NO];
    }else if((scrollView.contentSize.width-offset.x) <= scrollView.frame.size.width+0.5){
        [self setRightTagViewHidden:YES];
        [self setLeftTagViewHidden:NO];
    }else if(scrollView.contentSize.width < scrollView.frame.size.width+0.5){
        [self setRightTagViewHidden:YES];
        [self setLeftTagViewHidden:YES];
    }else {
        [self setLeftTagViewHidden:NO];
        [self setRightTagViewHidden:NO];
    }
}

- (void)setItemsTitleFont
{
    for (UIView *subView in backScrollView.subviews) {
        if ([subView class]==[XXTSegmentItem class]) {
            ((XXTSegmentItem *)subView).titleLabel.font = _titleFont;
        }
    }
}
- (void)setItemBackgroundImage
{
    for (UIView *subView in backScrollView.subviews) {
        if ([subView class]==[XXTSegmentItem class]) {
            if (_itemBackgroundImage&&_itemBackgroundImage.length!=0)
                ((XXTSegmentItem *)subView).backgroundImgView.image = [UIImage imageNamed:_itemBackgroundImage];
        }
        [subView removeFromSuperview];
    }
}
- (XXTSegmentItem*)itemForIndex:(NSInteger)index
{
    return (XXTSegmentItem*)[backScrollView viewWithTag:8888+index];
}

@end
