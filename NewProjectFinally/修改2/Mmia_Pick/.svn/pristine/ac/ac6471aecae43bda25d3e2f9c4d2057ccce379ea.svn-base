//
//  MmiaMainViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-15.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaMainViewController.h"
#import "MmiaHomePageModel.h"
#import "MmiaHomeRecomRequestModel.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "HomeCollectionViewCell.h"
#import "HomeCollectionViewBigCell.h"

#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaBrandViewController.h"
#import "MmiaProductDetailViewController.h"


CGFloat const KBannerHeight = 155.0f;
NSString* const KHomeCollectionViewHeader = @"adboardView";

@interface MmiaMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) MmiaAdboardView*   adboardView;
@property (nonatomic, strong) MmiaHomePageModel* homeModel;

- (void)getHomePageDataForRequest;
- (void)layoutSubviews;
- (void)addNavigationBarItem;
- (void)refreshAdboardView:(NSArray *)data;

@end

@implementation MmiaMainViewController

#pragma mark - init

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        [self.collectionView registerNib:UINibWithName(@"HomeCollectionViewBigCell") forCellWithReuseIdentifier:HomeCollectionViewBigCellIdentifier];
        [self.collectionView registerNib:UINibWithName(@"HomeCollectionViewCell") forCellWithReuseIdentifier:HomeCollectionViewCellIdentifier];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:CollectionElementKindSectionHeader withReuseIdentifier:KHomeCollectionViewHeader];
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.clipsToBounds = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    self.collectionView.frame = CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, self.view.width, self.view.height - VIEW_OFFSET - kNavigationBarHeight - 45);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AppDelegate sharedAppDelegate].tabBarViewController hideOrNotTabBar:NO];
    [self layoutSubviews];
    [self.adboardView startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.adboardView stopTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorWithHexRGB(0xcccccc);
    [self addNavigationBarItem];
    
    [self getHomePageDataForRequest];
}

#pragma mark - **请求数据

- (void)getHomePageDataForRequest
{
    MmiaBaseModel* model = [[MmiaBaseModel alloc] init];
    NSDictionary* infoDict = [model keyValues];
    
    [[MMiaNetworkEngine sharedInstance] startPostAsyncRequestWithUrl:MmiaHomePageURL param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if( ![responseDic[@"status"] intValue] )
        {
            NSLog( @"res = %@", responseDic );
            self.homeModel = [MmiaHomePageModel objectWithKeyValues:responseDic];
            // banner
            [self refreshAdboardView:self.homeModel.bannerList];
            // recommendList
            [self refreshPageData];
        }
        else
        {
            // 错误处理
            [self netWorkError:nil];
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
        [self netWorkError:error];
    }];
}

#pragma mark **请求加载更多数据

- (void)getHomeRecommendListWithStart: (NSInteger)start
{
    MmiaHomeRecomRequestModel *model = [[MmiaHomeRecomRequestModel alloc]init];
    model.start = start;
    model.size = Request_Size;
    NSDictionary *infoDict = [model keyValues];
    
    [[MMiaNetworkEngine sharedInstance] startPostAsyncRequestWithUrl: MmiaHomeRecommendListURL param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if( ![responseDic[@"status"] intValue] )
        {
            MmiaHomePageModel* dataModel = [MmiaHomePageModel objectWithKeyValues:responseDic];
            self.homeModel.recommendList = [self.homeModel.recommendList arrayByAddingObjectsFromArray:dataModel.recommendList];
            // recommendList
            [self refreshPageData];
        }
        else
        {
            //错误处理
            [self netWorkError:nil];
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
        [self netWorkError:error];
    }];
}

#pragma mark - Accessors

- (MmiaAdboardView *)adboardView
{
    if( !_adboardView )
    {
        _adboardView = [[MmiaAdboardView alloc] initWithFrame:CGRectMake(KHomeCollectionViewMargin, KHomeCollectionViewMargin, self.view.width - 2 * KHomeCollectionViewMargin, KBannerHeight)];
        _adboardView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
    }
    return _adboardView;
}

#pragma mark - Private

- (void)addNavigationBarItem
{
    self.navigationView.backgroundColor = ColorWithHexRGB(0xefefef);
    
    UIImage* image = UIImageNamed(@"mmia_icon.png");
    UIImageView* logoImageView = UIImageViewImage(image);
    logoImageView.contentMode = UIViewContentModeCenter;
    [self.naviBarView addSubview:logoImageView];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.naviBarView);
        make.size.mas_equalTo(image.size);
    }];
}

- (void)refreshAdboardView:(NSArray *)dataArray
{
    NSMutableArray* bannerArray = [@[] mutableCopy];
    for( MmiaHomeProductListModelModel* model in dataArray )
    {
        HomeCollectionViewBigCell* imageView = [HomeCollectionViewBigCell viewFromXIB];
        [imageView reloadCellWithModel:model];
        [bannerArray addObject:imageView];
    }
    
    WeakSelf(weakSelf);
    self.adboardView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return bannerArray[pageIndex];
    };
    self.adboardView.totalPageCount = bannerArray.count;
    self.adboardView.TapActionBlock = ^(NSInteger pageIndex){
        
        MmiaHomeProductListModelModel* item = weakSelf.homeModel.bannerList[pageIndex];
        [weakSelf pushViewControllerWithSourceId:item.sourceId type:item.type];
    };
}

#pragma mark - 响应事件

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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.homeModel.recommendList.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if( [kind isEqualToString:CollectionElementKindSectionHeader] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:KHomeCollectionViewHeader forIndexPath:indexPath];
        [reusableView addSubview:self.adboardView];
    }
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaHomeProductListModelModel* model;
    
    if( indexPath.row == 4 || indexPath.row == 11 )
    {
        HomeCollectionViewBigCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCollectionViewBigCellIdentifier forIndexPath:indexPath];
        
        model = self.homeModel.recommendList[indexPath.row];
        [cell reloadCellWithModel:model];
        
        return cell;
    }
    else
    {
        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCollectionViewCellIdentifier forIndexPath:indexPath];
        
        model = self.homeModel.recommendList[indexPath.row];
        [cell reloadCellWithModel:model];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.width, KBannerHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 4 || indexPath.row == 11 )
    {
        return CGSizeMake(collectionView.width - 2 * KHomeCollectionViewMargin, KBannerHeight);
    }
    else
    {
        return CGSizeMake((collectionView.width - 2 * KHomeCollectionViewMargin - KHomeCollectionViewCell_Spacing)/2.0, KHomeCollectionViewCell_Height);
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaHomeProductListModelModel* item = self.homeModel.recommendList[indexPath.row];
    [self pushViewControllerWithSourceId:item.sourceId type:item.type];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog( @"offsetY = %f", offsetY );
    
    if( offsetY < 0 )
    {
        [self.navigationView mas_remakeConstraints:^(MASConstraintMaker *make){
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(VIEW_OFFSET + kNavigationBarHeight));
        }];
    }
    else
    {
        [self.navigationView mas_remakeConstraints:^(MASConstraintMaker *make){
            
            make.top.equalTo(self.view.mas_top).offset(-offsetY);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(VIEW_OFFSET + kNavigationBarHeight));
        }];
    }
}

#pragma mark - 加载更多数据

- (void)addHeaderRequestRefreshData
{
    [super addHeaderRequestRefreshData];
    
    [self getHomePageDataForRequest];
}

- (void)addFooterRequestMoreData
{
    [super addFooterRequestMoreData];
    
    [self getHomeRecommendListWithStart:self.homeModel.recommendList.count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
}

@end
