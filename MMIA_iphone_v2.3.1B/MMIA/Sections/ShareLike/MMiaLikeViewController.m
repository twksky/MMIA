//
//  MMiaLikeViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 14-9-10.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaLikeViewController.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MMiaCommonUtil.h"
#import "MMiaErrorTipView.h"
#import "MMIToast.h"
#import "MJRefresh.h"

#define CELL_IDENTIFIER @"LoveWaterfallCell"

@interface MMiaLikeViewController () <MMiaErrorTipViewDelegate>
{
    NSInteger _userId;
    NSString* _ticket;
    NSInteger _downNum;
    BOOL      _showErrTipView;
}

- (void)getProductLikeDataByRequest:(NSInteger)start;
- (void)refreshLikePage;
- (void)netWorkError:(NSError *)error;

@end

@implementation MMiaLikeViewController

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
        _collectionView.contentInset = UIEdgeInsetsMake(self.collectionInset, 0, 0, 0);
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
    
   self.likeDataArr = [[NSMutableArray alloc]init];
    //[self addRefreshHeader];
    _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getProductLikeDataByRequest:0];
    NSString *nodataStr;
    if (self.isOthers)
    {
        nodataStr=@"Ta还没有喜欢的分享,去其他地方看看吧!";
    }else
    {
        nodataStr=@"精彩在于发现,喜欢就收集起来!";
    }
    self.noDataView=[[MMiaNoDataView alloc]initWithImageName:@"no_like.png" TitleLabel:nodataStr height:40];
    self.noDataView.hidden=YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.noDataView];
}

#pragma mark - Public

- (void)getProductLikeDataByRequest:(NSInteger)start
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:self.userId],@"userid", [NSNumber numberWithLong:start],@"start", [NSNumber numberWithInt:Request_Data_Count],@"size", userTicket,@"ticket", nil];
    NSString* url = @"ados/love/getProductLike";
    [app.mmiaDataEngine startAsyncRequestWithUrl:url param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject)
     {
         if ([jsonObject[@"result"] intValue]==0)
         {
        
            NSArray* likeArray = jsonObject[@"data"];
             _downNum = [jsonObject[@"num"] intValue];
             
             if( _isRefresh )
             {
                 [self.likeDataArr removeAllObjects];
             }
             
             for( NSDictionary *dict in likeArray)
             {
                 MagezineItem* item =[[MagezineItem alloc] init];
                 
                 item.aId = [[dict objectForKey:@"id"] intValue];
                 item.pictureImageUrl = [dict objectForKey:@"imgUrl"];
                 item.logoWord = [dict objectForKey:@"description"];
                 item.likeNum = [[dict objectForKey:@"supportNum"] intValue];
                 item.imgPrice = [[dict objectForKey:@"price"] floatValue];
                 item.userId = [[dict objectForKey:@"userId"] intValue];
                 item.magazineId = [[dict objectForKey:@"productId"] intValue];
                 item.imageWidth = [[dict objectForKey:@"width"] floatValue];
                 item.imageHeight = [[dict objectForKey:@"height"] floatValue];
                 item.title=[dict objectForKey:@"title"];
                 if( item.pictureImageUrl.length > 0 )
                 {
                     [self.likeDataArr addObject:item];
                 }
             }
             if (self.likeDataArr.count==0)
             {
                self.noDataView.hidden=NO;
                 
             }else
             {
                self.noDataView.hidden=YES;
             }
             [self refreshLikePage];
         }else
         {
              self.noDataView.hidden=YES;
             [self netWorkError:nil];
            
         }
         
     } errorHandler:^(NSError *error){
         
             [self netWorkError:error];
     }];
}

- (void)viewBackToOriginalPosition
{
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.collectionView setContentOffset:CGPointMake(0, -self.collectionInset) animated:YES];
    }];
}

#pragma mark - Private

