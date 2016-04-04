//
//  MmiaDetailGoodsViewController.m
//  MmiaHD
//
//  Created by lixiao on 15/3/16.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaDetailGoodsViewController.h"
#import "UIViewController+StackViewController.h"
#import "AppDelegate.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"
#import "CollectionViewWaterfallCell.h"
#import "MmiaDetailTableViewCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaDetailGoodsWaterfallHeader.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MmiaToast.h"
#import "MmiaSearchResultViewController.h"
#import "MmiaOtherPersonHomeViewController.h"
#import "MmiaPersonalHomeViewController.h"
#import "MmiaRecommendWaterFallHeader.h"

#define Cell_Width            (self.isPortrait?156.0:190.0)

static const NSInteger changePicHeight = 34;
static NSInteger deleteNum = 0;

@interface MmiaDetailGoodsViewController ()<CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
{
    MagazineItem      *_item;
    NSIndexPath       *_indexPath;
    BOOL              _isLoadding;
    BOOL              _isRefresh;
    BOOL              _isLike;
    MmiaDetailGoodsWaterfallHeader *_headerView;
}

@property (nonatomic, retain) MmiaRecommendWaterFallHeader *recommendView;
@property (nonatomic, retain) UITableView    *tableView;
@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, retain) NSMutableArray *commendArr;

@end

@implementation MmiaDetailGoodsViewController

#pragma mark - init

- (id)initWithMagezineItem:(MagazineItem *)item IndexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self)
    {
        _item = item;
        _indexPath = indexPath;
        _dataArr = [[NSMutableArray alloc]init];
        _commendArr = [[NSMutableArray alloc]init];
    }
    return self;
}

