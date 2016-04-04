//
//  MMiaDetailViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 14-7-10.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaDetailViewController.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MagezineItem.h"
#import "MJRefresh.h"
#import "MMiaDetailImgeViewController.h"
#import "MMIToast.h"
#import "MMiaCommonUtil.h"

#define CELL_IDENTIFIER @"detailWaterfallCell"
#define CONTENT_INSET_TOP 269 / 2

@interface MMiaDetailViewController ()
{
    NSInteger _channelId;
    NSString* _titleName;
    
    UIImageView* _bannerImg;
    UILabel* _bannerTitle;
    BOOL _isLoading;
}
- (void)netWorkError:(NSError *)error;

@end

@implementation MMiaDetailViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumColumnSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kNavigationBarHeight - VIEW_OFFSET) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[MMiaMainViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        
        _collectionView.contentInset = UIEdgeInsetsMake(CONTENT_INSET_TOP, 0, 0, 0);
    }
    return _collectionView;
}

- (void)addBannerViewForDetail
{
    _bannerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -CONTENT_INSET_TOP, 320, CONTENT_INSET_TOP)];
    _bannerImg.backgroundColor = [UIColor whiteColor];
    _bannerImg.contentMode = UIViewContentModeScaleAspectFill;
    _bannerImg.clipsToBounds = YES;
    
//    UIBezierPath* path = [UIBezierPath bezierPathWithRect:_bannerImg.bounds];
//    _bannerImg.layer.cornerRadius = 3;
//    _bannerImg.layer.shadowRadius = 3;
//    _bannerImg.layer.shadowOpacity = 0.1;
//    _bannerImg.layer.shadowPath = [path CGPath];
//    _bannerImg.layer.shadowColor = [[UIColor blackColor] CGColor];
//    _bannerImg.layer.shadowOffset = CGSizeMake(0, 0);
//    _bannerImg.layer.masksToBounds = YES;
    
    [self.collectionView addSubview:_bannerImg];
    
    _bannerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, CONTENT_INSET_TOP / 2)];
    _bannerTitle.backgroundColor = [UIColor clearColor];
    _bannerTitle.textAlignment = NSTextAlignmentCenter;
    _bannerTitle.textColor = [UIColor blackColor];
    _bannerTitle.font = [UIFont boldSystemFontOfSize:18];
    _bannerTitle.numberOfLines = 0;
    
    [_bannerImg addSubview:_bannerTitle];
}

#pragma mark - Life Cycle

- (id)initWithTitle:(NSString*)titleName channelId:(NSInteger)channelId
{
    self = [self initWithNibName:@"MMiaDetailViewController" bundle:nil];
    if( self )
    {
        _channelId = channelId;
        _titleName = titleName;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleString:_titleName];
    [self addBackBtnWithTarget:self selector:@selector(detailBack)];
    
    _detailImages = [NSMutableArray array];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.hidden = YES;
    [self addBannerViewForDetail];

    _isLoading = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getMagazineDetailDataForRequest];
}

- (void)getMagazineDetailDataForRequest
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_channelId],@"id", nil];
    
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_DETAIL_MAGAZIN_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary* dataDict)
     {
         _isLoading = NO;
         [MMiaLoadingView hideLoadingForView:self.view];
         if( [[dataDict objectForKey:@"msg"] isEqualToString:@"ok"] )
         {
             NSDictionary* detailDict = [dataDict objectForKey:@"data"];
//             NSLog( @"detailDict = %@", dataDict );
             
             NSArray* picArr = [detailDict objectForKey:@"pics"];
             
             // 解析杂志主页图片数据
             for( NSDictionary* picDict in picArr )
             {
                 MagezineItem* detailItem = [[MagezineItem alloc] init];
                 detailItem.pictureImageUrl = [picDict objectForKey:@"picUrl"];
                 detailItem.aId = [[picDict objectForKey:@"id"] intValue];
                 detailItem.title = [picDict objectForKey:@"picTitle"];
                 detailItem.imageWidth = [[picDict objectForKey:@"width"] floatValue];
                 detailItem.imageHeight = [[picDict objectForKey:@"height"] floatValue];
                 
                 if( detailItem.pictureImageUrl.length > 0 )
                 {
                     [self.detailImages addObject:detailItem];
                 }
             }
             if( _collectionView.hidden )
             {
                 _collectionView.hidden = NO;
             }
             [self.collectionView reloadData];
             
             if( picArr.count >= Request_Data_Count )
             {
                 [self addRefreshFooter];
             }
             
            [_bannerImg setImageFromURL:[NSURL URLWithString:[detailDict objectForKey:@"banner"]] placeHolderImage:[UIImage imageNamed:@"banner_icon.jpg"]];
             _bannerTitle.text = [detailDict objectForKey:@"magazineTitle"];
         }
         else
         {
             [self netWorkError:nil];
         }
         
     } errorHandler:^(NSError* error)
     {
         [self netWorkError:error];
     }];
}

