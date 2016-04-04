//
//  MMiaSearchGoodsViewController.h
//  MMIA
//
//  Created by lixiao on 14-10-30.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//
//商品搜索页
#import "MMiaBaseViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MMiaNoDataView.h"
@class MMiaSearchGoodsViewController;
@protocol MMiaSearchGoodsViewControllerDelegate <NSObject>

-(void)searchGoodsScrollViewDidScroll;
- (void)viewController:(MMiaSearchGoodsViewController *)viewController didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MMiaSearchGoodsViewController : UIViewController<UITextFieldDelegate,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray*   goodsDataArr;
@property (nonatomic,copy) NSString *goodsKeyWord;
@property (nonatomic,assign) BOOL isLoadding;
@property (nonatomic,retain) MMiaNoDataView *nodataView;
@property(nonatomic,assign)id <MMiaSearchGoodsViewControllerDelegate>delegate;

-(id)initWithUserid:(int)userid;
- (void)getGoodsDataByRequest:(NSInteger)start;
@end