- (void)netWorkError:(NSError *)error
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
        _isRefresh = NO;
    }
    else
    {
        [_collectionView footerEndRefreshing];
    }
    if( self.likeDataArr.count == 0 )
    {
        CGFloat errTipY = (CGRectGetHeight(self.view.bounds) - self.collectionInset - 125)/2;
        CGFloat errTipX = CGRectGetWidth(self.view.bounds) / 2;
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

- (void)refreshLikePage
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
    [self.collectionView reloadData];
    
    if( _downNum >= Request_Data_Count )
    {
        [self addRefreshFooter];
    }
    else
    {
        [self removeRefreshFooter];
    }
}



#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.collectionView];
    _isLoadding = YES;
    self.collectionView.scrollEnabled = NO;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getProductLikeDataByRequest:0];
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio
{
    return self.likeDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMainViewWaterfallCell *cell =
    (MMiaMainViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                           forIndexPath:indexPath];
    cell.layer.cornerRadius=4.0;
    cell.clipsToBounds=YES;
    
    cell.contentView.layer.cornerRadius=4.0;
    cell.contentView.clipsToBounds=YES;
    cell.contentView.backgroundColor=[UIColor clearColor];
    MagezineItem *item=[self.likeDataArr objectAtIndex:indexPath.item];
    
    CGFloat aFloat = 0;
   [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
    cell.imageView.clipsToBounds=YES;
    if( item.imageWidth )
    {
        aFloat = Homepage_Cell_Image_Width / item.imageWidth;
    }
    cell.imageView.frame = CGRectMake(0.f, cell.bounds.origin.y, Homepage_Cell_Image_Width, item.imageHeight * aFloat);
    
    NSString* lbText = item.title;
    cell.displayLabel.text = lbText;
     cell.displayLabel.textAlignment=MMIATextAlignmentLeft;
    cell.displayLabel.numberOfLines = 0;
    CGFloat labelH = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:lbText];
    cell.displayLabel.frame = CGRectMake(6.f, cell.contentView.bounds.origin.y + cell.imageView.frame.size.height + 8, Homepage_Cell_Image_Width - 12, labelH);
    cell.likeLabel.text = [NSString stringWithFormat:@"%ld", (long)item.likeNum];
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* item = [self.likeDataArr objectAtIndex:indexPath.item];
    
    CGFloat afloat = 0;
    
    if( item.imageWidth )
    {
        afloat = Homepage_Cell_Image_Width / item.imageWidth;
    }
    CGFloat labelHeight = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:item.title];
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
    self.indexPath = indexPath;
    MagezineItem* item = [self.likeDataArr objectAtIndex:indexPath.item];
    self.selectItem = item;
    if ([self.delegate respondsToSelector:@selector(likeviewController:didSelectItemAtIndexPath:)])
    {
        [self.delegate likeviewController:self didSelectItemAtIndexPath:indexPath];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if( scrollView.contentOffset.y >= CGRectGetHeight(self.view.frame) )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTopButton" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTopButton" object:nil];
    }

    if ([self.delegate respondsToSelector:@selector(likeScrollViewDidScrollViewController:ContentOffset:contentInset:)])
    {
        [self.delegate likeScrollViewDidScrollViewController:self ContentOffset:scrollView.contentOffset.y contentInset:self.collectionInset];
    }
}



#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaLikeViewController* likeVC = self;
    [self.collectionView addHeaderWithCallback:^{
        if( likeVC->_isLoadding )
            return;
        
        if( likeVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:likeVC.collectionView];
        }
        likeVC->_isRefresh = YES;
        likeVC->_isLoadding = YES;
        [likeVC getProductLikeDataByRequest:0];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaLikeViewController* likeVC = self;
    [self.collectionView addFooterWithCallback:^{
        if( likeVC->_isLoadding )
            return;
        likeVC->_isRefresh = NO;
        likeVC->_isLoadding = YES;
        [likeVC getProductLikeDataByRequest:likeVC.likeDataArr.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_collectionView isFooterHidden])
    {
        [_collectionView removeFooter];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
