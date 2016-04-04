//
//  MMiaHotMagzineViewController.m
//  MMIA
//
//  Created by yhx on 14-8-14.
//  Copyright (c) 2014年 广而告之. All rights reserved.
//

#import "MMiaHotMagzineViewController.h"
#import "MMiaMainViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "MagezineItem.h"
#import "MMIToast.h"
#import "MMiaErrorTipView.h"
#import "MMiaCommonUtil.h"

#define CELL_IDENTIFIER @"WaterfallCell"

@interface MMiaHotMagzineViewController () <CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource, MMiaErrorTipViewDelegate>
{
    NSIndexPath* _selectIndexPath;
    
    BOOL _isLoadding;
    BOOL _isRefresh;
    BOOL _showErrTipView;
}

@property (nonatomic, strong) NSArray* dataArr;

- (void)getHotMagzineDataForRequest:(NSInteger)start size:(int)size;
- (void)addRefreshHeader;
- (void)addRefreshFooter;
- (void)removeRefreshFooter;

@end

@implementation MMiaHotMagzineViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
        layout.minimumColumnSpacing = 7;
        layout.minimumInteritemSpacing = 7;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.clipsToBounds = NO;
        _collectionView.alwaysBounceVertical = YES;
        //_collectionView.showsVerticalScrollIndicator = NO;
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataRequest:) name:Change_LikeData object:nil];
}

#pragma mark - Private

- (void)getHotMagzineDataForRequest:(NSInteger)start size:(int)size
{
    AppDelegate* app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary* dict = @{@"type":[NSNumber numberWithInt:1], @"categoryId":[NSNumber numberWithLong:self.channelId], @"start":[NSNumber numberWithLong:start], @"size":[NSNumber numberWithInt:size]};
    
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_SINGL_HOTANEW_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject)
     {
         if( [jsonObject[@"result"] intValue] == 0 )
         {
             //NSLog( @"allArray = %@", jsonObject[@"data"] );

             NSMutableArray* hotArr = [NSMutableArray arrayWithArray:self.dataArr];
             if( _isRefresh )
             {
                 [hotArr removeAllObjects];
             }
             
             for( NSDictionary *hotDict in jsonObject[@"data"] )
             {
                 MagezineItem* hotItem = [[MagezineItem alloc] init];
                 hotItem.aId = [hotDict[@"id"] intValue];
                 hotItem.pictureImageUrl = hotDict[@"pictureUrl"];
                 hotItem.logoWord = hotDict[@"logoWord"];
                 hotItem.userId = [hotDict[@"userId"] intValue];
                 hotItem.magazineId = [hotDict[@"productId"] intValue];
                 hotItem.imageWidth = [hotDict[@"width"] floatValue];
                 hotItem.imageHeight = [hotDict[@"height"] floatValue];
                 hotItem.imgPrice = [hotDict[@"price"] floatValue];
                 hotItem.likeNum = [hotDict[@"supportNum"] intValue];
                 [hotArr addObject:hotItem];
             }
             [self refreshPageData:hotArr downNum:[jsonObject[@"num"] intValue]];
         }
         else
         {
             [self netWorkError:nil];
         }
         
     } errorHandler:^(NSError *error){
         
         [self netWorkError:error];
     }];
}

#pragma mark - Public