- (UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        if (self.isPortrait)
        {
            layout.columnCount = 1;
            layout. minimumInteritemSpacing = 20;
            layout.sectionInset = UIEdgeInsetsMake(0, 6, 20, 6);
        }else
        {
            layout.columnCount = 2;
            layout.minimumInteritemSpacing = 40;
            layout.minimumColumnSpacing = 16;
            layout.sectionInset = UIEdgeInsetsMake(0, 14, 40, 14);
        }
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.anotherView.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.clipsToBounds = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[CollectionViewWaterfallCell class]
                forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - lifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.contentView.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
    CGFloat height = [MmiaDetailGoodsWaterfallHeader getHeightMagezineItem:_item infoDict:nil];
    _headerView = [[MmiaDetailGoodsWaterfallHeader alloc]initWithFrame:CGRectMake(0, -height, 600, height)];
    
    __block MmiaDetailGoodsViewController *goodsVC = self;
    _headerView.likeButtonBlock = ^(UIButton *button){
        if ([StandardUserDefaults boolForKey:USER_IS_LOGIN] == NO)
        {
            [super insertIntoLoginVC];
            return;
        }
        
        if (goodsVC ->_isLike)
        {
            [goodsVC deleteLikePicture];
            
        }else
        {
            [goodsVC addLikePicture];
        }

    };
    
    _headerView.searchLabelButtonBlock = ^(UIButton *button){
        
         NSInteger userId = [[StandardUserDefaults objectForKey:USER_ID]integerValue];
        MmiaSearchResultViewController *searchVC = [[MmiaSearchResultViewController alloc]initWithKeyWord:button.titleLabel.text UserId:userId];
        goodsVC.rightStackViewController = searchVC;
    };
    
    _headerView.tapHeadImageViewBlock = ^(NSInteger userId){
        
       NSInteger ownUserId = [[StandardUserDefaults objectForKey:USER_ID]integerValue];
        if (ownUserId == userId)
        {
            MmiaPersonalHomeViewController *homeVC = [[MmiaPersonalHomeViewController alloc]init];
            goodsVC.rightStackViewController = homeVC;
        }else
        {
            MmiaOtherPersonHomeViewController *otherVC = [[MmiaOtherPersonHomeViewController alloc]initWithUserId:userId];
            goodsVC.rightStackViewController = otherVC;
        }
    };
    
    [_headerView resetMagezineItem:_item infoDict:nil];
    self.tableView.tableHeaderView = _headerView;
    
    [self.anotherView addSubview:self.collectionView];
    self.recommendView =[[MmiaRecommendWaterFallHeader alloc]init];
    self.recommendView.title = @"推荐内容";
    [self.anotherView addSubview:self.recommendView];
    
   [self getProductPicsByIdData];
    [self recommendShareRequest:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   self.recommendView.frame = CGRectMake(0, 0, self.anotherView.width, 45);
    self.collectionView.frame = CGRectMake(0, 0, self.anotherView.width, self.anotherView.height - 44);
    self.collectionView.contentInset = UIEdgeInsetsMake(self.recommendView.height, 0, 0, 0);
     self.tableView.frame = self.contentView.bounds;
}

#pragma mark - SendRequest

- (void)getProductPicsByIdData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userTicket = [defaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
    NSInteger userId = [[defaults objectForKey:USER_ID]integerValue];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_item.aId], @"id", userTicket, @"ticket",[NSNumber numberWithInteger:userId],@"userid",[NSNumber numberWithInteger:_item.magazineId],@"productId", nil];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_ProductPic_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]integerValue] == 0)
        {
            NSDictionary *dataDict = jsonDict[@"data"];
            NSDictionary *picDict = dataDict[@"pictures"];
            NSArray *pictUrlsArr = picDict[@"pictureUrls"];
            
            for (NSDictionary *dict in pictUrlsArr)
            {
                MagazineItem *item = [[MagazineItem alloc]init];
                item.pictureImageUrl = [dict objectForKey:@"url"];
                item.imageHeight = [[dict objectForKey:@"height"]floatValue];
                item.imageWidth = [[dict objectForKey:@"width"]floatValue];
                [self.dataArr addObject:item];
            }
            
             if ([picDict[@"isLike"]integerValue] == 1 )
             {
                 _isLike = YES;
             }else
             {
                 _isLike = NO;
             }
            
            CGFloat height = [MmiaDetailGoodsWaterfallHeader getHeightMagezineItem:_item infoDict:dataDict];
            _headerView.frame = CGRectMake(0, -height, 600, height);
             [_headerView resetMagezineItem:_item infoDict:dataDict];
            self.tableView.tableHeaderView = _headerView;
            [self.tableView reloadData];
        }
        
    }errorHandler:^(NSError *error){
        
    }];
}

- (void)recommendShareRequest:(NSInteger)start
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userTicket = [defaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
    NSDictionary *infoDict = [[NSDictionary alloc]initWithObjectsAndKeys:userTicket, @"ticket",[NSNumber numberWithInteger:_item.aId], @"shareId",[NSNumber numberWithInteger:start], @"start",[NSNumber numberWithInteger:Request_Data_Count], @"size", nil];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_RecommendShare_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]integerValue] == 0)
        {
            NSArray *dataArr = jsonDict[@"data"];
            NSInteger downNum = [jsonDict[@"num"] integerValue];
            if (_isRefresh)
            {
                [self.commendArr removeAllObjects];
            }

            for (NSDictionary *dict in dataArr)
            {
                MagazineItem *item = [[MagazineItem alloc]init];
                item.aId = [[dict objectForKey:@"id"] integerValue];
                item.pictureImageUrl = [dict objectForKey:@"pictureUrl"];
                item.likeNum = [[dict objectForKey:@"supportNum"] integerValue];
                item.magazineId = [[dict objectForKey:@"productId"] integerValue];
                item.imageWidth = [[dict objectForKey:@"width"] floatValue];
                item.imageHeight = [[dict objectForKey:@"height"] floatValue];
                item.titleText = [dict objectForKey:@"title"];
                item.headImageUrl = [dict objectForKey:@"headImgUrl"];
                [self.commendArr addObject:item];
               
            }
            [self refeshrecommendShareRequestWithDownNum:downNum];
        }
        
    }errorHandler:^(NSError *error){
        
    }];
}

