//
//  MMiaFullPageController.m
//  MMIA
//
//  Created by yhx on 14-10-30.
//  Copyright (c) 2014年 广而告之. All rights reserved.
//

#import "MMiaFullPageController.h"
#import "MMiaMainViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "MagezineItem.h"
#import "MMIToast.h"
#import "MMiaErrorTipView.h"
#import "MMiaCommonUtil.h"

#define CELL_IDENTIFIER @"WaterfallCell"

@interface MMiaFullPageController () <CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource, MMiaErrorTipViewDelegate>
{
    BOOL _isLoadding;
    BOOL _isRefresh;
    BOOL _showErrTipView;
}

@property (nonatomic, strong) NSArray*  dataArr;
@property (nonatomic, assign) NSInteger channelId;

- (void)getFullDataForRequest:(NSInteger)start size:(NSInteger)size;
- (void)addRefreshHeader;
- (void)addRefreshFooter;
- (void)removeRefreshFooter;

@end

@implementation MMiaFullPageController

#pragma mark - Accessors

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(0, 9, 9, 9);
        layout.minimumColumnSpacing = 7;
        layout.minimumInteritemSpacing = 7;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(self.collectionInset, 0, 0, 0);
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.clipsToBounds = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[MMiaMainViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        if( !_dataArr )
        {
            _dataArr = [[NSArray alloc] init];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self addRefreshHeader];
    [self initTitle];
}

- (void)initTitle{
    self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, 38)];
    self.titleView.backgroundColor =[UIColor colorWithRed:0x39 /255.0f green:0x3b /255.0f blue:0x49 /255.0f alpha:1];
    self.titleView.text=@"广而告之";
    self.titleView.textColor = [UIColor whiteColor];
    self.titleView.textAlignment = UITextAlignmentCenter;
    self.titleView.alpha = 0;
    [self.view addSubview:self.titleView];
}

- (void)getFullDataForRequest:(NSInteger)start size:(NSInteger)size
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary* dict = @{@"start":[NSNumber numberWithLong:start], @"size":[NSNumber numberWithLong:size]};
    
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_HOMEPAGE_FULL_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject)
     {
         if( [jsonObject[@"result"] intValue] == 0 )
         {
           //  MyNSLog( @"allArray = %@", jsonObject[@"data"] );
             NSMutableArray* fullArr = [NSMutableArray arrayWithArray:self.dataArr];
             if( _isRefresh )
             {
                 [fullArr removeAllObjects];
             }
             
             for( NSDictionary *dict in jsonObject[@"data"])
             {
                 MagezineItem* item =[[MagezineItem alloc] init];
                 
                 item.aId = [dict[@"id"] intValue];
                 item.pictureImageUrl = dict[@"pictureUrl"];
                 item.logoWord = dict[@"logoWord"];
                 item.userId = [dict[@"userId"] intValue];
                 item.magazineId = [dict[@"magazineId"] intValue];
                 item.imageWidth = [dict[@"width"] floatValue];
                 item.imageHeight = [dict[@"height"] floatValue];
                 item.type = [dict[@"isAttention"] intValue];
                 [fullArr addObject:item];
             }
             [self refreshPageData:fullArr downNum:[jsonObject[@"num"] intValue]];
         }
         else
         {
             [self netWorkError:nil];
         }
         
     } errorHandler:^(NSError *error){
         
         [self netWorkError:error];
     }];
}

- (void)netWorkError:(NSError *)error
{
    // 点击重新加载失败 or 加载更多失败
    self.collectionView.scrollEnabled = YES;
    if( _isLoadding )
    {
        _isLoadding = NO;
        [MMiaLoadingView hideLoadingForView:self.view];
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
    if( self.dataArr.count == 0 )
    {
        CGFloat errTipY = (CGRectGetHeight(self.collectionView.bounds) - self.collectionInset - 125)/2;
        CGFloat errTipX = CGRectGetWidth(self.collectionView.bounds) / 2;
        [MMiaErrorTipView showErrorTipForView:self.collectionView center:CGPointMake(errTipX, errTipY) error:error delegate:self];
        _showErrTipView = YES;
    }
    else
    {
        [MMiaErrorTipView showErrorTipForErroe:error];
        [MMiaErrorTipView hideErrorTipForView:self.collectionView];
        _showErrTipView = NO;
    }
}

- (void)viewBackToOriginalPosition
{
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.collectionView setContentOffset:CGPointMake(0, -self.collectionInset) animated:YES];
    }];
}

