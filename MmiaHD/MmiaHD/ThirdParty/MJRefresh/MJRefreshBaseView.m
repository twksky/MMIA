//
//  MJRefreshBaseView.m
//  MJRefresh
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJRefreshBaseView.h"
#import "MJRefreshConst.h"
#import "UIView+Extension.h"
#import "UIScrollView+Extension.h"
#import <objc/message.h>

@interface  MJRefreshBaseView()
{
    __weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
    __weak UIImageView *_activityView;
}
@end

@implementation MJRefreshBaseView
#pragma mark - 控件初始化
/**
 *  状态标签
 */
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:13];
        statusLabel.textColor = MJRefreshLabelTextColor;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_statusLabel = statusLabel];
    }
    return _statusLabel;
}

/**
 *  箭头图片
 */
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_logo.png"]];//MJRefreshSrcName(@"arrow.png")
        arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        arrowImage.backgroundColor = [UIColor whiteColor];
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

/**
 *  状态标签
 */
- (UIImageView *)activityView
{
    if (!_activityView) {
        UIImageView *activityView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loading.png"]];
        activityView.clipsToBounds = YES;
        activityView.autoresizingMask = self.arrowImage.autoresizingMask;
        [self addSubview:_activityView = activityView];
        
    }
    return _activityView;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = MJRefreshViewHeight;
    if (self = [super initWithFrame:frame]) {
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 2.设置默认状态
        self.state = MJRefreshStateNormal;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.箭头
    CGFloat arrowX = self.width * 0.5;
    CGFloat arrowY = CGRectGetMinY(self.bounds) + self.arrowImage.image.size.height / 2 + 3;
    self.arrowImage.center = CGPointMake(arrowX, arrowY);
    
    // 2.指示器
    CGFloat loadX = CGRectGetMinX(self.arrowImage.frame) - self.activityView.image.size.width / 2;
    CGFloat loadY = CGRectGetMaxY(self.arrowImage.frame) + (self.height - CGRectGetMaxY(self.arrowImage.frame)) / 2;
    self.activityView.center = CGPointMake(loadX, loadY);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:MJRefreshContentOffset context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:MJRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        // 设置宽度
        self.width = newSuperview.width;
        // 设置位置
        self.x = 0;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

#pragma mark - 显示到屏幕上
- (void)drawRect:(CGRect)rect
{
    if (self.state == MJRefreshStateWillRefreshing) {
        self.state = MJRefreshStateRefreshing;
    }
}

#pragma mark - 刷新相关
#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return MJRefreshStateRefreshing == self.state;
}

#pragma mark 开始刷新
- (void)beginRefreshing
{
    if (self.window) {
        self.state = MJRefreshStateRefreshing;
    } else {
        // 不能调用set方法
        _state = MJRefreshStateWillRefreshing;
        [super setNeedsDisplay];
    }
}

#pragma mark 结束刷新
- (void)endRefreshing
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = MJRefreshStateNormal;
    });
}

#pragma mark - 设置状态
- (void)setState:(MJRefreshState)state
{
    // 0.存储当前的contentInset
    if (self.state != MJRefreshStateRefreshing) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    // 1.一样的就直接返回
    if (self.state == state) return;
    
    // 2.根据状态执行不同的操作
    switch (state) {
		case MJRefreshStateNormal: // 普通状态
        {
            // 显示箭头
            self.arrowImage.hidden = NO;
            
            // 停止转圈圈
            [ self.activityView.layer removeAllAnimations];
			break;
        }
            
        case MJRefreshStatePulling:
            break;
            
		case MJRefreshStateRefreshing:
        {
            // 开始转圈圈
            CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
            monkeyAnimation.duration = 1.5f;
            monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            monkeyAnimation.cumulative = NO;
            monkeyAnimation.removedOnCompletion = YES; //完成后是否回到原来状态，如果为NO 就是停留在动画结束时的状态
            monkeyAnimation.repeatCount = FLT_MAX;
            [ self.activityView.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
            
            // 隐藏箭头
			self.arrowImage.hidden = NO;
            
            // 回调
            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
                objc_msgSend(self.beginRefreshingTaget, self.beginRefreshingAction, self);
            }
            
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
			break;
        }
        default:
            break;
	}
    
    // 3.存储状态
    _state = state;
}
@end