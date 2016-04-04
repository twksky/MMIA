//
//  MmiaCategoryListViewController.m
//  MMIA
//
//  Created by lixiao on 15/6/29.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaCategoryListViewController.h"
#import "MmiaProductDetailViewController.h"
#import "MmiaBrandViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaDetailCategoryRequestModel.h"
#import "MmiaPublicResponseModel.h"
#import "MmiaPaperResponseModel.h"
#import "HomeCollectionViewCell.h"
#import "MJRefresh.h"

@interface MmiaCategoryListViewController ()<CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource>
{
    MmiaCategoryListModel  *_categoryListModel;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MmiaCategoryListViewController

#pragma mark - init

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout Model:(MmiaCategoryListModel *)model
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        _categoryListModel = model;
        _dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - LifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = _categoryListModel.name;
    
    [self.collectionView registerNib:UINibWithName(@"HomeCollectionViewCell") forCellWithReuseIdentifier:HomeCollectionViewCellIdentifier];
    
    [self addBackBtnWithTarget:self selector:@selector(buttonClick:)];
    _isLoadding = YES;
    [self addHeaderAndFooter];
    [self getProductListByCatrgoryIdWithStart:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate = [AppDelegate sharedAppDelegate];
    [delegate.tabBarViewController hideOrNotTabBar:YES];
    
     self.collectionView.frame = CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, App_Frame_Width,self.view.height - VIEW_OFFSET - kNavigationBarHeight);
}

#pragma mark - Private
#pragma mark -Request

- (void)getProductListByCatrgoryIdWithStart:(NSInteger)start
{
    MmiaDetailCategoryRequestModel *requestModel = [[MmiaDetailCategoryRequestModel alloc]init];
    requestModel.start = start;
    requestModel.size = Request_Size;
    requestModel.categoryId = _categoryListModel.categoryId;
    NSDictionary *infoDict = [requestModel keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_ProductListByCategoryId param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if (![responseDic[@"status"] intValue])
        {
            if (_isRefresh)
            {
                [self.dataArray removeAllObjects];
            }
            
             MmiaPaperResponseModel* dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
            [self.dataArray addObjectsFromArray:dataModel.productList];
            _everyDownNum = dataModel.productList.count;
            [self refreshPageData];
            
        }else
        {
             [self netWorkError:nil];
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error)
    {
        [self netWorkError:error];
        
    }];
}

#pragma mark -Action

- (void)buttonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -响应事件

- (void)pushViewControllerWithSourceId:(NSInteger)sourceId type:(NSInteger)type
{
    // 根据type类型选择跳转的页面
    if( type == 0 )
    {
        // 进入单品详情页
        CHTCollectionViewWaterfallLayout* detailLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        MmiaProductDetailViewController* detailViewController = [[MmiaProductDetailViewController alloc] initWithCollectionViewLayout:detailLayout];
        detailViewController.spId = sourceId;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if( type == 1 )
    {
        // 进入品牌列表页
        MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
        MmiaBrandViewController* brandViewController = [[MmiaBrandViewController alloc] initWithCollectionViewLayout:smallLayout];
        brandViewController.brandId = sourceId;;
        [self.navigationController pushViewController:brandViewController animated:YES];
    }
}

#pragma mark - Public
#pragma mark -网络请求处理

- (void)addHeaderRequestRefreshData
{
    [self getProductListByCatrgoryIdWithStart:0];
}

- (void)addFooterRequestMoreData
{
    [self getProductListByCatrgoryIdWithStart:self.dataArray.count];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCollectionViewCellIdentifier forIndexPath:indexPath];

    [cell reloadCellWithModel:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaPaperProductListModel *detailModel = [self.dataArray objectAtIndex:indexPath.row];
    if (detailModel.type == 0)
    {
        [self pushViewControllerWithSourceId:detailModel.spId type:detailModel.type];
        
    }else if (detailModel.type == 1)
    {
        [self pushViewControllerWithSourceId:detailModel.brandId type:detailModel.type];
    }
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return CGSizeMake((App_Frame_Width - 2 * KHomeCollectionViewMargin - KHomeCollectionViewCell_Spacing)/2.0, KHomeCollectionViewCell_Height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
