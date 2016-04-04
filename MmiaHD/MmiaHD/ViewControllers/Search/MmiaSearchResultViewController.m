//
//  MmiaSearchResultViewController.m
//  MmiaHD
//
//  Created by lixiao on 15/4/3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaSearchResultViewController.h"
#import "AppDelegate.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"
#import "MmiaSearchResultViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CollectionViewWaterfallCell.h"
#import "MmiaSearchWaterFallHeader.h"
#import "MmiaRecommendWaterFallHeader.h"
#import "UIViewController+StackViewController.h"
#import "MJRefresh.h"
#import "MmiaToast.h"
#import "MmiaDetailGoodsViewController.h"
#import "MmiaOtherPersonHomeViewController.h"
#import "MmiaDetailSpecialViewController.h"

static const CGFloat cellLabelHeight = 40.0;
static const CGFloat cellWidth = 180.0;

#define Header_Identifier          @"specialViewWaterfallHeader"
#define RecommendCell_Identifier   @"recommendCell"
#define RecommendCell_Width        (self.isPortrait?130.0:180.0)

@interface MmiaSearchResultViewController ()<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>{
    NSString    *_keyWord;
    NSInteger   _userId;
    BOOL        _isLoadding;
    UIButton   *_revertButton;
}

@property (nonatomic, retain) MmiaRecommendWaterFallHeader *recommendView;
@property (nonatomic, retain) NSMutableArray     *dataArr;
@property (nonatomic, retain) NSMutableArray     *shopArr;
@property (nonatomic, retain) NSMutableArray     *recommendArr;

@end

@implementation MmiaSearchResultViewController

#pragma mark - init

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.headerHeight = 165;
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.minimumInteritemSpacing = 20;
        layout.minimumColumnSpacing = 10;
        layout.columnCount = 3;
        
        _collectionView = [[UICollectionView alloc] initWithFrame: self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.clipsToBounds = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[CollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[MmiaSearchWaterFallHeader class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:Header_Identifier];
    }
    return _collectionView;
}

- (UICollectionView *)shopCollectionView
{
    if (!_shopCollectionView)
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.headerHeight = 165;
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.minimumInteritemSpacing = 20;
        layout.minimumColumnSpacing = 20;
        layout.columnCount = 4;
        
        _shopCollectionView = [[UICollectionView alloc] initWithFrame: self.view.bounds collectionViewLayout:layout];
        _shopCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _shopCollectionView.clipsToBounds = YES;
        _shopCollectionView.alwaysBounceVertical = YES;
        _shopCollectionView.dataSource = self;
        _shopCollectionView.delegate = self;
        _shopCollectionView.backgroundColor = [UIColor clearColor];
        [_shopCollectionView registerClass:[CollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_shopCollectionView registerClass:[MmiaSearchWaterFallHeader class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:Header_Identifier];
    }
    return _shopCollectionView;
}

- (UICollectionView *)recommendCollectionView
{
    if (!_recommendCollectionView)
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init];
        layout.minimumInteritemSpacing = 30;
        if (self.isPortrait)
        {
            layout.sectionInset = UIEdgeInsetsMake(0, 8, 30, 30);
            layout.columnCount = 1;
        }else
        {
            layout.sectionInset = UIEdgeInsetsMake(0, 14, 30, 14);
            layout.minimumColumnSpacing = 36;
            layout.columnCount = 2;
        }
        
        _recommendCollectionView = [[UICollectionView alloc]initWithFrame:self.anotherView.bounds collectionViewLayout:layout];
        _recommendCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _recommendCollectionView.alwaysBounceVertical = YES;
        _recommendCollectionView.clipsToBounds = YES;
        _recommendCollectionView.dataSource = self;
        _recommendCollectionView.delegate = self;
        _recommendCollectionView.backgroundColor = [UIColor clearColor];
        [_recommendCollectionView registerClass:[CollectionViewWaterfallCell class] forCellWithReuseIdentifier:RecommendCell_Identifier];
    }
    return _recommendCollectionView;
}

