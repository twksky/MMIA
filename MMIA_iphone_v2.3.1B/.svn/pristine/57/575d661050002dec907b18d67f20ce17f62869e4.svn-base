//
//  MMiaConcernSpecialViewController.m
//  MMIA
//
//  Created by lixiao on 15/2/5.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMiaConcernSpecialViewController.h"
#import "MMiaNoDataView.h"
#import "MMiaMainViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MMiaErrorTipView.h"
#import "MMiaCommonUtil.h"
#import "MMIToast.h"
#import "AppDelegate.h"
#import "MJRefresh.h"

#define CELL_IDENTIFIER @"SpecialWaterfallCell"

@interface MMiaConcernSpecialViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>{
    MMiaNoDataView  *_noDataView;
    BOOL            _showErrTipView;
    NSInteger       _downNum;
    
}

@end

@implementation MMiaConcernSpecialViewController

#pragma mark - init

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

#pragma mark - LifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.specialArray = [[NSMutableArray alloc]init];
    _noDataView = [[MMiaNoDataView alloc]initWithImageName:@"no_share.png" TitleLabel:@"还没有专题，去其他地方看看吧!" height:40];
    _noDataView.hidden = YES;
    [self.collectionView addSubview:_noDataView];
    [self.view addSubview:self.collectionView];
    _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getUserMagazineRequestStart:0 Size:Request_Data_Count];
}

#pragma mark - buttonClick

- (void)concernButtonClick:(UIButton *)button
{
    NSIndexPath *indexPath=[_collectionView indexPathForCell:(UICollectionViewCell *)[[button superview]superview]];
    MagezineItem *item=[self.specialArray objectAtIndex:indexPath.item];
    if (item.likeNum==0)
    {
        [self FollowmagazineRequestMagazineid:button];
    }else
    {
        [self cancelFollowmagazineRequestMagazineid:button];
    }
    [button setEnabled:NO];
}

#pragma mark - Public

- (void)doReturnSpecialBlock:(int)concern indexPath:(NSIndexPath *)indexPath
{
    MagezineItem *item=[self.specialArray objectAtIndex:indexPath.row];
    if (concern == 1) {
        MagezineItem *newItem = item;
        newItem.likeNum=1;
        [self.specialArray replaceObjectAtIndex:indexPath.row withObject:newItem];
    }else if (concern == -1)
    {
        MagezineItem *newItem=item;
        newItem.likeNum=0;
        [self.specialArray replaceObjectAtIndex:indexPath.row withObject:newItem];
    }
    [self.collectionView reloadData];
}

- (void)viewBackToOriginalPosition
{
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.collectionView setContentOffset:CGPointMake(0, -self.collectionInset) animated:YES];
    }];
}

#pragma mark - sendRequest

- (void)getUserMagazineRequestStart:(NSInteger)start Size:(int)size
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket=@"";
    }
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:self.userId],@"userid",[NSNumber numberWithLong:start],@"start",[NSNumber numberWithInt:size],@"size",userTicket,@"ticket", nil];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_GET_USER_MAGEZINE_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        if ([jsonDict[@"result"]intValue]==0) {
            _downNum = [jsonDict[@"num"] intValue];
            if( _isRefresh )
            {
                [self.specialArray removeAllObjects];
            }
            NSArray *dataArray=jsonDict[@"data"];
            for (NSDictionary *infoDict in dataArray) {
                MagezineItem *item=[[MagezineItem alloc]init];
                item.title=[infoDict objectForKey:@"title"];
                item.aId=[[infoDict objectForKey:@"id"]intValue];
                item.userId=[[infoDict objectForKey:@"supportNum"]intValue];
                item.pictureImageUrl=[infoDict objectForKey:@"imgUrl"];
                item.imageHeight=[[infoDict objectForKey:@"height"]floatValue];
                item.imageWidth=[[infoDict objectForKey:@"width"]floatValue];
                //是否关注
                item.likeNum=[[infoDict objectForKey:@"isAttention"]intValue];
                [self.specialArray addObject:item];
            }
            if (self.specialArray.count==0)
            {
                _noDataView.hidden=NO;
            }else
            {
                _noDataView.hidden=YES;
            }
            
            [self refreshConcernMagezinePage];
            
            
        }else{
            [MMIToast showWithText:jsonDict[@"msg"] topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
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
            _showErrTipView = NO;
        }
        
    }errorHandler:^(NSError *error){
        
        [self netWorkError:error];
    }];
}

//取消关注杂志
- (void)cancelFollowmagazineRequestMagazineid:(UIButton *)button
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:(UICollectionViewCell *)[[button superview]superview]];
    MagezineItem *item = [self.specialArray objectAtIndex:indexPath.item];
    NSInteger magezineId = item.aId;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userId = [[defaults objectForKey:USER_ID]intValue];
    NSString *userTicket = [defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket=@"";
    }
    if (!userId)
    {
        userId=0;
    }
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:userTicket,@"ticket",[NSNumber numberWithInt:userId],@"myUserid",[NSNumber numberWithLong:magezineId],@"magazineid", nil];
    
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_CANCEL_FOLLOWMAGZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         [button setEnabled:YES];
         if ([jsonDict[@"result"]intValue]==0)
         {
             MagezineItem *newItem = item;
             item.likeNum = 0;
             [self.specialArray replaceObjectAtIndex:indexPath.item withObject:newItem];
             [button setBackgroundImage:[UIImage imageNamed:@"concern.png"] forState:UIControlStateNormal];
             [MMIToast showWithText:@"取消关注成功" topOffset:Main_Screen_Height-20 image:nil];
         }else
         {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
         }
     }errorHandler:^(NSError *error){
         [button setEnabled:YES];
         [MMIToast showWithText:@"取消关注失败" topOffset:Main_Screen_Height-20 image:nil];
     }];
}

