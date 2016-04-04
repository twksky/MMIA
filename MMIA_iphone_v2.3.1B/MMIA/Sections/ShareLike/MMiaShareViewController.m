//
//  MMiaShareViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 14-9-10.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaShareViewController.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MMiaCommonUtil.h"
#import "MJRefresh.h"
#import "MMIToast.h"
#import "MMiaErrorTipView.h"
#import "MMiaDetailGoodsViewController.h"
#import "MMiaDetailPictureViewController.h"
#import "MMiaNoDataView.h"

#define CELL_IDENTIFIER @"ShareWaterfallCell"

@interface MMiaShareViewController () <MMiaErrorTipViewDelegate>
{
    NSInteger _userId;
    NSString* _ticket;
    NSInteger _downNum;
    BOOL      _isLoadding;
    BOOL      _isRefresh;
    BOOL      _showErrTipView;
     MMiaNoDataView *_nodataView;
    NSIndexPath *_indexPath;
}

- (void)getProductShareDataByRequest:(NSInteger)start;
- (void)refreshMyPage;
- (void)netWorkError:(NSError *)error;

@end

@implementation MMiaShareViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
        layout.minimumColumnSpacing = 7;
        layout.minimumInteritemSpacing = 7;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kNavigationBarHeight - VIEW_OFFSET) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[MMiaMainViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [self.view addSubview:self.collectionView];
    }
    return _collectionView;
}

#pragma mark - Life Cycle

- (id)initWithUserId:(NSInteger)userId ticket:(NSString *)ticket
{
    self = [super init];
    if( self )
    {
        _userId = userId;
        _ticket = ticket;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _userId = 1549;
       _ticket = @"dc1bd39b3677ad7e450a331a2ad966bb";
        _shareDataArr = [[NSMutableArray alloc] init];
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
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(doshareDataRequest:) name:Change_LikeData object:nil];
    self.view.backgroundColor = UIColorFromRGB(0xE1E1E1);
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
//    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
//    [self.navigationView addSubview:lineView];
//    [self setTitleString:@"分享"];
//    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
     _isLoadding = YES;
    [self addRefreshHeader];
    [MMiaLoadingView showLoadingForView:self.view];
    [self getProductShareDataByRequest:0];
    _nodataView=[[MMiaNoDataView alloc]initWithImageName:@"no_share.png" TitleLabel:@"这个地方还没有内容,赶快去分享商品或图片吧!" height:40];
    [self.collectionView addSubview:_nodataView];
    _nodataView.hidden=YES;
}

#pragma mark - Private

