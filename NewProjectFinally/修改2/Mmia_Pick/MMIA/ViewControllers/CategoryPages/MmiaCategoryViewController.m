//
//  MmiaCategoryViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-25.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaCategoryViewController.h"
#import "MmiaCategoryListViewController.h"
#import "MmiaCategoryModel.h"
#import "CategoryWaterfallCell.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface MmiaCategoryViewController () <CHTCollectionViewDelegateWaterfallLayout>

@property (strong, nonatomic) NSMutableArray *dataArray;

- (void)getCategroyDataForRequest;
- (void)configCategoryViewBackground;

@end

@implementation MmiaCategoryViewController

#pragma mark - init

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if( self = [super initWithCollectionViewLayout:layout] )
    {        
        [self.collectionView registerNib:UINibWithName(@"CategoryWaterfallCell") forCellWithReuseIdentifier:CategoryWaterCellIdentifier];
        
        self.collectionView.alwaysBounceVertical = YES;
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *delegate = [AppDelegate sharedAppDelegate];
    [delegate.tabBarViewController hideOrNotTabBar:NO];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(VIEW_OFFSET + kNavigationBarHeight);
        make.bottom.equalTo(self.view).offset(-45);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = ColorWithHexRGBA(0x000000, 0.3);
    self.dataArray = [[NSMutableArray alloc]init];
    
    [self configCategoryViewBackground];
    _isLoadding = YES;
    
    [self addRefreshHeader];
    [self getCategroyDataForRequest];
}

#pragma mark - Private

- (void)getCategroyDataForRequest
{
    MmiaBaseModel* model = [[MmiaBaseModel alloc] init];
    NSDictionary* infoDict = [model keyValues];
    
    [[MMiaNetworkEngine sharedInstance] startPostAsyncRequestWithUrl:MmiaCategoryURL param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if( ![responseDic[@"status"] intValue] )
        {
            if (_isRefresh)
            {
                [self.dataArray removeAllObjects];
            }
            
            MmiaCategoryModel* categoryModel = [MmiaCategoryModel objectWithKeyValues:responseDic];
            [self.dataArray addObjectsFromArray:categoryModel.categoryList];
            [self refreshPageData];
            
        }else
        {
            [self netWorkError:nil];
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        [self netWorkError:error];
    }];
}

#pragma mark - 网络请求处理

- (void)refreshPageData
{
    if ( _isLoadding )
    {
        _isLoadding = NO;
    }
    
    if ( _isRefresh )
    {
        [self.collectionView.header endRefreshing];
        _isRefresh = NO;
    }
     [self.collectionView reloadData];
}

//网络出错
- (void)netWorkError:(NSError *)error
{
    if ( _isLoadding )
    {
        _isLoadding = NO;
    }
    
    if ( _isRefresh )
    {
        [self.collectionView.header endRefreshing];
        _isRefresh = NO;
        
    }
}


- (void)addHeaderRequestRefreshData
{
    [self getCategroyDataForRequest];
}

- (void)configCategoryViewBackground
{
    // init navigationView
     self.navigationView.backgroundColor = [ColorWithHexRGB(0x000000) colorWithAlphaComponent:0.2];
    self.rightLabel.text = @"分类";
    
    // init self.view background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bg_icon.png"]];
    UIView* backgroundAlphaView = UIView.new;
    backgroundAlphaView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [self.view insertSubview:backgroundAlphaView belowSubview:self.collectionView];
    
    [backgroundAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(VIEW_OFFSET + kNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryWaterfallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryWaterCellIdentifier forIndexPath:indexPath];
    
    MmiaCategoryListModel* item = self.dataArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:NSURLWithString(item.logo) placeholderImage:nil];
    cell.displayLabel.text = item.name;
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(80, 80);
    
    return size;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHTCollectionViewWaterfallLayout* layout = [[CHTCollectionViewWaterfallLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(KHomeCollectionViewMargin, KHomeCollectionViewMargin, KHomeCollectionViewMargin, KHomeCollectionViewMargin);
    layout.columnCount = 2;
    layout.minimumColumnSpacing = KHomeCollectionViewCell_Spacing;
    layout.minimumInteritemSpacing = KHomeCollectionViewCell_Spacing;
    
    MmiaCategoryListViewController *listVC = [[MmiaCategoryListViewController alloc]initWithCollectionViewLayout:layout Model:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
