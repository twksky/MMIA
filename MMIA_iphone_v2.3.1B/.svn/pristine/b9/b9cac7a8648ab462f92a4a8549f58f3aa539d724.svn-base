//
//  MMiaSpecialViewController.m
//  MMIA
//
//  Created by lixiao on 15/1/29.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMiaSpecialViewController.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MMiaErrorTipView.h"
#import "MMiaCommonUtil.h"
#import "MMIToast.h"
#import "AppDelegate.h"
#import "MJRefresh.h"

#define CELL_IDENTIFIER @"SpecialWaterfallCell"

@interface MMiaSpecialViewController (){
    BOOL         _showErrTipView;
    NSInteger    _downNum;
}


@end

@implementation MMiaSpecialViewController

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


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    self.nodataView = [[MMiaNoDataView alloc]initWithImageName:@"no_share.png" TitleLabel:@"还没有专题，去其他地方看看吧!" height:40];
     self.nodataView.hidden = YES;
     [self.collectionView addSubview:self.nodataView];
     [self.view addSubview:self.collectionView];
    _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getUserMagazineRequestStart:0 Size:Request_Data_Count];

}

#pragma mark - Public

-(void)getUserMagazineRequestStart:(NSInteger)start Size:(int)size
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket=@"";
    }
    if (!self.userId)
    {
        self.userId=0;
    }
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:self.userId],@"userid",[NSNumber numberWithLong:start],@"start",[NSNumber numberWithInt:size],@"size",userTicket,@"ticket", nil];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_GET_USER_MAGEZINE_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        if ([jsonDict[@"result"]intValue]==0) {
            _downNum = [jsonDict[@"num"] intValue];
            if( _isRefresh )
            {
                [self.dataArray removeAllObjects];
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
                [self.dataArray addObject:item];
                _nodataView.hidden=YES;
            }
           [self refreshConcernMagezinePage];
            if (self.dataArray.count==0)
            {
                self.nodataView.hidden=NO;
            }
            
        }else{
            self.nodataView.hidden=YES;
            if (self.showError)
            {
               [MMIToast showWithText:jsonDict[@"msg"] topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-50 image:nil];
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
                
            }else
            {
                _isLoadding=NO;
                self.showError=YES;
                [MMiaLoadingView hideLoadingForView:self.view];
                
            }

        }
        
    }errorHandler:^(NSError *error){
        if (self.showError)
        {
            [self netWorkError:error];
            
        }else
        {
            _isLoadding=NO;
            self.showError=YES;
            [MMiaLoadingView hideLoadingForView:self.view];
        }

    }];
    
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
    if( self.dataArray.count==0 )
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
    __block MMiaSpecialViewController *specialVC = self;
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
     __block MMiaSpecialViewController *specialVC = self;
    [_collectionView addFooterWithCallback:^{
        if(specialVC->_isLoadding )
            return;
        specialVC->_isRefresh = NO;
        specialVC->_isLoadding = YES;
        [specialVC getUserMagazineRequestStart:specialVC.dataArray.count Size:Request_Data_Count];
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMainViewWaterfallCell *cell =
    (MMiaMainViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                           forIndexPath:indexPath];
    
    cell.layer.cornerRadius=4.0;
    if (self.dataArray.count==0) {
        return cell;
    }
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.item];
    
    cell.displayLabel.frame=CGRectMake(5, cell.bounds.origin.y, Homepage_Cell_Image_Width-36, 30);
    cell.displayLabel.textAlignment=MMIATextAlignmentLeft;
    NSString *titleStr=item.title;
    cell.displayLabel.text=titleStr;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
    
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
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rate=Homepage_Cell_Image_Width/212.0;
    CGFloat height=196*rate;
    return CGSizeMake(Homepage_Cell_Image_Width, height+30);
}

#pragma mark -UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.specialDelegate respondsToSelector:@selector(viewController:didSelectItemAtIndexPath:)])
    {
        [self.specialDelegate viewController:self didSelectItemAtIndexPath:indexPath];
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
    
    if ([self.specialDelegate respondsToSelector:@selector(scrollViewDidScrollViewController:ContentoffsetY:contentInset:)])
    {
        [self.specialDelegate scrollViewDidScrollViewController:self ContentoffsetY:scrollView.contentOffset.y contentInset:self.collectionInset];
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