//关注专题
- (void)FollowmagazineRequestMagazineid:(UIButton *)button
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:(UICollectionViewCell *)[[button superview]superview]];
    MagezineItem *item = [self.specialArray objectAtIndex:indexPath.item];
    NSInteger magezineId = item.aId;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userId = [[defaults objectForKey:USER_ID]intValue];
    NSString *userTicket = [defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket = @"";
    }
    if (!userId)
    {
        userId = 0;
    }
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:userTicket,@"ticket",[NSNumber numberWithInt:userId],@"myUserid",[NSNumber numberWithLong:magezineId],@"magazineid", nil];
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_FOLLOWMAGZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         [button setEnabled:YES];
         if ([jsonDict[@"result"]intValue] == 0)
         {
             MagezineItem *newItem = item;
             item.likeNum = 1;
             [self.specialArray replaceObjectAtIndex:indexPath.item withObject:newItem];
             [button setBackgroundImage:[UIImage imageNamed:@"not_concern.png"] forState:UIControlStateNormal];
             [MMIToast showWithText:@"关注成功" topOffset:Main_Screen_Height-20 image:nil];
             
         }else
         {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
         }
     }errorHandler:^(NSError *error){
         [button setEnabled:YES];
         [MMIToast showWithText:@"取消关注失败" topOffset:Main_Screen_Height-20 image:nil];
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

#pragma mark - private

- (void)refreshConcernMagezinePage
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
    [_collectionView reloadData];
    
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
    if( self.specialArray.count==0 )
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

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.collectionView];
    _isLoadding = YES;
    self.collectionView.scrollEnabled = NO;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getUserMagazineRequestStart:0 Size:Request_Data_Count];
}

#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaConcernSpecialViewController *specialVC = self;
    [self.collectionView addHeaderWithCallback:^{
        if( specialVC->_isLoadding )
            return;
        
        if( specialVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:specialVC.collectionView];
        }
        specialVC->_isRefresh = YES;
        specialVC->_isLoadding = YES;
        [specialVC getUserMagazineRequestStart:0 Size:Request_Data_Count];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaConcernSpecialViewController *specialVC = self;
    [_collectionView addFooterWithCallback:^{
        if(specialVC->_isLoadding )
            return;
        specialVC->_isRefresh = NO;
        specialVC->_isLoadding = YES;
        [specialVC getUserMagazineRequestStart:specialVC.specialArray.count Size:Request_Data_Count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_collectionView isFooterHidden])
    {
        [_collectionView removeFooter];
    }
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.specialArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMainViewWaterfallCell *cell =
    (MMiaMainViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                           forIndexPath:indexPath];
    
    if (self.specialArray.count==0) {
        return cell;
    }
    
    MagezineItem *item=[self.specialArray objectAtIndex:indexPath.item];
    
    cell.displayLabel.frame=CGRectMake(5, cell.bounds.origin.y, Homepage_Cell_Image_Width-36, 30);
    cell.displayLabel.textAlignment=MMIATextAlignmentLeft;
    NSString *titleStr=item.title;
    cell.displayLabel.text=titleStr;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl] placeholderImage:nil];
    CGFloat rate,height;
    if (item.imageWidth!=0) {
        rate=(Homepage_Cell_Image_Width-4)/item.imageWidth;
    }
    if (rate!=0) {
        height=196*rate;
    }
    cell.imageView.frame=CGRectMake(2, 30, Homepage_Cell_Image_Width-4, height);
    cell.imageView.clipsToBounds=YES;
    cell.imageView.layer.cornerRadius=2.0;
    cell.supportNumLabel.text=[NSString stringWithFormat:@"%ld",(long)item.userId];
    CGFloat supportLabelWidth= [cell.supportNumLabel.text sizeWithFont:cell.supportNumLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width;
    cell.supportNumLabel.frame=CGRectMake(10, 100,supportLabelWidth+20, 20);
    cell.supportNumLabel.clipsToBounds=YES;
    cell.supportNumLabel.layer.cornerRadius=3.0;
    cell.supportNumLabel.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.4];
    cell.supportNumLabel.textColor=[UIColor whiteColor];
    UIImage *concernImage=[UIImage imageNamed:@"concern.png"];
    cell.button.frame=CGRectMake((Homepage_Cell_Image_Width-concernImage.size.width)/2.0, CGRectGetMaxY(cell.imageView.frame)+5, concernImage.size.width, concernImage.size.height);
    
    if (item.likeNum==0)
    {
        [cell.button setBackgroundImage:[UIImage imageNamed:@"concern.png"] forState:UIControlStateNormal];
    }else
    {
        [cell.button setBackgroundImage:[UIImage imageNamed:@"not_concern.png"] forState:UIControlStateNormal];
    }
    
    [cell.button addTarget:self action:@selector(concernButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *concernImage=[UIImage imageNamed:@"concern.png"];
    CGFloat rate=Homepage_Cell_Image_Width/212.0;
    CGFloat height=196*rate;
    return CGSizeMake(Homepage_Cell_Image_Width, height+30+concernImage.size.height+10);
    
    
}
#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.specialDelegate respondsToSelector:@selector(concernSpecialViewController:didSelectItemAtIndexPath:)])
    {
        [self.specialDelegate concernSpecialViewController:self didSelectItemAtIndexPath:indexPath];
    }
    
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

    if ([self.specialDelegate respondsToSelector:@selector(concernScrollViewDidScrollViewController:ContentoffsetY:contentInset:)])
    {
        [self.specialDelegate concernScrollViewDidScrollViewController:self ContentoffsetY:scrollView.contentOffset.y contentInset:self.collectionInset];
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
