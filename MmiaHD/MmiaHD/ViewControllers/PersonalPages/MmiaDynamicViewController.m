//
//  MmiaDynamicViewController.m
//  MmiaHD
//
//  Created by lixiao on 15/3/9.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaDynamicViewController.h"
#import "AppDelegate.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"
#import "CollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MagazineItem.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

static const CGFloat cellWidth = 180.0;

@interface MmiaDynamicViewController ()<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>{
    
    BOOL       _isLoadding;
    BOOL       _isRefresh;
    
}

@end

@implementation MmiaDynamicViewController

#pragma mark - Init

- (UICollectionView *)dynamicCollectionView
{
    if( !_dynamicCollectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.minimumInteritemSpacing = 20;
        layout.minimumColumnSpacing = 10;
        layout.columnCount = 3;
        
        _dynamicCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _dynamicCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _dynamicCollectionView.clipsToBounds = NO;
        _dynamicCollectionView.alwaysBounceVertical = YES;
        _dynamicCollectionView.dataSource = self;
        _dynamicCollectionView.delegate = self;
        _dynamicCollectionView.backgroundColor = [UIColor clearColor];
        _dynamicCollectionView.contentInset = UIEdgeInsetsMake(self.collectionInset, 0, 0, 0);
        [_dynamicCollectionView registerClass:[CollectionViewWaterfallCell class]
                forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _dynamicCollectionView;
}

#pragma mark - lifeStyle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dynamicCollectionView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = [[NSMutableArray alloc]init];
    [self.view addSubview:self.dynamicCollectionView];
     _isLoadding = YES;
    [self getDynamicDataByRequest:0];
    [DefaultNotificationCenter addObserver:self selector:@selector(doLikeClick:) name:DetailGoodsLike_Notification_Name object:nil];
}

#pragma mark - Private

- (void)getDynamicDataByRequest:(NSInteger)start
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userTicket = [defaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:userTicket, @"ticket", [NSNumber numberWithInteger:start], @"start", [NSNumber numberWithInteger:Request_Data_Count], @"size", nil];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_UserDynamic_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]integerValue] == 0)
        {
            NSArray *dataArr = [jsonDict objectForKey:@"data"];
            NSInteger downNum = [jsonDict[@"num"] integerValue];
            if (_isRefresh)
            {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dict in dataArr)
            {
                MagazineItem *item = [[MagazineItem alloc]init];
                item.aId = [[dict objectForKey:@"id"]integerValue];
                //2个
                item.pictureImageUrl = [dict objectForKey:@"pictureUrl"];
                item.likeNum = [[dict objectForKey:@"suportNum"]integerValue];
                item.titleText = [dict objectForKey:@"title"];
                item.imageWidth = [[dict objectForKey:@"width"]integerValue];
                item.imageHeight = [[dict objectForKey:@"hieght"]integerValue];
                [self.dataArr addObject:item];
            }
            [self refreshDynamicPicWithDownNum:downNum];
            
        }else
        {
            
        }
        
    }errorHandler:^(NSError *error){
        
    }];
}

- (void)refreshDynamicPicWithDownNum:(NSInteger)downNum
{
    if( _isLoadding )
    {
        _isLoadding = NO;
    }
    if( _isRefresh )
    {
        [_dynamicCollectionView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_dynamicCollectionView footerEndRefreshing];
    }
    [_dynamicCollectionView reloadData];
    
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
        [_dynamicCollectionView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_dynamicCollectionView footerEndRefreshing];
    }
}

//通知
- (void)doLikeClick:(NSNotification *)nc
{
    NSIndexPath *indexPath = [nc.userInfo objectForKey:@"indexPath"];
    if ((self.dataArr.count - 1) < indexPath.row)
    {
        return;
    }
    MagazineItem *item = [self.dataArr objectAtIndex:indexPath.row];
     MagazineItem *newItem = item;
    NSInteger type = [[nc.userInfo objectForKey:@"type"]integerValue];
    
    if ([[nc.userInfo objectForKey:@"isLike"]boolValue] == YES && type == 1 )
    {
        newItem.likeNum += 1;
        [self.dataArr replaceObjectAtIndex:indexPath.row withObject:newItem];
        [self.dynamicCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        
    }else if ([[nc.userInfo objectForKey:@"isLike"]boolValue] == NO && type == 1)
    {
    
        newItem.likeNum -= 1;
        [self.dataArr replaceObjectAtIndex:indexPath.row withObject:newItem];
        [self.dynamicCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    }else
    {
        
    }
}

#pragma mark - add下拉上拉刷新

- (void)addRefreshFooter
{
    __block MmiaDynamicViewController *dynamicVC = self;
    [self.dynamicCollectionView addFooterWithCallback:^{
        if(dynamicVC->_isLoadding )
            return;
        dynamicVC->_isRefresh = NO;
        dynamicVC->_isLoadding = YES;
        [dynamicVC getDynamicDataByRequest:dynamicVC.dataArr.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_dynamicCollectionView isFooterHidden])
    {
        [_dynamicCollectionView removeFooter];
    }
}


#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewWaterfallCell *cell =
    (CollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                             forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    MagazineItem *item = [self.dataArr objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
    CGFloat rate,height;
    if (item.imageWidth != 0)
    {
        rate = cellWidth / item.imageWidth;
    }
    height = rate * item.imageHeight;
    cell.imageView.frame = CGRectMake(0.f, cell.bounds.origin.y, cellWidth, height);
    cell.displayLabel.text = item.titleText;
    cell.displayLabel.textAlignment = MMIATextAlignmentLeft;
    cell.displayLabel.numberOfLines = 0;
     CGFloat labelH = [GlobalFunction getTextHeightWithSystemFont:[UIFont systemFontOfSize:18] ConstrainedToSize:CGSizeMake(cellWidth, MAXFLOAT) string:item.titleText];
    cell.displayLabel.frame = CGRectMake(6.f, cell.imageView.bottom + 8, cellWidth - 12, labelH);
    cell.displayLabel.textColor = [UIColor blackColor];
    
    cell.likeLabel.text = NSStringInt(item.likeNum);

    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
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
    
    CGSize size = CGSizeMake(cellWidth, item.imageHeight * rate + labelHeight);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dynamicDelegate respondsToSelector:@selector(dynamicVCCollectionView:didSelectItemAtIndexPath:)])
    {
        [self.dynamicDelegate dynamicVCCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSDictionary *infoDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:scrollView.contentOffset.y], PersonHome_OffsetYInfoKey, nil];
    [DefaultNotificationCenter postNotificationName:PersonHomeOffset_Notification_Key  object:nil userInfo:infoDict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
