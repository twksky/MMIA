//
//  MMiaDetailViewController.h
//  MMIA
//
//  Created by MMIA-Mac on 14-7-10.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMiaBaseViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface MMiaDetailViewController : MMiaBaseViewController<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray* detailImages;   // 杂志主页图片数据

- (id)initWithTitle:(NSString*)titleName channelId:(NSInteger)channelId;
// 获取杂志主页图片数据
- (void)getMagazineDetailDataForRequest;
- (void)getDetailContentDataForRequest;
- (void)addRefreshFooter;
- (void)removeRefreshFooter;

@end