- (id)initWithKeyWord:(NSString *)keyWord UserId:(NSInteger)userId
{
    self = [super init];
    if (self)
    {
        _keyWord = keyWord;
        _userId = userId;
        _dataArr = [[NSMutableArray alloc]init];
        _shopArr = [[NSMutableArray alloc]init];
        _recommendArr = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - lifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.shopCollectionView];
    self.shopCollectionView.hidden = YES;
    [self.anotherView addSubview:self.recommendCollectionView];
    
    self.recommendView =[[MmiaRecommendWaterFallHeader alloc]init];
    self.recommendView.title = @"推荐专题";
    [self.anotherView addSubview:self.recommendView];
    
    _revertButton = [[UIButton alloc]init];
    _revertButton.layer.masksToBounds = YES;
    _revertButton.backgroundColor = ColorWithHexRGBA(0xffffff, 0.8);
    [_revertButton setTitle:@"商家" forState:UIControlStateNormal];
    [_revertButton setTitleColor:ColorWithHexRGB(0x4d4d4d) forState:UIControlStateNormal];
    [_revertButton.titleLabel setFont:UIFontSystem(30)];
    [_revertButton addTarget:self action:@selector(revertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_revertButton];
    
    _isLoadding = YES;
    
    [self getSearchProductAndShopWithStart:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _revertButton.frame = CGRectMake(self.contentView.width - 50 - 77, self.contentView.height - 50 - 77, 77, 77);
    _revertButton.layer.cornerRadius = 77/2.0;
    
    self.collectionView.frame = self.contentView.bounds;
    self.shopCollectionView.frame = self.contentView.bounds;
    
    self.recommendView.frame = CGRectMake(0, 0, self.anotherView.width, 45);
    self.recommendCollectionView.frame = CGRectMake(0, 0, self.anotherView.width, self.anotherView.height - 44);
    self.recommendCollectionView.contentInset = UIEdgeInsetsMake(self.recommendView.height, 0, 0, 0);
 }

#pragma mark - Request

//首次请求
- (void)getSearchProductAndShopWithStart:(NSInteger)start
{
     NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_userId], @"userid",[NSNumber numberWithInteger:start], @"start",[NSNumber numberWithInteger:Request_Data_Count], @"size", _keyWord, @"keyword",nil];
     AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_SearchAll_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]integerValue] == 0)
        {
            NSDictionary *dataDict = jsonDict[@"data"];
            NSArray *productArr = [dataDict objectForKey:@"product"];
            NSArray *shopArr = [dataDict objectForKey:@"shop"];
            NSArray *magezineArr = [dataDict objectForKey:@"magazine"];
            
            for (NSDictionary *productDict in productArr)
            {
                MagazineItem *item =[[MagazineItem alloc] init];
                item.aId = [[productDict objectForKey:@"id"] integerValue];
                item.pictureImageUrl = [productDict objectForKey:@"imgUrl"];
                item.titleText = [productDict objectForKey:@"imgTitle"];
                item.likeNum = [[productDict objectForKey:@"likeNum"] intValue];
                item.magazineId = [[productDict objectForKey:@"productId"] intValue];
                item.imageWidth = [[productDict objectForKey:@"width"] floatValue];
                item.imageHeight = [[productDict objectForKey:@"height"] floatValue];
                if( item.pictureImageUrl.length > 0 )
                {
                    [self.dataArr addObject:item];
                }
            }
             [self refreshDataWithDownNum:self.dataArr.count CollectionView:_collectionView];
            
            for (NSDictionary *shopDict in shopArr)
            {
                MagazineItem *item = [[MagazineItem alloc]init];
                item.aId = [[shopDict objectForKey:@"companyId"]integerValue];
                item.pictureImageUrl = [shopDict objectForKey:@"logo"];
                item.titleText = [shopDict objectForKey:@"companyName"];
                item.isAttention = [[shopDict objectForKey:@"isAttention"]integerValue];
                [self.shopArr addObject:item];
            }
            [self refreshDataWithDownNum:self.shopArr.count CollectionView:_shopCollectionView];
            
            for (NSDictionary *magezineDict in magezineArr)
            {
                 MagazineItem *item = [[MagazineItem alloc]init];
                item.imageWidth = [magezineDict[@"width"] integerValue];
                item.imageHeight = [magezineDict[@"height"] integerValue];
                item.titleText = magezineDict[@"title"];
                item.isAttention = [magezineDict[@"isAttention"] integerValue];
                item.pictureImageUrl = magezineDict[@"imgUrl"];
                item.aId = [magezineDict[@"id"] integerValue];
                item.userId = [magezineDict[@"userId"] integerValue];
                [self.recommendArr addObject:item];
            }
            [self.recommendCollectionView reloadData];
        }
        
    }errorHandler:^(NSError *error){
        
    }];
}

