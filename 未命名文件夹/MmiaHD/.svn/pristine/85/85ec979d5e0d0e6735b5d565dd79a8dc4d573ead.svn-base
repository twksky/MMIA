//
//  MmiaSpecialViewController.m
//  MmiaHD
//
//  Created by lixiao on 15/3/9.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaSpecialViewController.h"
#import "AppDelegate.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"
#import "CollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaDetailSpecialViewController.h"
#import "MagazineItem.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface MmiaSpecialViewController ()<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>{
    NSInteger  _userId;
    BOOL       _isLoadding;
    BOOL       _isRefresh;
}

@end

@implementation MmiaSpecialViewController

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

- (UICollectionView *)specialCollectionView
{
    if( !_specialCollectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        layout.columnCount = 2;
        _specialCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _specialCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _specialCollectionView.clipsToBounds = NO;
        _specialCollectionView.alwaysBounceVertical = YES;
        _specialCollectionView.dataSource = self;
        _specialCollectionView.delegate = self;
        _specialCollectionView.backgroundColor = [UIColor clearColor];
        _specialCollectionView.contentInset = UIEdgeInsetsMake(self.collectionInset, 0, 0, 0);
        [_specialCollectionView registerClass:[CollectionViewWaterfallCell class]
             forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _specialCollectionView;
}

#pragma mark - lifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.dataArr = [[NSMutableArray alloc]init];
    [self.view addSubview:self.specialCollectionView];
    _isLoadding = YES;
    [self getUserMagazineRequestStart:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.specialCollectionView.frame = self.view.bounds;
}

#pragma mark - Private

-(void)getUserMagazineRequestStart:(NSInteger)start
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userTicket = [defaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_userId],@"userid",[NSNumber numberWithLong:start],@"start",[NSNumber numberWithInt:Request_Data_Count],@"size",userTicket,@"ticket", nil];
    
     AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_UserMagezene_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]integerValue] == 0)
        {
            NSInteger downNum = [jsonDict[@"num"] integerValue];
            NSArray *dataArray = jsonDict[@"data"];
            if (_isRefresh)
            {
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *infoDict in dataArray)
            {
               MagazineItem *item = [[MagazineItem alloc]init];
                item.titleText = [infoDict objectForKey:@"title"];
                item.aId = [[infoDict objectForKey:@"id"]intValue];
                item.userId = [[infoDict objectForKey:@"supportNum"]intValue];
                item.pictureImageUrl = [infoDict objectForKey:@"newestShareImageUrl"];
                item.imageHeight = [[infoDict objectForKey:@"newestShareImageHeight"]floatValue];
                item.imageWidth = [[infoDict objectForKey:@"newestShareImageWidht"]floatValue];
                item.isAttention = [[infoDict objectForKey:@"isAttention"]integerValue];
                [self.dataArr addObject:item];
            }
            [self refreshConcernMagezineWithDownNum:downNum];
        }else
        {
            [self netWorkError:nil];
        }
        
    }errorHandler:^(NSError *error){
        
    }];

}

- (void)refreshConcernMagezineWithDownNum:(NSInteger)downNum
{
    if( _isLoadding )
    {
        _isLoadding = NO;
    }
    if( _isRefresh )
    {
        [_specialCollectionView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_specialCollectionView footerEndRefreshing];
    }
    [_specialCollectionView reloadData];
    
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
        [_specialCollectionView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_specialCollectionView footerEndRefreshing];
    }
}


#pragma mark - add下拉上拉刷新

- (void)addRefreshFooter
{
    __block MmiaSpecialViewController *specialVC = self;
    [self.specialCollectionView addFooterWithCallback:^{
        if(specialVC->_isLoadding )
            return;
        specialVC->_isRefresh = NO;
        specialVC->_isLoadding = YES;
        [specialVC getUserMagazineRequestStart:specialVC.dataArr.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_specialCollectionView isFooterHidden])
    {
        [_specialCollectionView removeFooter];
    }
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
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
        rate = Collection_Cell_Image_Width / item.imageWidth;
    }
    height = rate * item.imageHeight;
    cell.imageView.frame = CGRectMake(0.f, cell.bounds.origin.y, Collection_Cell_Image_Width, height);
    
    cell.displayLabel.text = item.titleText;
    cell.displayLabel.frame = CGRectMake(5.f, height, Collection_Cell_Image_Width - 10, 40);
    cell.displayLabel.textAlignment = MMIATextAlignmentLeft;
    cell.displayLabel.textColor = [UIColor blackColor];
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagazineItem *item = [self.dataArr objectAtIndex:indexPath.row];
    CGFloat rate,height;
    if (item.imageWidth != 0)
    {
        rate = Collection_Cell_Image_Width / item.imageWidth;
    }
    height = rate * item.imageHeight;
    CGSize size = CGSizeMake(Collection_Cell_Image_Width, height + 40);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.specialDelegate respondsToSelector:@selector(specialVCCollectionView:didSelectItemAtIndexPath:)])
    {
        [self.specialDelegate specialVCCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