- (void)getDetailContentDataForRequest
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_channelId],@"id", [NSNumber numberWithLong:self.detailImages.count],@"start",[NSNumber numberWithInt:Request_Data_Count],@"size", nil];
    
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_DETAIL_CONTENT_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary* dataDict)
     {
         _isLoading = NO;
         if( [[dataDict objectForKey:@"msg"] isEqualToString:@"ok"] )
         {
             NSArray* picArr = [dataDict objectForKey:@"data"];
//             NSLog( @"refdetailDict = %@", dataDict );
             
             // 解析杂志主页图片数据
             for( NSDictionary* picDict in picArr )
             {
                 MagezineItem* item = [[MagezineItem alloc] init];
                 item.pictureImageUrl = [picDict objectForKey:@"pictureUrl"];
                 item.aId = [[picDict objectForKey:@"id"] intValue];
                 item.title = [picDict objectForKey:@"title"];
                 item.imageWidth = [[picDict objectForKey:@"width"] floatValue];
                 item.imageHeight = [[picDict objectForKey:@"height"] floatValue];
                 
                 if( item.pictureImageUrl.length > 0 )
                 {
                     [self.detailImages addObject:item];
                 }
             }
             [_collectionView footerEndRefreshing];
             [self.collectionView reloadData];
             if( picArr.count < Request_Data_Count )
             {
                 [self removeRefreshFooter];
             }
         }
         else
         {
             [self netWorkError:nil];
         }
         
     } errorHandler:^(NSError* error)
     {
         [self netWorkError:error];
     }];
}

- (void)netWorkError:(NSError *)error
{
    if( _isLoading )
    {
        _isLoading = NO;
        [MMiaLoadingView hideLoadingForView:self.view];
    }
    [_collectionView footerEndRefreshing];
    
//    NSLog( @"detErrorDes = %@", [error localizedDescription] );
    
    // 无网络
    NSString* errStr = @"无法访问网络,请稍候重试...";
    UIImage*  errImg = [UIImage imageNamed:@"netError2.png"];
    // 服务器接口出错或挂掉
    if( !error || [error code] == 404 )
    {
        errStr = @"内容加载错误,请稍后再试...";
        errImg = [UIImage imageNamed:@"netError1.png"];
    }
    else if( [error code] == 500 ) // 超时
    {
        errStr = @"网络不给力哦,请稍候重试...";
        errImg = [UIImage imageNamed:@"netError2.png"];
    }
    [MMIAutoAlertView showWithText:errStr topOffset:0 bottomOffset:0 image:nil];
}

- (void)detailBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.detailImages.count;;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMainViewWaterfallCell *cell =
    (MMiaMainViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                           forIndexPath:indexPath];
    
    MagezineItem* detaiItem = [self.detailImages objectAtIndex:indexPath.item];

    CGFloat aFloat = 0;
    NSString* nameStr = @"item_big_icon.jpg";
    if( detaiItem.imageWidth >= detaiItem.imageHeight )
    {
        nameStr = @"item_small_icon.jpg";
    }
    [cell.imageView setImageFromURL:[NSURL URLWithString:detaiItem.pictureImageUrl] placeHolderImage:[UIImage imageNamed:nameStr]];
    if( detaiItem.imageWidth )
    {
        aFloat = Homepage_Cell_Image_Width / detaiItem.imageWidth;
    }
    cell.imageView.frame = CGRectMake(0.f, cell.contentView.bounds.origin.y, Homepage_Cell_Image_Width, detaiItem.imageHeight * aFloat);

    NSString* lbText = detaiItem.title;
    cell.displayLabel.text = lbText;
    cell.displayLabel.numberOfLines = 0;
    cell.displayLabel.font = [UIFont boldSystemFontOfSize:13];
    
    aFloat = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:lbText];
    cell.displayLabel.frame = CGRectMake(0.f, cell.contentView.bounds.origin.y + cell.imageView.frame.size.height, Homepage_Cell_Image_Width, aFloat);
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* detItem = [self.detailImages objectAtIndex:indexPath.item];
    
    CGFloat detailFloat = 0;
    if( detItem.imageWidth )
    {
        detailFloat = Homepage_Cell_Image_Width / detItem.imageWidth;
    }
    CGFloat labelHeight = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:detItem.title];
    CGSize size = CGSizeMake(Homepage_Cell_Image_Width, detItem.imageHeight * detailFloat + labelHeight);

    return size;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaDetailImgeViewController* imageVC = [[MMiaDetailImgeViewController alloc] init];
//    imageVC.id = [[NSNumber numberWithInt:_channelId] stringValue];
    
    [self.navigationController pushViewController:imageVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

#pragma mark - add上拉加载更多数据

- (void)addRefreshFooter
{
    __block MMiaDetailViewController* detVC = self;
    [_collectionView addFooterWithCallback:^{
        if( detVC->_isLoading )
            return;
        detVC->_isLoading = YES;
        [detVC getDetailContentDataForRequest];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_collectionView isFooterHidden])
    {
        [_collectionView removeFooter];
    }
}

@end
