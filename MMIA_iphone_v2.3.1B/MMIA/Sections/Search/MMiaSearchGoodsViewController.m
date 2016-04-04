//
//  MMiaSearchGoodsViewController.m
//  MMIA
//
//  Created by lixiao on 14-10-30.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaSearchGoodsViewController.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MMiaCommonUtil.h"
#import "MMiaErrorTipView.h"
#import "MMIToast.h"
#import "MJRefresh.h"
#import "MagezineItem.h"
#import "MMiaNoDataView.h"

#define CELL_IDENTIFIER @"goodsWaterfallCell"
#define Search_View_Tag        100
#define Delete_ImageView_Tag   101


@interface MMiaSearchGoodsViewController (){
    int        _userid;
    UITextField  *_searchTextFiled;
    NSInteger _downNum;
    BOOL      _isRefresh;
    BOOL      _showErrTipView;
     NSIndexPath *_indexPath;
}
@property(nonatomic,assign)CGFloat scrollHeight;
@property(nonatomic,retain)UIButton *topButton;

@end

@implementation MMiaSearchGoodsViewController

-(id)initWithUserid:(int)userid
{
    self=[super init];
    if (self)
    {
        _userid=userid;
    }
    return self;
}
- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
        layout.minimumColumnSpacing = 7;
        layout.minimumInteritemSpacing = 7;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
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


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
    self.collectionView.frame = self.view.bounds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(doSearchGoodsDataRequest:) name:Change_LikeData object:nil];
    self.goodsDataArr=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
     self.scrollHeight=CGRectGetHeight(self.view.bounds);
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self addRefreshHeader];
    _isLoadding = YES;
     [MMiaLoadingView showLoadingForView:self.view center:CGPointMake(0, 29 + VIEW_OFFSET + 44)];
    [self getGoodsDataByRequest:0];
   self.nodataView=[[MMiaNoDataView alloc]initWithImageName:@"no_goods.png" TitleLabel:@"抱歉！暂时没有找到相关商品" height:40];
    [self.collectionView addSubview: self.nodataView];
    self.nodataView.hidden=YES;

}


#pragma mark -bttonClick
-(void)bttonClick:(UIButton *)button
{
    if (button.tag==1001)
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

#pragma mark -sendRequest
- (void)getGoodsDataByRequest:(NSInteger)start
{
     AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_userid],@"userid",[NSNumber numberWithLong:start],@"start",[NSNumber numberWithInt:Request_Data_Count],@"size",[NSNumber numberWithInt:0],@"type",self.goodsKeyWord,@"keyword",nil];
    NSString *searchUrl=@"ados/search/searchWord";
    [app.mmiaDataEngine startAsyncRequestWithUrl:searchUrl param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
    {
         if ([jsonDict[@"result"] intValue]==0)
         {
             NSArray* goodsArray = jsonDict[@"data"];
               _downNum = [jsonDict[@"num"] intValue];
             if( _isRefresh )
             {
                 [self.goodsDataArr removeAllObjects];
             }
             
             for( NSDictionary *dict in goodsArray)
             {
                 MagezineItem* item =[[MagezineItem alloc] init];
                 
                 item.aId = [[dict objectForKey:@"id"] intValue];
                 item.pictureImageUrl = [dict objectForKey:@"imgUrl"];
                 item.logoWord = [dict objectForKey:@"imgTitle"];
                 item.likeNum = [[dict objectForKey:@"likeNum"] intValue];
                 item.imgPrice = [[dict objectForKey:@"price"] floatValue];
                 item.magazineId = [[dict objectForKey:@"productId"] intValue];
                 item.imageWidth = [[dict objectForKey:@"width"] floatValue];
                 item.imageHeight = [[dict objectForKey:@"height"] floatValue];
                 if( item.pictureImageUrl.length > 0 )
                 {
                     [self.goodsDataArr addObject:item];
                 }
             }
             if (self.goodsDataArr.count==0)
             {
                 self.nodataView.hidden=NO;
             }else
             {
                 self.nodataView.hidden=YES;
             }
             [self refreshGoodsPage];
         }else
         {
             [self netWorkError:nil];
         }
        
    }errorHandler:^(NSError *error)
    {
         [self netWorkError:error];
    }];
    
}

- (void)refreshGoodsPage
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
    if( self.goodsDataArr.count == 0 )
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

#pragma mark - MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
     self.collectionView.scrollEnabled = NO;
    [MMiaErrorTipView hideErrorTipForView:self.view];
    _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view center:CGPointMake(0, 29 + VIEW_OFFSET + 44)];
    [self getGoodsDataByRequest:0];
}


#pragma mark - UITextFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio
{
    return self.goodsDataArr.count;
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
    MagezineItem *item=[self.goodsDataArr objectAtIndex:indexPath.item];
    
    CGFloat aFloat = 0;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
    
    cell.imageView.clipsToBounds=YES;
    if( item.imageWidth )
    {
        aFloat = Homepage_Cell_Image_Width / item.imageWidth;
    }
    cell.imageView.frame = CGRectMake(0.f, cell.bounds.origin.y, Homepage_Cell_Image_Width, item.imageHeight * aFloat);
    
    NSString* lbText = item.logoWord;
    cell.displayLabel.text = lbText;
    cell.displayLabel.textAlignment=MMIATextAlignmentLeft;
    cell.displayLabel.numberOfLines = 0;
    CGFloat labelH = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:lbText];
    cell.displayLabel.frame = CGRectMake(6.f, cell.contentView.bounds.origin.y + cell.imageView.frame.size.height + 8, Homepage_Cell_Image_Width - 12, labelH);
    cell.likeLabel.text = [NSString stringWithFormat:@"%ld",(long) item.likeNum];
        return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* item = [self.goodsDataArr objectAtIndex:indexPath.item];
    
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
      _indexPath=indexPath;
    if ([self.delegate respondsToSelector:@selector(viewController:didSelectItemAtIndexPath:)])
    {
        [self.delegate viewController:self didSelectItemAtIndexPath:indexPath];
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
    if ([self.delegate respondsToSelector:@selector(searchGoodsScrollViewDidScroll)])
    {
        [self.delegate searchGoodsScrollViewDidScroll];
    }
}


#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaSearchGoodsViewController* goodsVC = self;
    [self.collectionView addHeaderWithCallback:^{
        if( goodsVC->_isLoadding )
            return;
        
        if( goodsVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:goodsVC.view];
        }
        goodsVC->_isRefresh = YES;
        goodsVC->_isLoadding = YES;
        [goodsVC getGoodsDataByRequest:0];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaSearchGoodsViewController* goodsVc = self;
    [self.collectionView addFooterWithCallback:^{
        if( goodsVc->_isLoadding )
            return;
        goodsVc->_isRefresh = NO;
        goodsVc->_isLoadding = YES;
        [goodsVc getGoodsDataByRequest:goodsVc.goodsDataArr.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_collectionView isFooterHidden])
    {
        [_collectionView removeFooter];
    }
}
#pragma mark -notification
-(void)doSearchGoodsDataRequest:(NSNotification *)nc
{
    if (_indexPath)
    {
        int likeNum=[[nc.userInfo objectForKey:Add_Like_Num]intValue];
        MagezineItem* item = [self.goodsDataArr objectAtIndex:_indexPath.item];
        item.likeNum+=likeNum;
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:_indexPath]];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
