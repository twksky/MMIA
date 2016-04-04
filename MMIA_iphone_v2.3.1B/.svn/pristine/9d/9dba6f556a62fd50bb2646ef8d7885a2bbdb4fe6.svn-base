//
//  MMiaTabLikeViewController.m
//  MMIA
//
//  Created by lixiao on 14-10-30.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaTabLikeViewController.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MMiaCommonUtil.h"
#import "MMiaErrorTipView.h"
#import "MMIToast.h"
#import "MJRefresh.h"
#import "MMiaDetailGoodsViewController.h"
#import "MMiaDetailPictureViewController.h"
#import "MMiaNoDataView.h"

#define CELL_IDENTIFIER @"LoveWaterfallCell"

@interface MMiaTabLikeViewController () <MMiaErrorTipViewDelegate>
{
    NSInteger _downNum;
    BOOL      _isLoadding;
    BOOL      _isRefresh;
    BOOL      _showErrTipView;
    MMiaNoDataView *_nodataView;
    NSIndexPath *_indexPath;
    MagezineItem *_selectItem;
    BOOL          _showError;
}

@property(nonatomic,assign)CGFloat scrollHeight;

@end


@implementation MMiaTabLikeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:NO];
}

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
        layout.minimumColumnSpacing = 7;
        layout.minimumInteritemSpacing = 7;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kNavigationBarHeight - VIEW_OFFSET-45) collectionViewLayout:layout];
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

- (UIButton *)topButton
{
    if( !_topButton )
    {
        UIImage* image = [UIImage imageNamed:@"backTop.png"];
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - image.size.width, self.scrollHeight - image.size.height - 10, image.size.width, image.size.height);
        _topButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_topButton setBackgroundImage:image forState:UIControlStateNormal];
        _topButton.backgroundColor = [UIColor clearColor];
        [_topButton addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_topButton];
    }
    return _topButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _showError=YES;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:PERSON_LIKE_HAVE];
     [defaults synchronize];
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(dolikeDataRequest:) name:Change_LikeData object:nil];
    self.scrollHeight=CGRectGetHeight(self.view.bounds) - 45;
    self.likeDataArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor = UIColorFromRGB(0xE1E1E1);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    
    [self setTitleString:@"喜欢"];
    [self addRefreshHeader];
    _isLoadding = YES;
    self.collectionView.scrollEnabled = NO;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getProductLikeDataByRequest:0];
    
    NSString *nodataStr;
        nodataStr=@"精彩在于发现,喜欢就收集起来!";
    _nodataView=[[MMiaNoDataView alloc]initWithImageName:@"no_like.png" TitleLabel:nodataStr height:40];
    [self.collectionView addSubview:_nodataView];
    _nodataView.hidden=YES;
}

#pragma mark - Private

- (void)getProductLikeDataByRequest:(NSInteger)start
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket=@"";
    }
    if (!userId)
    {
        userId=0;
    }
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:userId],@"userid", [NSNumber numberWithLong:start],@"start", [NSNumber numberWithLong:Request_Data_Count],@"size",userTicket,@"ticket", nil];
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
             if ( self.likeDataArr.count == 0 )
             {
                 _nodataView.hidden=NO;
                 
             }else
             {
                 _nodataView.hidden=YES;
             }
             [self refreshLikePage];
         }
         else
         {
             _nodataView.hidden=YES;
             if (_showError)
             {
                 [self netWorkError:nil];
             }
             
         }
         
     } errorHandler:^(NSError *error){
         if (_showError)
         {
             [self netWorkError:error];
         }
         
         
     }];
}

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

- (void)refreshLikePage
{
    self.collectionView.scrollEnabled = YES;
    
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

- (void)topBtnClicked:(UIButton *)button
{
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
}

#pragma mark -notificationRequest

-(void)dolikeDataRequest:(NSNotification *)nc
{
    if (_isLoadding)
    {
        return;
    }
    _isLoadding=YES;
    _isRefresh=YES;
    _showError=NO;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getProductLikeDataByRequest:0];
    
}

#pragma mark -delegate
-(void)returnTabLikeVieW
{
    if (_indexPath)
    {
        [self.likeDataArr removeObjectAtIndex:_indexPath.item];
        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:_indexPath]];
    }
    
}


-(void)refreshLikeData
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.view];
    if (_isLoadding) {
        return;
    }
    [self.likeDataArr removeAllObjects];
    [self.collectionView reloadData];

    _isLoadding = YES;
    self.collectionView.scrollEnabled = NO;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getProductLikeDataByRequest:0];
}

#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.view];
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
    /*
    cell.supportNumLabel.text = [NSString stringWithFormat:@"￥%.2f", item.imgPrice];
    CGFloat supportLabelWidth= [cell.supportNumLabel.text sizeWithFont:cell.supportNumLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width;
    if (item.imgPrice==0.00)
    {
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
    _indexPath=indexPath;
    MagezineItem* item = [self.likeDataArr objectAtIndex:indexPath.item];
    _selectItem=item;
    if (item.magazineId>0)
    {
        MMiaDetailGoodsViewController *detailGoodsVC=[[MMiaDetailGoodsViewController alloc]initWithTitle:item.title Id:item.aId goodsImage:item.pictureImageUrl Width:item.imageWidth Height:item.imageHeight price:item.imgPrice productId:item.magazineId];
        detailGoodsVC.tabLikeDelegate=self;
        [self.navigationController pushViewController:detailGoodsVC animated:YES];
    }
    else
    {
        MMiaDetailPictureViewController *detailPictureVC=[[MMiaDetailPictureViewController alloc]initWithTitle:item.title Id:item.aId goodsImage:item.pictureImageUrl Width:item.imageWidth Height:item.imageHeight price:item.imgPrice productId:item.magazineId];
        detailPictureVC.tabLikeDelegate=self;
        [self.navigationController pushViewController:detailPictureVC animated:YES];
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if( scrollView.contentOffset.y >= CGRectGetHeight(self.view.frame) )
    {
        self.topButton.hidden=NO;
    }
    else
    {
       self.topButton.hidden=YES;
    }
}

#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaTabLikeViewController* likeVC = self;
    [self.collectionView addHeaderWithCallback:^{
        if( likeVC->_isLoadding )
            return;
        
        if( likeVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:likeVC.view];
        }
        likeVC->_isRefresh = YES;
        likeVC->_isLoadding = YES;
        [likeVC getProductLikeDataByRequest:0];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaTabLikeViewController* likeVC = self;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