#pragma mark * Overwritten setters

- (void)setCollectionInset:(CGFloat)collectionInset
{
    if( _collectionInset != collectionInset )
    {
        _collectionInset = collectionInset;
    }
}

- (void)refreshPageData:(NSArray *)dataArray downNum:(NSInteger)num
{
    self.collectionView.scrollEnabled = YES;
    
    if( _showErrTipView )
    {
        [MMiaErrorTipView hideErrorTipForView:self.collectionView];
    }
    if( _isLoadding )
    {
        _isLoadding = NO;
        [MMiaLoadingView hideLoadingForView:self.view];
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
    if( self.dataArr != dataArray )
    {
        self.dataArr = dataArray;
        
        if( self.collectionView.hidden )
            self.collectionView.hidden = NO;
        [self.collectionView reloadData];

        if( num >= Request_Data_Count )
        {
            [self addRefreshFooter];
        }
        else
        {
            [self removeRefreshFooter];
        }
    }
}

#pragma mark - Private

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
}

#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.collectionView];
    _isLoadding = YES;
    self.collectionView.scrollEnabled = NO;
    [MMiaLoadingView showLoadingForView:self.view];
    
    [self getFullDataForRequest:self.dataArr.count size:Request_Data_Count];
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMainViewWaterfallCell *cell =
    (MMiaMainViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                           forIndexPath:indexPath];
    MagezineItem *item = [self.dataArr objectAtIndex:indexPath.item];
    
    CGFloat aFloat = 0;
    NSString* nameStr = @"item_big_icon.jpg";
    if( item.imageWidth > item.imageHeight )
    {
        nameStr = @"item_small_icon.jpg";
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl] placeholderImage:[UIImage imageNamed:nameStr]];
    if( item.imageWidth )
    {
        aFloat = Homepage_Cell_Image_Width / item.imageWidth;
    }
    cell.imageView.frame = CGRectMake(0.f, cell.bounds.origin.y, Homepage_Cell_Image_Width, item.imageHeight * aFloat);
    
    NSString* lbText = item.logoWord;
    cell.displayLabel.text = lbText;
    cell.displayLabel.numberOfLines = 0;
    
    CGFloat labelH = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:lbText];
    cell.displayLabel.frame = CGRectMake(6.f, cell.contentView.bounds.origin.y + cell.imageView.frame.size.height + 8, Homepage_Cell_Image_Width - 12, labelH);
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* item = [self.dataArr objectAtIndex:indexPath.item];
    
    CGFloat afloat = 0;
    
    if( item.imageWidth )
    {
        afloat = Homepage_Cell_Image_Width / item.imageWidth;
    }
    
    CGFloat labelHeight = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:item.logoWord];
    if( labelHeight > 0 )
    {
        labelHeight += 17;
    }
    
    CGSize size = CGSizeMake(Homepage_Cell_Image_Width, item.imageHeight * afloat + labelHeight);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMainViewWaterfallCell *cell=(MMiaMainViewWaterfallCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MagezineItem* item = self.dataArr[indexPath.item];
    
    NSDictionary* dict = @{@"image":cell.imageView.image, @"item":item};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemAtMain" object:nil userInfo:dict];
}
float headViewHeight =0;

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if( scrollView.contentOffset.y >= CGRectGetHeight(self.view.frame) )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTopButton" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTopButton" object:nil];
    }
    CGPoint point = scrollView.contentOffset;
    if (headViewHeight == 0) {
        headViewHeight = point.y;
    }
    float titleAlpha = 1 - point.y / headViewHeight;
    if (titleAlpha <= 1){
        self.titleView.alpha = titleAlpha;
    }
}

#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaFullPageController* fullVC = self;
    [_collectionView addHeaderWithCallback:^{
        if( fullVC->_isLoadding )
            return;
        
        if( fullVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:fullVC.collectionView];
        }
        fullVC->_isRefresh = YES;
        fullVC->_isLoadding = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMainPage" object:nil];
//        [fullVC getFullDataForRequest:0 size:Request_Data_Count];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaFullPageController* fullVC = self;
    [_collectionView addFooterWithCallback:^{
        if( fullVC->_isLoadding )
            return;
        fullVC->_isRefresh = NO;
        fullVC->_isLoadding = YES;
        [fullVC getFullDataForRequest:fullVC.dataArr.count size:Request_Data_Count];
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