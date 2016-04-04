//
//  MMiaNewPageContainer.m
//  MMIA
//
//  Created by MMIA-Mac on 14-8-14.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaNewMagzineViewController.h"
#import "MMiaMainViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "MagezineItem.h"
#import "MMIToast.h"
#import "MMiaErrorTipView.h"
#import "MMiaCommonUtil.h"

#define CELL_IDENTIFIER @"WaterfallCell"

@interface MMiaNewMagzineViewController () <CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, MMiaErrorTipViewDelegate>
{
    NSIndexPath* _selectIndexPath;

    BOOL _isLoadding;
    BOOL _isRefresh;
    BOOL _showErrTipView;
}

@property (nonatomic, strong) NSArray* dataArr;

- (void)getNewMagzineDataForRequest:(NSInteger)start size:(int)size;
- (void)addRefreshHeader;
- (void)addRefreshFooter;
- (void)removeRefreshFooter;

@end

@implementation MMiaNewMagzineViewController


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
    if (self) {
        // Custom initialization
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

- (void)getNewMagzineDataForRequest:(NSInteger)start size:(int)size
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary* dict = @{@"type":[NSNumber numberWithInt:0], @"categoryId":[NSNumber numberWithLong:self.channelId], @"start":[NSNumber numberWithLong:start], @"size":[NSNumber numberWithInt:size]};
    
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_SINGL_HOTANEW_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject)
     {
         if( [jsonObject[@"result"] intValue] == 0 )
         {
             //NSLog( @"allArray = %@", jsonObject[@"data"] );
             
             NSMutableArray* newArr = [NSMutableArray arrayWithArray:self.dataArr];
             if( _isRefresh )
             {
                 [newArr removeAllObjects];
             }
             
             for( NSDictionary *newDict in jsonObject[@"data"] )
             {
                 MagezineItem* newItem = [[MagezineItem alloc] init];
                 newItem.aId = [newDict[@"id"] intValue];
                 newItem.pictureImageUrl = newDict[@"pictureUrl"];
                 newItem.logoWord = newDict[@"logoWord"];
                 newItem.userId = [newDict[@"userId"] intValue];
                 newItem.magazineId = [newDict[@"productId"] intValue];
                 newItem.imageWidth = [newDict[@"width"] floatValue];
                 newItem.imageHeight = [newDict[@"height"] floatValue];
                 newItem.imgPrice = [newDict[@"price"] floatValue];
                 newItem.likeNum = [newDict[@"supportNum"] intValue];
                 [newArr addObject:newItem];
             }
             [self refreshPageData:newArr downNum:[jsonObject[@"num"] intValue]];
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
    
    //    NSLog( @"ErrorDes = %@", [error localizedDescription] );
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

    [self getNewMagzineDataForRequest:self.dataArr.count size:Request_Data_Count];
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
    
    MagezineItem* newItem = self.dataArr[indexPath.item];
    CGFloat aFloat = 0;
    NSString* nameStr = @"item_big_icon.jpg";
    if( newItem.imageWidth > newItem.imageHeight )
    {
        nameStr = @"item_small_icon.jpg";
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:newItem.pictureImageUrl] placeholderImage:[UIImage imageNamed:nameStr]];
    if( newItem.imageWidth )
    {
        aFloat = Homepage_Cell_Image_Width / newItem.imageWidth;
    }
    cell.imageView.frame = CGRectMake(0.f, cell.bounds.origin.y, Homepage_Cell_Image_Width, newItem.imageHeight * aFloat);
    
    NSString* lbText = newItem.logoWord;
    cell.displayLabel.text = lbText;
    cell.displayLabel.numberOfLines = 0;
    cell.displayLabel.textAlignment = NSTextAlignmentLeft;
    
    CGFloat labelH = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:lbText];
    cell.displayLabel.frame = CGRectMake(6.f, cell.contentView.bounds.origin.y + cell.imageView.frame.size.height + 8, Homepage_Cell_Image_Width - 12, labelH);
    
    cell.likeLabel.text = [NSString stringWithFormat:@"%ld", (long)newItem.likeNum];
    /*
    if( newItem.imgPrice <= 0 )
    {
        cell.priceLabel.hidden = YES;
    }
    else
    {
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", newItem.imgPrice];
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
    __block MMiaNewMagzineViewController* newVC = self;
    [_collectionView addHeaderWithCallback:^{
        if( newVC->_isLoadding )
            return;
        
        if( newVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:newVC.collectionView];
        }
        newVC->_isRefresh = YES;
        newVC->_isLoadding = YES;
        [newVC getNewMagzineDataForRequest:0 size:Request_Data_Count];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaNewMagzineViewController* newVC = self;
    [_collectionView addFooterWithCallback:^{
        if( newVC->_isLoadding )
            return;
        
        newVC->_isLoadding = YES;
        newVC->_isRefresh = NO;
        [newVC getNewMagzineDataForRequest:newVC.dataArr.count size:Request_Data_Count];
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