//用户喜欢某个商品或者图片
-(void)addLikePicture
{
    NSString *userTicket = [StandardUserDefaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
   NSInteger userId=[[StandardUserDefaults objectForKey:USER_ID]integerValue];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_item.aId],@"shareId",userTicket,@"ticket",[NSNumber numberWithInteger:userId],@"userid", nil];
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_Addlike_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        _headerView.likeButton.enabled = YES;
        
        if ([jsonDict[@"result"]intValue]==0)
        {
            _isLike = YES;
            
            UIImage *likeInImage=[UIImage imageNamed:@"personalCenter_likebuttonselected.png"];
            [_headerView.likeButton setImage:likeInImage forState:UIControlStateNormal];
            [MmiaToast showWithText:@"喜欢成功" topOffset:Main_Screen_Height - 20 image:nil];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_item, @"item",_indexPath, @"indexPath", [NSNumber numberWithBool:YES], @"isLike", [NSNumber numberWithInteger:self.enterType], @"type", nil];
            [DefaultNotificationCenter postNotificationName:DetailGoodsLike_Notification_Name object:nil userInfo:dict];
            
            if (self.doLikeClickBlock)
            {
                self.doLikeClickBlock(YES, _indexPath);
            }
        }else
        {
            [MmiaToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
        }
        
    }errorHandler:^(NSError *error){
        
        _headerView.likeButton.enabled = YES;
        [MmiaToast showWithText:@"喜欢失败" topOffset:Main_Screen_Height-20 image:nil];
    }];
}

//用户取消喜欢某个商品或者图片
-(void)deleteLikePicture
{
    NSString *userTicket = [StandardUserDefaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
    NSInteger userId = [[StandardUserDefaults objectForKey:USER_ID]integerValue];
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_item.aId],@"shareId",userTicket,@"ticket",[NSNumber numberWithInteger:userId],@"userid", nil];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_DeleteLike_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        _headerView.likeButton.enabled = YES;
        
        if ([jsonDict[@"result"]intValue]==0) {
            [MmiaToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
            _isLike = NO;
            UIImage *likeInImage=[UIImage imageNamed:@"personalCenter_likebutton.png"];
            [_headerView.likeButton setImage:likeInImage forState:UIControlStateNormal];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_item, @"item",_indexPath, @"indexPath", [NSNumber numberWithBool:NO], @"isLike", [NSNumber numberWithInteger:self.enterType], @"type",[NSNumber numberWithInteger:deleteNum], @"deleteNum", nil];
            [DefaultNotificationCenter postNotificationName:DetailGoodsLike_Notification_Name object:nil userInfo:dict];
            if (self.doLikeClickBlock)
            {
                self.doLikeClickBlock(NO, _indexPath);
            }
            deleteNum++;
        }else
        {
            [MmiaToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
        }
        
    }errorHandler:^(NSError *error){
        
        _headerView.likeButton.enabled = YES;
         [MmiaToast showWithText:@"取消喜欢失败" topOffset:Main_Screen_Height-20 image:nil];
    }];
}

//收藏


#pragma mark - Private

- (void)refeshrecommendShareRequestWithDownNum:(NSInteger)downNum
{
    if( _isLoadding )
    {
        _isLoadding = NO;
    }
    if( _isRefresh )
    {
        [_collectionView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_collectionView footerEndRefreshing];
    }
    [_collectionView reloadData];
    
    if( downNum >= Request_Data_Count )
    {
        [self addRefreshFooter];
    }
    else
    {
        [self removeRefreshFooter];
    }
    
}

- (void)netWorkError:(NSError *)error
{
    if( _isLoadding )
    {
        _isLoadding = NO;
    }
    if( _isRefresh )
    {
        [_collectionView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_collectionView footerEndRefreshing];
    }
}

