//
//  MmiaSearchListViewController.m
//  MMIA
//
//  Created by lixiao on 15/6/29.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaSearchListViewController.h"
#import "MmiaProductDetailViewController.h"
#import "MmiaBrandViewController.h"
#import "HomeCollectionViewCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaDetailSearchRequestModel.h"
#import "MmiaPublicResponseModel.h"
#import "MmiaPaperResponseModel.h"
#import "MJRefresh.h"

@interface MmiaSearchListViewController ()<CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource>{
    NSString  *_keyWord;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MmiaSearchListViewController

#pragma mark - Init

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout KeyWord:(NSString *)keyWord
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        _keyWord = keyWord;
        _dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - LifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerNib:UINibWithName(@"HomeCollectionViewCell") forCellWithReuseIdentifier:HomeCollectionViewCellIdentifier];
    
    [self addHeaderAndFooter];
    [self creatNavigationBar];
    _isLoadding = YES;
    [self getSearchByKeyWordWithStart:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate = [AppDelegate sharedAppDelegate];
    [delegate.tabBarViewController hideOrNotTabBar:YES];
    
    self.collectionView.frame = CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, App_Frame_Width,self.view.height - VIEW_OFFSET - kNavigationBarHeight);
}

#pragma mark - Private
#pragma mark -LoadUI

- (void)creatNavigationBar
{
    [self addBackBtnWithTarget:self selector:@selector(doClick:)];
    UIButton *backButton = (UIButton *)[self.naviBarView viewWithTag:1001];
    
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = [UIColor clearColor];
    [self.naviBarView addSubview:searchView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doClick:)];
    [searchView addGestureRecognizer:tap];
    
    UILabel *searchLabel = [[UILabel alloc]init];
    searchLabel.backgroundColor = [UIColor clearColor];
    searchLabel.text = _keyWord;
    searchLabel.font = UIFontSystem(20);
    searchLabel.textColor = ColorWithHexRGB(0x999999);
    [searchView addSubview:searchLabel];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = ColorWithHexRGB(0x777777);
    [searchView addSubview:lineLabel];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    UIImage *searchImage = [UIImage imageNamed:@"search_icon.png"];
    imageView.image = searchImage;
    [searchView addSubview:imageView];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(backButton.mas_right);
        make.top.equalTo(self.naviBarView).offset(6.5f);
        make.bottom.equalTo(self.naviBarView).offset(-6.5f);
        make.right.equalTo(self.naviBarView).offset(-15.0f);
        
    }];
    
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(searchView).offset(10);
        make.right.equalTo(imageView.mas_left).offset(-6.0);
        make.top.equalTo(searchView).offset(0.5);
        make.bottom.equalTo(lineLabel.mas_top);
    }];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(searchView);
        make.left.right.equalTo(searchView);
        make.height.equalTo(@0.5);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(searchImage.size.width, searchImage.size.height));
        make.centerY.mas_equalTo(searchLabel);
        make.right.equalTo(searchView).offset(-6.0f);
        
    }];
}

#pragma mark -Action

- (void)doClick:(id *)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -Request

- (void)getSearchByKeyWordWithStart:(NSInteger)start
{
    MmiaDetailSearchRequestModel *model = [[MmiaDetailSearchRequestModel alloc]init];
    model.keyword = _keyWord;
    model.start = start;
    model.size = Request_Size;
    NSDictionary *infoDict = [model keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_SearchByKeyWord param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if( ![responseDic[@"status"] intValue] )
        {
            if (_isRefresh)
            {
                [self.dataArray removeAllObjects];
            }
            MmiaPaperResponseModel *dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
            [self.dataArray addObjectsFromArray:dataModel.searchList];
            _everyDownNum = dataModel.searchList.count;
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

#pragma mark - Public
#pragma mark -网络请求处理

- (void)addHeaderRequestRefreshData
{
    [self getSearchByKeyWordWithStart:0];
}

- (void)addFooterRequestMoreData
{
    [self getSearchByKeyWordWithStart:self.dataArray.count];
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

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((App_Frame_Width - 2 * KHomeCollectionViewMargin - KHomeCollectionViewCell_Spacing)/2.0, KHomeCollectionViewCell_Height);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