- (void)getSearchDataWithType:(NSInteger)type Start:(NSInteger)start
{
     AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_userId], @"userid",[NSNumber numberWithInteger:start], @"start",[NSNumber numberWithInteger:Request_Data_Count], @"size",[NSNumber numberWithInteger:type], @"type", _keyWord, @"keyword",nil];
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_Search_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]integerValue] == 0)
        {
            NSArray *dataArray = jsonDict[@"data"];
            NSInteger downNum = [jsonDict[@"num"] integerValue];

            if (type == 0)
            {
                for( NSDictionary *dict in dataArray)
                {
                    MagazineItem *item =[[MagazineItem alloc] init];
                    item.aId = [[dict objectForKey:@"id"] integerValue];
                    item.pictureImageUrl = [dict objectForKey:@"imgUrl"];
                    item.titleText = [dict objectForKey:@"imgTitle"];
                    item.likeNum = [[dict objectForKey:@"likeNum"] intValue];
                    item.magazineId = [[dict objectForKey:@"productId"] intValue];
                    item.imageWidth = [[dict objectForKey:@"width"] floatValue];
                    item.imageHeight = [[dict objectForKey:@"height"] floatValue];
                    if( item.pictureImageUrl.length > 0 )
                    {
                        [self.dataArr addObject:item];
                    }
                }
                [self refreshDataWithDownNum:downNum CollectionView:_collectionView];
            }else
            {
                for (NSDictionary *dict in dataArray)
                {
                    MagazineItem *item = [[MagazineItem alloc]init];
                    item.aId = [[dict objectForKey:@"companyId"]integerValue];
                    item.pictureImageUrl = [dict objectForKey:@"logo"];
                    item.titleText = [dict objectForKey:@"companyName"];
                    item.isAttention = [[dict objectForKey:@"isAttention"]integerValue];
                    [self.shopArr addObject:item];
                }
                [self refreshDataWithDownNum:downNum CollectionView:_shopCollectionView];
            }
    }
        
    }errorHandler:^(NSError *error){
        
    }];
}

//取消关注
-(void)getCancelFollowSomeOneDataWithTargetUser:(UIButton *)button IndexPath:(NSIndexPath *)indexPath
{
    MagazineItem *item = [self.shopArr objectAtIndex:indexPath.row];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *userTicket = [StandardUserDefaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
    NSInteger userId=[[StandardUserDefaults objectForKey:USER_ID]integerValue];
        
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:userId],@"myUserid", userTicket,@"ticket", [NSNumber numberWithInteger:item.aId],@"targetUserid", nil];
    
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_CancelOne_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
        
        if ([jsonObject[@"result"] intValue]==0)
        {
            [button setImage:[UIImage imageNamed:@"search_addConcernBtn.png"] forState:UIControlStateNormal];
            [button setTitle:@"关注" forState:UIControlStateNormal];
            [button setTitleColor:ColorWithHexRGB(0xd51024) forState:UIControlStateNormal];
            [MmiaToast showWithText:@"取消关注成功" topOffset:Main_Screen_Height - 20 image:nil];
            MagazineItem *newItem=item;
            newItem.isAttention = 0;
            [self.shopArr replaceObjectAtIndex:indexPath.row withObject:newItem];
        }else
        {
            [MmiaToast showWithText:@"取消关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
        }
        
    }errorHandler:^(NSError *error){
        [MmiaToast showWithText:@"取消关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
    }];
    
}
//关注
-(void)getFocusFollowSomeOneDataWithTargetUser:(UIButton *)button IndexPath:(NSIndexPath *)indexPath
{
    MagazineItem *item = [self.shopArr objectAtIndex:indexPath.row];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSInteger userId = [[StandardUserDefaults objectForKey:USER_ID]integerValue];
    NSString *userTicket = [StandardUserDefaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:userId],@"myUserid", userTicket,@"ticket", [NSNumber numberWithLong:item.aId],@"targetUserid", nil];
    
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_FocusOne_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
        
        if ([jsonObject[@"result"] intValue]==0)
        {
            [button setImage:nil forState:UIControlStateNormal];
            [button setTitle:@"已关注" forState:UIControlStateNormal];
            [MmiaToast showWithText:@"关注成功" topOffset:Main_Screen_Height - 20 image:nil];
            [button setTitleColor:ColorWithHexRGB(0x999999) forState:UIControlStateNormal];
            MagazineItem *newItem = item;
            newItem.isAttention = 1;
            [self.shopArr replaceObjectAtIndex:indexPath.row withObject:newItem];
        }else
        {
            [MmiaToast showWithText:@"关注失败" topOffset:Main_Screen_Height - 20 image:nil];
        }
    }errorHandler:^(NSError *error){
        [MmiaToast showWithText:@"关注失败" topOffset:Main_Screen_Height - 20 image:nil];
    }];
}

