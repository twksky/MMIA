//
//  MMiaSearchShopViewController.h
//  MMIA
//
//  Created by lixiao on 14-10-30.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//
//商家搜索页

#import "MMiaBaseViewController.h"
#import "MMiaNoDataView.h"
@class MMiaSearchShopViewController;
@protocol MMiaSearchShopViewControllerDelegate <NSObject>

-(void)searchShopScrollViewDidScroll;
-(void)viewController:(MMiaSearchShopViewController *)viewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
-(void)doLogin;

@end

@interface MMiaSearchShopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,assign)NSInteger userid;
@property(nonatomic,retain)NSMutableArray *shopArray;
@property(nonatomic,retain) NSString *shopKeyWord;
@property(nonatomic,retain)UITableView *tableView;
@property (nonatomic,assign) BOOL isLoadding;
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,retain) MMiaNoDataView *nodataView;
@property(nonatomic,assign)id <MMiaSearchShopViewControllerDelegate>delegate;

- (void)getShopDataByRequest:(NSInteger)start;
@end