- (void)loginSuccess
{
    [super loginSuccess];
    [self.dataArr removeAllObjects];
    [self getProductPicsByIdData];
}

#pragma mark - add下拉上拉刷新

- (void)addRefreshFooter
{
    __block MmiaDetailGoodsViewController *goodsVC = self;
    [self.collectionView addFooterWithCallback:^{
        if(goodsVC->_isLoadding )
            return;
        goodsVC->_isRefresh = NO;
        goodsVC->_isLoadding = YES;
        [goodsVC recommendShareRequest:goodsVC.commendArr.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_collectionView isFooterHidden])
    {
        [_collectionView removeFooter];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.recommendView.frame = CGRectMake(0, 0, self.anotherView.width, 45);
    self.collectionView.frame = CGRectMake(0, 0, self.anotherView.width, self.anotherView.height - 44);
    
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    if (self.isPortrait)
    {
        layout.columnCount = 1;
        layout. minimumInteritemSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(20, 6, 20, 6);
    }else
    {
        layout.columnCount = 2;
        layout.minimumInteritemSpacing = 40;
        layout.minimumColumnSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(40, 14, 40, 14);
    }
     self.collectionView.collectionViewLayout = layout;
    [self.collectionView reloadItemsAtIndexPaths:self.collectionView.indexPathsForVisibleItems];
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.commendArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewWaterfallCell *cell =
    (CollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                             forIndexPath:indexPath];
    
    MagazineItem *item = [self.commendArr objectAtIndex:indexPath.row];
    CGFloat rate;
    if (item.imageWidth != 0)
    {
        rate = Cell_Width / item.imageWidth;
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
    cell.imageView.frame = CGRectMake(0, 0, Cell_Width, rate * item.imageHeight);
    //cell.displaybgView.image = UIImageNamed(@"personalcenyer_changeBg.png");
    cell.displaybgView.frame = CGRectMake(0, rate * item.imageHeight - 34, Cell_Width, changePicHeight);
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:item.headImageUrl] placeholderImage:[UIImage imageNamed:@"personalcenter_DefaultPersonPic.png"]];
    cell.headImageView.frame = CGRectMake(5, cell.imageView.bottom - 29, 24, 24);
    cell.displayLabel.frame = CGRectMake(60, rate * item.imageHeight - changePicHeight, Cell_Width - 120, changePicHeight);
    cell.displayLabel.text = item.titleText;
    cell.displayLabel.textAlignment = MMIATextAlignmentCenter;
    cell.displayLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.displayLabel.textColor = [UIColor blackColor];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     MagazineItem *item = [self.commendArr objectAtIndex:indexPath.row];
    MmiaDetailGoodsViewController *goodsVC = [[MmiaDetailGoodsViewController alloc]initWithMagezineItem:item IndexPath:indexPath];
   self.rightStackViewController = goodsVC;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     MagazineItem *item = [self.commendArr objectAtIndex:indexPath.row];
    
        CGFloat rate;
        if (item.imageWidth != 0)
        {
            rate = Cell_Width / item.imageWidth;
        }
        CGSize size = CGSizeMake(Cell_Width, item.imageHeight * rate);
        return size;
  }


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MagazineItem *item = [self.dataArr objectAtIndex:indexPath.row];
    
    CGFloat rate;
    if (item.imageWidth != 0)
    {
        rate = 600.0 / item.imageWidth;
    }
    return (item.imageHeight * rate);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil)
    {
        cell = [[MmiaDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
 
    
    MagazineItem *item = [self.dataArr objectAtIndex:indexPath.row];
    CGFloat rate;
    if (item.imageWidth != 0)
    {
        rate = 600.0 / item.imageWidth;
    }
    [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
    cell.picImageView.frame = CGRectMake(0, 0, 600.0, rate * item.imageHeight);
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