#pragma mark - Private

- (void)revertBtnClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"商家"])
    {
        [button setTitle:@"商品" forState:UIControlStateNormal];
        _collectionView.hidden = YES;
        _shopCollectionView.hidden = NO;
        _shopCollectionView.contentOffset = CGPointMake(0, 0);
        [_shopCollectionView reloadData];
    }else
    {
       [button setTitle:@"商家" forState:UIControlStateNormal];
        _collectionView.hidden = NO;
        _shopCollectionView.hidden = YES;
        _collectionView.contentOffset = CGPointMake(0, 0);
         [_collectionView reloadData];
    }
}

- (void)refreshDataWithDownNum:(NSInteger)downNum CollectionView:(UICollectionView *)collectionView
{
    if (collectionView == _collectionView)
    {
        if( _isLoadding )
        {
            _isLoadding = NO;
        }
        [_collectionView footerEndRefreshing];
        [_collectionView reloadData];
        
        if( downNum >= Request_Data_Count )
        {
            [self addRefreshFooter];
        }
        else
        {
            [self removeRefreshFooter];
        }
        
    }else
    {
        [_shopCollectionView footerEndRefreshing];
        [_shopCollectionView reloadData];
        
        if( downNum >= Request_Data_Count )
        {
            [self addShopRefreshFooter];
        }
        else
        {
            [self removeShopRefreshFooter];
        }
    }
}

- (void)netWorkError:(NSError *)error
{
    if( _isLoadding )
    {
        _isLoadding = NO;
    }
   [_collectionView footerEndRefreshing];
}

//登陆

- (void)loginSuccess
{
    [super loginSuccess];
    _userId =[[StandardUserDefaults objectForKey:USER_ID]integerValue];
    [self.shopArr removeAllObjects];
    [self getSearchDataWithType:1 Start:0];
        
}

#pragma mark - add下拉上拉刷新