- (void)getProductShareDataByRequest:(NSInteger)start
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_userId],@"userid", [NSNumber numberWithLong:start],@"start", [NSNumber numberWithInt:Request_Data_Count],@"size", _ticket,@"ticket", nil];
    
    NSString* url = @"ados/share/getProductShare";
    [app.mmiaDataEngine startAsyncRequestWithUrl:url param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject)
     {
        // NSLog(@"sharejsonObject=%@",jsonObject);
        
         if ([jsonObject[@"result"] intValue]==0)
         {
             NSArray* shareArray = jsonObject[@"data"];
//             MyNSLog( @"shareArr = %@", shareArray );
             _downNum = [jsonObject[@"num"] intValue];
             
             if( _isRefresh )
             {
                 [self.shareDataArr removeAllObjects];
             }
             
             for( NSDictionary *dict in shareArray)
             {
                 MagezineItem* item =[[MagezineItem alloc] init];
                 
                 item.aId = [[dict objectForKey:@"id"] intValue];
                 item.pictureImageUrl = [dict objectForKey:@"imgUrl"];
                 item.logoWord = [dict objectForKey:@"description"];
                 item.likeNum = [[dict objectForKey:@"supportNum"] intValue];
                 item.imgPrice = [[dict objectForKey:@"price"] floatValue];
                 item.userId = [[dict objectForKey:@"magazineId"] intValue];
                 item.magazineId = [[dict objectForKey:@"productId"] intValue];
                 item.imageWidth = [[dict objectForKey:@"width"] floatValue];
                 item.imageHeight = [[dict objectForKey:@"height"] floatValue];
                  item.title=[dict objectForKey:@"title"];
                 if( item.pictureImageUrl.length > 0 )
                 {
                     [self.shareDataArr addObject:item];
                 }
             }
             if (self.shareDataArr.count==0)
             {
                 _nodataView.hidden=NO;
             }else
             {
                 _nodataView.hidden=YES;
             }
             [self refreshMyPage];
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
    if( self.shareDataArr.count == 0 )
    {
        CGFloat errTipY = (CGRectGetHeight(self.view.bounds) - 125)/2;
        CGFloat errTipX = CGRectGetWidth(self.view.bounds) / 2;
        [MMiaErrorTipView showErrorTipForView:self.view center:CGPointMake(errTipX, errTipY) error:error delegate:self];
        _showErrTipView = YES;
    }
    else
    {
        [MMiaErrorTipView showErrorTipForErroe:error];
        [MMiaErrorTipView hideErrorTipForView:self.view];
        _showErrTipView = NO;
    }
}

- (void)refreshMyPage
{
    if( _showErrTipView )
    {
        [MMiaErrorTipView hideErrorTipForView:self.view];
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

- (void)btnClick:(UIButton *)button
{
    if( button.tag == 1001 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - notificationRaquest
-(void)doshareDataRequest:(NSNotification *)nc
{
    if (_indexPath)
    {
        int likeNum=[[nc.userInfo objectForKey:Add_Like_Num]intValue];
        MagezineItem* item = [self.shareDataArr objectAtIndex:_indexPath.item];
        item.likeNum+=likeNum;
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:_indexPath]];
    }
}


#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.view];
    _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    
    [self getProductShareDataByRequest:0];
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio
{
    return self.shareDataArr.count;
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
    MagezineItem *item=[self.shareDataArr objectAtIndex:indexPath.item];
    
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
    
    NSString* lbText = item.title;
    cell.displayLabel.text = lbText;
    cell.displayLabel.textAlignment=MMIATextAlignmentLeft;
    cell.displayLabel.numberOfLines = 0;
    CGFloat labelH = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:lbText];
    cell.displayLabel.frame = CGRectMake(6.f, cell.contentView.bounds.origin.y + cell.imageView.frame.size.height + 8, Homepage_Cell_Image_Width - 12, labelH);
    cell.likeLabel.text = [NSString stringWithFormat:@"%ld", (long)item.likeNum];
    /*
    cell.supportNumLabel.text = [NSString stringWithFormat:@"￥%.2f", item.imgPrice];
    CGFloat supportLabelWidth= [cell.supportNumLabel.text sizeWithFont:cell.supportNumLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width;
    if (item.imgPrice==0.00) {
        cell.supportNumLabel.hidden=YES;
    }else
    {
        cell.supportNumLabel.hidden=NO;
    }

    cell.supportNumLabel.frame=CGRectMake(CGRectGetWidth(cell.imageView.frame)-supportLabelWidth-10, CGRectGetMaxY(cell.imageView.frame)-25,supportLabelWidth+5,20);
    cell.supportNumLabel.clipsToBounds=YES;
    cell.supportNumLabel.layer.cornerRadius=3.0;
    cell.supportNumLabel.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.4];
    cell.supportNumLabel.textColor=[UIColor whiteColor];
     */
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* item = [self.shareDataArr objectAtIndex:indexPath.item];
    
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
    _indexPath=indexPath;
      MagezineItem* item = [self.shareDataArr objectAtIndex:indexPath.item];
    if (item.magazineId>0)
    {
        MMiaDetailGoodsViewController *detailGoodsVC=[[MMiaDetailGoodsViewController alloc]initWithTitle:item.title Id:item.aId goodsImage:item.pictureImageUrl Width:item.imageWidth Height:item.imageHeight price:item.imgPrice productId:item.magazineId];
        detailGoodsVC.shareDelegate=self;
        [self.navigationController pushViewController:detailGoodsVC animated:YES];
    }else
    {
         MMiaDetailPictureViewController *detailPictureVC=[[MMiaDetailPictureViewController alloc]initWithTitle:item.title Id:item.aId goodsImage:item.pictureImageUrl Width:item.imageWidth Height:item.imageHeight price:item.imgPrice productId:item.magazineId];
        detailPictureVC.shareDelegate=self;
        [self.navigationController pushViewController:detailPictureVC animated:YES];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0)
    {
        scrollView.contentOffset=CGPointZero;
    }
}
-(void)returnShareVie
{
    if (_indexPath)
    {
        [self.shareDataArr removeObjectAtIndex:_indexPath.item];
        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:_indexPath]];
    }
}

#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaShareViewController* shareVC = self;
    [self.collectionView addHeaderWithCallback:^{
        if( shareVC->_isLoadding )
            return;
        
        if( shareVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:shareVC.view];
        }
        shareVC->_isRefresh = YES;
        shareVC->_isLoadding = YES;
        [MMiaLoadingView showLoadingForView:shareVC.view];
        [shareVC getProductShareDataByRequest:0];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaShareViewController* shareVC = self;
    [self.collectionView addFooterWithCallback:^{
        if( shareVC->_isLoadding )
            return;
        shareVC->_isRefresh = NO;
        shareVC->_isLoadding = YES;
        [shareVC getProductShareDataByRequest:shareVC.shareDataArr.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_collectionView isFooterHidden])
    {
        [_collectionView removeFooter];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Change_LikeData object:nil];
}


@end
