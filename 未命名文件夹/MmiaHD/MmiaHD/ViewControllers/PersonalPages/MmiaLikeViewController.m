//
//  MmiaLikeViewController.m
//  MmiaHD
//
//  Created by lixiao on 15/3/9.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaLikeViewController.h"
#import "AppDelegate.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"
#import "CollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MagazineItem.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

static const CGFloat cellWidth = 180.0;

@interface MmiaLikeViewController ()<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>{
    NSInteger  _userId;
    BOOL       _isLoadding;
    BOOL       _isRefresh;
}

@end

@implementation MmiaLikeViewController

#pragma mark - Init

- (id)initWithUserId:(NSInteger)userId
{
    self = [super init];
    if (self)
    {
        _userId = userId;
    }
    return self;
}


- (UICollectionView *)likeCollectionView
{
    if( !_likeCollectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.minimumInteritemSpacing = 20;
        layout.minimumColumnSpacing = 10;
        layout.columnCount = 3;
        
        _likeCollectionView = [[UICollectionView alloc] initWithFrame: self.view.bounds collectionViewLayout:layout];
         _likeCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _likeCollectionView.clipsToBounds = NO;
        _likeCollectionView.alwaysBounceVertical = YES;
        _likeCollectionView.dataSource = self;
        _likeCollectionView.delegate = self;
        _likeCollectionView.backgroundColor = [UIColor clearColor];
        _likeCollectionView.contentInset = UIEdgeInsetsMake(self.collectionInset, 0, 0, 0);
        [_likeCollectionView registerClass:[CollectionViewWaterfallCell class]
                   forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _likeCollectionView;
}

#pragma mark - lifeStyle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.likeCollectionView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = [[NSMutableArray alloc]init];
    [DefaultNotificationCenter addObserver:self selector:@selector(doLikeNotification:) name:DetailGoodsLike_Notification_Name object:nil];
    [self.view addSubview:self.likeCollectionView];
    _isLoadding = YES;
    [self getProductLikeDataByRequest:0];
   
}

#pragma mark - Private

- (void)getProductLikeDataByRequest:(NSInteger)start
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userTicket = [defaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_userId],@"userid", [NSNumber numberWithLong:start],@"start", [NSNumber numberWithInt:Request_Data_Count],@"size", userTicket,@"ticket", nil];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_UserLike_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        
        if ([jsonDict[@"result"]integerValue] == 0)
        {
            NSArray* likeArray = jsonDict[@"data"];
            NSInteger downNum = [jsonDict[@"num"] integerValue];
            if (_isRefresh)
            {
                [self.dataArr removeAllObjects];
            }

              for( NSDictionary *dict in likeArray)
              {
                  MagazineItem *item = [[MagazineItem alloc] init];
                  item.aId = [[dict objectForKey:@"id"] integerValue];
                  item.pictureImageUrl = [dict objectForKey:@"imgUrl"];
                  item.likeNum = [[dict objectForKey:@"supportNum"] integerValue];
                  item.magazineId = [[dict objectForKey:@"productId"] integerValue];
                  item.imageWidth = [[dict objectForKey:@"width"] floatValue];
                  item.imageHeight = [[dict objectForKey:@"height"] floatValue];
                  item.titleText = [dict objectForKey:@"title"];
                  [self.dataArr addObject:item];
              }
             [self refreshLikeMagezineWithDownNum:downNum];
        }
       
    }errorHandler:^(NSError *error){
        
    }];
}

- (void)refreshLikeMagezineWithDownNum:(NSInteger)downNum
{
    if( _isLoadding )
    {
        _isLoadding = NO;
    }
    if( _isRefresh )
    {
        [_likeCollectionView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_likeCollectionView footerEndRefreshing];
    }
    [_likeCollectionView reloadData];
    
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
        [_likeCollectionView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_likeCollectionView footerEndRefreshing];
    }
}

- (void)doLikeNotification:(NSNotification *)notification
{
      NSInteger ownUserId = [[StandardUserDefaults objectForKey:USER_ID]integerValue];
   MagazineItem *item = [notification.userInfo objectForKey:@"item"];
    NSIndexPath *indexPath = [notification.userInfo objectForKey:@"indexPath"];
    NSInteger type = [[notification.userInfo objectForKey:@"type"]integerValue];
    NSInteger deleteNum = [[notification.userInfo objectForKey:@"deleteNum"]integerValue];
    if ((self.dataArr.count - 1) < indexPath.row)
    {
        return;
    }
    
    if ([[notification.userInfo objectForKey:@"isLike"]boolValue] == YES && _userId == ownUserId && type == 0 )
    {
        [self.dataArr insertObject:item atIndex:0];
        [self.likeCollectionView reloadData];
//        [self.likeCollectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]];
        
        
    }else if ([[notification.userInfo objectForKey:@"isLike"]boolValue] == NO && _userId == ownUserId && type == 0)
    {
        NSIndexPath *selectIndexpath;
//        MagazineItem *item1 = [self.dataArr objectAtIndex:indexPath.row];
        if (deleteNum != 0)
        {
             selectIndexpath = indexPath;
        }else {
            selectIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self.dataArr removeObjectAtIndex:selectIndexpath.row];
        [self.likeCollectionView reloadData];
       // [self.likeCollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:selectIndexpath]];
    }else
    {
        [self.dataArr removeAllObjects];
        [self getProductLikeDataByRequest:0];
    }
}

#pragma mark - add下拉上拉刷新

- (void)addRefreshFooter
{
    __block MmiaLikeViewController *likeVC = self;
    [self.likeCollectionView addFooterWithCallback:^{
        if(likeVC->_isLoadding )
            return;
        likeVC->_isRefresh = NO;
        likeVC->_isLoadding = YES;
        [likeVC getProductLikeDataByRequest:likeVC.dataArr.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_likeCollectionView isFooterHidden])
    {
        [_likeCollectionView removeFooter];
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
    if ([self.likeDelegate respondsToSelector:@selector(likeVCCollectionView:didSelectItemAtIndexPath:)])
    {
        [self.likeDelegate likeVCCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger ownUserId = [[StandardUserDefaults objectForKey:USER_ID]integerValue];
    NSDictionary *infoDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:scrollView.contentOffset.y], PersonHome_OffsetYInfoKey, nil];
    
    if (ownUserId == _userId)
    {
        [DefaultNotificationCenter postNotificationName:PersonHomeOffset_Notification_Key object:nil userInfo:infoDict];
    }else
    {
        [DefaultNotificationCenter postNotificationName:OtherHomeOffset_Notification_Key object:nil userInfo:infoDict];
    }
}

- (void)dealloc
{
    [DefaultNotificationCenter removeObserver:self name:DetailGoodsLike_Notification_Name object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