//商品
- (void)addRefreshFooter
{
    __block MmiaSearchResultViewController *searchVC = self;
    [self.collectionView addFooterWithCallback:^{
        if(searchVC->_isLoadding )
            return;
        searchVC->_isLoadding = YES;
        [searchVC getSearchDataWithType:0 Start:searchVC.dataArr.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_collectionView isFooterHidden])
    {
        [_collectionView removeFooter];
    }
}

//商家
- (void)addShopRefreshFooter
{
     __block MmiaSearchResultViewController *searchVC = self;
    [self.shopCollectionView addFooterWithCallback:^{
        [searchVC getSearchDataWithType:0 Start:searchVC.shopArr.count];
    }];
}

- (void)removeShopRefreshFooter
{
    if (![_shopCollectionView isFooterHidden])
    {
        [_shopCollectionView removeFooter];
    }
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionView)
    {
        return self.dataArr.count;
    }else if (collectionView == _recommendCollectionView)
    {
        return self.recommendArr.count;
    }else
    {
        return self.shopArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewWaterfallCell *cell = nil;
    MagazineItem *item;
    if (collectionView == _collectionView)
    {
        cell = (CollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        item = [self.dataArr objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
        CGFloat rate;
        if (item.imageWidth != 0)
        {
            rate = cellWidth / item.imageWidth;
        }
        cell.imageView.frame = CGRectMake(0, 0, cellWidth, item.imageHeight * rate);
        
        cell.displayLabel.text = item.titleText;
        cell.displayLabel.textAlignment = MMIATextAlignmentLeft;
        cell.displayLabel.numberOfLines = 0;
        CGFloat labelH = [GlobalFunction getTextHeightWithSystemFont:[UIFont systemFontOfSize:18] ConstrainedToSize:CGSizeMake(cellWidth, MAXFLOAT) string:item.titleText];
        cell.displayLabel.frame = CGRectMake(6.f, cell.imageView.bottom + 8, cellWidth - 12, labelH);
        cell.displayLabel.textColor = [UIColor blackColor];
        
        cell.likeLabel.text = NSStringInt(item.likeNum);
    }else if (collectionView == _recommendCollectionView)
    {
        cell = (CollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RecommendCell_Identifier forIndexPath:indexPath];
        
        item = [self.recommendArr objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
        CGFloat rate;
        if (item.imageWidth != 0)
        {
            rate = RecommendCell_Width / item.imageWidth;
        }
        cell.imageView.frame = CGRectMake(0, 0, RecommendCell_Width, rate * item.imageHeight);
        cell.displaybgView.frame = CGRectMake(0.f, cell.imageView.height -cellLabelHeight, cell.imageView.width, cellLabelHeight);
        cell.displayLabel.text = item.titleText;
        cell.displayLabel.frame = CGRectMake(0, cell.displaybgView.top, cell.displaybgView.width, cell.displaybgView.height);
        cell.displayLabel.textAlignment = MMIATextAlignmentCenter;
    }else
    {
         cell = (CollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.cornerRadius = 4.0f;
        item = [self.shopArr objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
        cell.imageView.layer.cornerRadius = 4.0f;
        cell.imageView.frame = CGRectMake(0, 0, 125.0f, 140.0f);
        
        if (item.isAttention == 1)
        {
             [cell.concernButton setImage:nil forState:UIControlStateNormal];
            [cell.concernButton setTitle:@"已关注" forState:UIControlStateNormal];
            [cell.concernButton setTitleColor:ColorWithHexRGB(0x999999) forState:UIControlStateNormal];
            cell.concernBlock = ^(UIButton *button){
                
                if ([StandardUserDefaults boolForKey:USER_IS_LOGIN] == NO)
                {
                    [super insertIntoLoginVC];
                    return;
                }
                [self getCancelFollowSomeOneDataWithTargetUser:button IndexPath:indexPath];
            };
            
        }else
        {
            [cell.concernButton setImage:[UIImage imageNamed:@"search_addConcernBtn.png"] forState:UIControlStateNormal];
            [cell.concernButton setTitle:@"关注" forState:UIControlStateNormal];
            [cell.concernButton setTitleColor:ColorWithHexRGB(0xd51024) forState:UIControlStateNormal];
            cell.concernBlock = ^(UIButton *button){
                
                if ([StandardUserDefaults boolForKey:USER_IS_LOGIN] == NO)
                {
                    [super insertIntoLoginVC];
                    return;
                }
                [self getFocusFollowSomeOneDataWithTargetUser:button IndexPath:indexPath];
            };
        }
        [cell.concernButton.titleLabel setFont:UIFontSystem(15)];
        cell.concernButton.frame = CGRectMake(0, cell.imageView.bottom, cell.imageView.width, 40);
    }
    
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if (collectionView == _collectionView)
    {
        MagazineItem *item = [self.dataArr objectAtIndex:indexPath.row];
        CGFloat rate;
        if (item.imageWidth != 0)
        {
            rate = cellWidth / item.imageWidth;
        }
         CGFloat labelHeight = [GlobalFunction getTextHeightWithSystemFont:[UIFont systemFontOfSize:18] ConstrainedToSize:CGSizeMake(cellWidth, MAXFLOAT) string:item.titleText];
        if( labelHeight > 0 )
        {
            labelHeight += 8;
        }
        labelHeight += 29;
        
         size = CGSizeMake(cellWidth, item.imageHeight * rate + labelHeight);
    }else if (collectionView == _recommendCollectionView)
    {
        MagazineItem *item = [self.recommendArr objectAtIndex:indexPath.row];
        CGFloat rate;
        if (item.imageWidth != 0)
        {
            rate = RecommendCell_Width / item.imageWidth;
        }
        size = CGSizeMake(RecommendCell_Width, rate * item.imageHeight);

    }else
    {
        size = CGSizeMake(125.0f, 180.0f);
    }
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader])
    {
        MmiaSearchWaterFallHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:Header_Identifier forIndexPath:indexPath];
        header.title = _keyWord;
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _recommendCollectionView)
    {
        MagazineItem *item = [self.recommendArr objectAtIndex:indexPath.row];
        MmiaDetailSpecialViewController *nextVC = [[MmiaDetailSpecialViewController alloc]initWithUserId:item.userId Item:item];
        nextVC.view.frame = self.view.bounds;
        self.rightStackViewController = nextVC;
        
    }else if (collectionView == _collectionView)
    {
        MagazineItem *item = [self.dataArr objectAtIndex:indexPath.row];
        MmiaDetailGoodsViewController *goodsVC = [[MmiaDetailGoodsViewController alloc]initWithMagezineItem:item IndexPath:indexPath];
        self.rightStackViewController = goodsVC;
    }else
    {
        
        CollectionViewWaterfallCell *cell = (CollectionViewWaterfallCell *)[collectionView cellForItemAtIndexPath:indexPath];
        MagazineItem *item = [self.shopArr objectAtIndex:indexPath.row];
        MmiaOtherPersonHomeViewController *otherVC = [[MmiaOtherPersonHomeViewController alloc]initWithUserId:item.aId];
        otherVC.concernClickBlock = ^(BOOL concern)
        {
            if (concern)
            {
                [cell.concernButton setImage:nil forState:UIControlStateNormal];
                [cell.concernButton setTitle:@"已关注" forState:UIControlStateNormal];
                [cell.concernButton setTitleColor:ColorWithHexRGB(0x999999) forState:UIControlStateNormal];
                MagazineItem *newItem = item;
                newItem.isAttention = 1;
                [self.shopArr replaceObjectAtIndex:indexPath.row withObject:newItem];
            }else
            {
                [cell.concernButton setImage:[UIImage imageNamed:@"search_addConcernBtn.png"] forState:UIControlStateNormal];
                [cell.concernButton setTitle:@"关注" forState:UIControlStateNormal];
                [cell.concernButton setTitleColor:ColorWithHexRGB(0xd51024) forState:UIControlStateNormal];
                MagazineItem *newItem=item;
                newItem.isAttention = 0;
                [self.shopArr replaceObjectAtIndex:indexPath.row withObject:newItem];
            }
        };
        self.rightStackViewController = otherVC;
    }
}

#pragma mark - UIViewControllerRotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    self.recommendView.frame = CGRectMake(0, 0, self.anotherView.width, 45);
    self.recommendCollectionView.frame = CGRectMake(0, 0, self.anotherView.width, self.anotherView.height - 44);
     _revertButton.frame = CGRectMake(self.contentView.width - 50 - 77, self.contentView.height - 50 - 77, 77, 77);
    
    CHTCollectionViewWaterfallLayout *recommendLayout = (CHTCollectionViewWaterfallLayout *)self.recommendCollectionView.collectionViewLayout;
    
    if (self.isPortrait)
    {
        recommendLayout.sectionInset = UIEdgeInsetsMake(30, 8, 30, 30);
        recommendLayout.columnCount = 1;
        
    }else
    {
        recommendLayout.sectionInset = UIEdgeInsetsMake(30, 14, 30, 14);
        recommendLayout.minimumColumnSpacing = 36;
        recommendLayout.columnCount = 2;
    }
    self.recommendCollectionView.collectionViewLayout = recommendLayout;
    
    [self.collectionView reloadItemsAtIndexPaths:self.collectionView.indexPathsForVisibleItems];
    [self.recommendCollectionView reloadItemsAtIndexPaths:self.recommendCollectionView.indexPathsForVisibleItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
