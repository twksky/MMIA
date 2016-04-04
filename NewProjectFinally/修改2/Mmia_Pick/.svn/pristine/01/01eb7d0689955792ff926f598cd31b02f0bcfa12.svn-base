//
//  MmiaBaseViewController.h
//  MMIA
//
//  Created by lixiao on 15/5/18.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "GlobalHeader.h"
#import "AdditionHeader.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface MmiaBaseViewController : UICollectionViewController{
    NSInteger  _everyDownNum;
        BOOL   _isLoadding;
        BOOL   _isRefresh;
}

//总navigationBar,高度 64/44
@property (nonatomic, strong) UIView *navigationView;
//状态栏
@property (nonatomic, strong) UIView *statusView;
//高度为44的navigationBar
@property (nonatomic, strong) UIView *naviBarView;
@property (nonatomic, strong) UILabel *lineLabel;
//右边label
@property (nonatomic, strong) UILabel *rightLabel;
//中间label
@property (nonatomic, strong) UILabel *titleLabel;

- (void)addBackBtnWithTarget:(id)target selector:(SEL)selector;
- (void)addRightBtnWithImage:(UIImage *)rightImage Target:(id)target selector:(SEL)selector;
//增加刷新的header和footer
- (void)addHeaderAndFooter;
- (void)addRefreshHeader;
- (void)addRefreshFooter;
//下拉时刷新数据
- (void)addHeaderRequestRefreshData;
//上拉加载更多
- (void)addFooterRequestMoreData;
//请求完刷新数据
- (void)refreshPageData;
//网络出错
- (void)netWorkError:(NSError *)error;


@end