- (void)refreshPageData:(NSArray *)dataArray downNum:(NSInteger)num
{
    self.collectionView.scrollEnabled = YES;
    if( _isLoadding )
    {
        _isLoadding = NO;
        [MMiaLoadingView hideLoadingForView:self.view];
    }
    if( _isRefresh )
    {
        [_collectionView headerEndRefreshing];
        /*
         if( [self.dataArr count] > 0 )
         {
         int count = [_collectionView numberOfItemsInSection:0];
         if( count > 0 )
         {
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
         [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
         }
         }
         */
        _isRefresh = NO;
    }
    else
    {
        [_collectionView footerEndRefreshing];
    }
    
    //if( ![self.dataArr isEqualToArray:dataArray] )
    if( self.dataArr != dataArray )
    {
        self.dataArr = dataArray;
        
        if( self.collectionView.hidden )
            self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        
        // 根据最新请求的数据个数显示加载更多
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

- (void)netWorkError:(NSError *)error
{
    // 点击重新加载失败 or 加载更多失败
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
    if( self.dataArr.count == 0 )
    {
        CGFloat errTipY = (CGRectGetHeight(self.collectionView.bounds) - 125)/2;
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

- (void)refreshDataRequest:(NSNotification*)notification
{
    // 刷新喜欢数量
    if( _selectIndexPath )
    {
        NSArray* array = @[_selectIndexPath];
        MagezineItem* item = self.dataArr[_selectIndexPath.row];
        item.likeNum += [notification.userInfo[Add_Like_Num] intValue];
        [self.collectionView reloadItemsAtIndexPaths:array];
    }
}

- (void)backToViewTopPosition
{
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Change_LikeData object:nil];
}

#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.collectionView];
    _isLoadding = YES;
    self.collectionView.scrollEnabled = NO;
    [MMiaLoadingView showLoadingForView:self.view];
    
    [self getHotMagzineDataForRequest:self.dataArr.count size:Request_Data_Count];
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
    MagezineItem *item = self.dataArr[indexPath.item];
    
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
    cell.displayLabel.textAlignment = NSTextAlignmentLeft;
    
    CGFloat labelH = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:lbText];
    cell.displayLabel.frame = CGRectMake(6.f, cell.contentView.bounds.origin.y + cell.imageView.frame.size.height + 8, Homepage_Cell_Image_Width - 12, labelH);

    cell.likeLabel.text = [NSString stringWithFormat:@"%ld", (long)item.likeNum];
    /*
    if( item.imgPrice <= 0 )
    {
        cell.priceLabel.hidden = YES;
    }
    else
    {
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", item.imgPrice];
        CGFloat priceLabelWidth= [cell.priceLabel.text sizeWithFont:cell.priceLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width;
        cell.priceLabel.frame = CGRectMake( CGRectGetWidth(cell.imageView.frame) - priceLabelWidth - 10, CGRectGetMaxY(cell.imageView.frame) - 25, priceLabelWidth + 5, 20 );
    }
    */
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* item = self.dataArr[indexPath.item];
    
    CGFloat afloat = 0;
    
    if( item.imageWidth )
    {
        afloat = Homepage_Cell_Image_Width / item.imageWidth;
    }
    
    CGFloat labelHeight = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:item.logoWord];
    if( labelHeight > 0 )
    {
        labelHeight += 8;
    }
    labelHeight += 29;
    
    CGSize size = CGSizeMake(Homepage_Cell_Image_Width, item.imageHeight * afloat + labelHeight);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndexPath = indexPath;
    
    MMiaMainViewWaterfallCell* cell = (MMiaMainViewWaterfallCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MagezineItem* item = self.dataArr[indexPath.item];
    
    NSDictionary* dict = @{@"image":cell.imageView.image, @"item":item};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemAtPage" object:nil userInfo:dict];
}

#pragma mark - UIScrollViewDelegate

// 4滚动将要减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

// 6减速完成停下
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

// 1将要拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

// 3结束拖拽
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

// 2,5滚动
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
}

#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaHotMagzineViewController* hotVC = self;
    [_collectionView addHeaderWithCallback:^{
        if( hotVC->_isLoadding )
            return;
        
        if( hotVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:hotVC.collectionView];
        }
        hotVC->_isRefresh = YES;
        hotVC->_isLoadding = YES;
        [hotVC getHotMagzineDataForRequest:0 size:Request_Data_Count];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaHotMagzineViewController* hotVC = self;
    [_collectionView addFooterWithCallback:^{
        if( hotVC->_isLoadding )
            return;
        
        hotVC->_isRefresh = NO;
        hotVC->_isLoadding = YES;
        [hotVC getHotMagzineDataForRequest:hotVC.dataArr.count size:Request_Data_Count];
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