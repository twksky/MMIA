//
//  MMiaConcernMagezineViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-18.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaConcernMagezineViewController.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MMiaCommonUtil.h"
#import "MMiaErrorTipView.h"
#import "MMIToast.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MMiaNoDataView.h"

#define CELL_IDENTIFIER @"ConcernMagezineWaterfallCell"
@interface MMiaConcernMagezineViewController (){
    NSInteger _downNum;
    BOOL      _isLoadding;
    BOOL      _isRefresh;
    BOOL      _showErrTipView;
     MMiaNoDataView *_nodataView;
}
@property(nonatomic,retain)UICollectionView *collectionView;


@end

@implementation MMiaConcernMagezineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(0, 9, 9, 9);
        layout.minimumColumnSpacing = 7;
        layout.minimumInteritemSpacing = 7;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
       _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[MMiaMainViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
       
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.collectionView.frame=self.view.bounds;
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xE1E1E1);
;
    [self.view addSubview:self.collectionView];
    self.dataArray=[[NSMutableArray alloc]init];
    _nodataView=[[MMiaNoDataView alloc]initWithImageName:@"no_share.png" TitleLabel:@"你还没有关注的专题，去别人的专题或许更精彩!" height:40];
    
  _nodataView.hidden=YES;
    [self.collectionView addSubview:_nodataView];
    _isLoadding = YES;
    [self addRefreshHeader];
    [MMiaLoadingView showLoadingForView:self.view center:CGPointMake(0, 40 + VIEW_OFFSET + kNavigationBarHeight)];
    [self getConcernMagezineDataByRequest:0];
}
-(void)doReturnConcernMagezineBlock:(int)concern indexPath:(NSIndexPath *)indexPath
{
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];
    if (concern==1) {
        MagezineItem *newItem=item;
        newItem.type=1;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newItem];
    }else if (concern==-1)
    {
        MagezineItem *newItem=item;
        newItem.type=0;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newItem];
    }
    [self.collectionView reloadData];
//    _isLoadding=YES;
//    _isRefresh=YES;
//    [MMiaLoadingView showLoadingForView:self.view];
//    [self getConcernMagezineDataByRequest:0];

}

#pragma mark-request
/*取消关注*/
-(void)cancelFollowmagazineRequestMagazineid:(UIButton *)button
{
    NSIndexPath *indexPath=[_collectionView indexPathForCell:(UICollectionViewCell *)[[button superview]superview]];
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.item];
    NSInteger magezineId=item.aId;
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
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:userTicket,@"ticket",[NSNumber numberWithInt:userId],@"myUserid",[NSNumber numberWithLong:magezineId],@"magazineid", nil];
    
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_CANCEL_FOLLOWMAGZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         
         if ([jsonDict[@"result"]intValue]==0)
         {
             MagezineItem *newItem=item;
             item.type=0;
             [self.dataArray replaceObjectAtIndex:indexPath.item withObject:newItem];
             [button setBackgroundImage:[UIImage imageNamed:@"concern.png"] forState:UIControlStateNormal];
             [MMIToast showWithText:@"取消关注成功" topOffset:Main_Screen_Height-20 image:nil];
//             NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
//             [nc postNotificationName:Change_PersonData object:nil];
             
         }else
         {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
         }
     }errorHandler:^(NSError *error){
         [MMIToast showWithText:@"取消关注失败" topOffset:Main_Screen_Height-20 image:nil];
     }];
}

//关注专题

-(void)FollowmagazineRequestMagazineid:(UIButton *)button
{
    NSIndexPath *indexPath=[_collectionView indexPathForCell:(UICollectionViewCell *)[[button superview]superview]];
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.item];
    NSInteger magezineId=item.aId;
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
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:userTicket,@"ticket",[NSNumber numberWithInt:userId],@"myUserid",[NSNumber numberWithLong:magezineId],@"magazineid", nil];
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_FOLLOWMAGZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         if ([jsonDict[@"result"]intValue]==0)
         {
             MagezineItem *newItem=item;
             item.type=1;
             [self.dataArray replaceObjectAtIndex:indexPath.item withObject:newItem];
             [button setBackgroundImage:[UIImage imageNamed:@"not_concern.png"] forState:UIControlStateNormal];
             [MMIToast showWithText:@"关注成功" topOffset:Main_Screen_Height-20 image:nil];
//             NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
//             [nc postNotificationName:Change_PersonData object:nil];
             
         }else
         {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
         }
     }errorHandler:^(NSError *error){
         [MMIToast showWithText:@"取消关注失败" topOffset:Main_Screen_Height-20 image:nil];
     }];
}



-(void) getConcernMagezineDataByRequest:(NSInteger)start
{
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ticket=[defaults objectForKey:USER_TICKET];
    if (!ticket)
    {
        ticket=@"";
    }
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:self.userId],@"userid", [NSNumber numberWithLong:start],@"start", [NSNumber numberWithInt:Request_Data_Count],@"size",ticket,@"ticket", nil];
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_GET_ATTENMAG_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
      
        if ([jsonObject[@"result"] intValue]==0)
        {
            NSArray* likeArray = jsonObject[@"data"];
            
            
            _downNum = [jsonObject[@"num"] intValue];
            
            if( _isRefresh )
            {
                [self.dataArray removeAllObjects];
            }
            
            for( NSDictionary *dict in likeArray)
            {
                MagezineItem* item =[[MagezineItem alloc] init];
                
                item.aId = [[dict objectForKey:@"id"] intValue];
                item.pictureImageUrl = [dict objectForKey:@"imgUrl"];
                item.likeNum=[[dict objectForKey:@"supportNum"]intValue];
                
                item.title=[dict objectForKey:@"title"];
                item.userId=[[dict objectForKey:@"userid"]intValue];
                item.type=[[dict objectForKey:@"isAttention"]intValue];
                if( item.pictureImageUrl.length > 0 )
                {
                    [self.dataArray addObject:item];
                }
            }
            if (self.dataArray.count==0)
            {
                _nodataView.hidden=NO;
            }else
            {
                _nodataView.hidden=YES;
            }
            [self refreshConcernMagezinePage];
        }else
        {
             _nodataView.hidden=YES;
            [self netWorkError:nil];
        }

    }errorHandler:^(NSError *error){
        [self netWorkError:error];

    }];
}

- (void)refreshConcernMagezinePage
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
    if( self.dataArray.count == 0 )
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




#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaConcernMagezineViewController* concernMagezineVC = self;
    [self.collectionView addHeaderWithCallback:^{
        if( concernMagezineVC->_isLoadding )
            return;
        
        if( concernMagezineVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:concernMagezineVC.view];
        }
        concernMagezineVC->_isRefresh = YES;
        concernMagezineVC->_isLoadding = YES;
        [concernMagezineVC getConcernMagezineDataByRequest:0];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaConcernMagezineViewController* concernMagezineVC = self;
    [self.collectionView addFooterWithCallback:^{
        if( concernMagezineVC->_isLoadding )
            return;
        concernMagezineVC->_isRefresh = NO;
        concernMagezineVC->_isLoadding = YES;
        [concernMagezineVC getConcernMagezineDataByRequest:concernMagezineVC.dataArray.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_collectionView isFooterHidden])
    {
        [_collectionView removeFooter];
    }
}
//#pragma mark -notification
//-(void)doConcernPersonMagezineRequest
//{
//    _isLoadding = YES;
//    [self.dataArray removeAllObjects];
//    [self.collectionView reloadData];
//    [self addRefreshHeader];
//    [MMiaLoadingView showLoadingForView:self.view];
//    [self getConcernMagezineDataByRequest:0];
// 
//}

#pragma-mark tapClick
-(void)concernButtonClick:(UIButton *)button
{
    NSIndexPath *indexPath=[_collectionView indexPathForCell:(UICollectionViewCell *)[[button superview]superview]];
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.item];
    if (item.type==0)
    {
        [self FollowmagazineRequestMagazineid:button];
    }else
    {
        [self cancelFollowmagazineRequestMagazineid:button];
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
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl] placeholderImage:nil];
    
    cell.imageView.clipsToBounds=YES;
    cell.imageView.layer.cornerRadius=2.0;
   // cell.imageView.layer.borderWidth=2.0;
   // cell.imageView.layer.borderColor=[[UIColor whiteColor]CGColor];
    CGFloat rate,height;
        rate=(Homepage_Cell_Image_Width-4)/212.0;
    if (rate!=0) {
        height=196*rate;
    }
    cell.imageView.frame=CGRectMake(2, 30, Homepage_Cell_Image_Width-4, height);
   
    cell.supportNumLabel.text=[NSString stringWithFormat:@"%ld",(long)item.likeNum];
    CGFloat supportLabelWidth= [cell.supportNumLabel.text sizeWithFont:cell.supportNumLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width;
    cell.supportNumLabel.frame=CGRectMake(10, 100,supportLabelWidth+20, 20);
    cell.supportNumLabel.clipsToBounds=YES;
  cell.supportNumLabel.layer.cornerRadius=3.0;
    cell.supportNumLabel.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.4];
    cell.supportNumLabel.textColor=[UIColor whiteColor];
    UIImage *cancelImage=[UIImage imageNamed:@"not_concern.png"];
    cell.button.enabled=YES;
    if (item.type==1) {
        [cell.button setBackgroundImage:[UIImage imageNamed:@"not_concern.png"] forState:UIControlStateNormal];
    }else if (item.type==0)
    {
         [cell.button setBackgroundImage:[UIImage imageNamed:@"concern.png"] forState:UIControlStateNormal];
    }else
    {
        [cell.button setBackgroundImage:[UIImage imageNamed:@"concern_mage_own.png"] forState:UIControlStateNormal];
        cell.button.enabled=NO;
    }
    
   
    cell.button.frame=CGRectMake(5, CGRectGetMaxY(cell.imageView.frame)+5, cancelImage.size.width, cancelImage.size.height);
   
     [cell.button addTarget:self action:@selector(concernButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     UIImage *cancelImage=[UIImage imageNamed:@"not_concern.png.png"];
    CGFloat rate=Homepage_Cell_Image_Width/212.0;
    CGFloat height=196*rate;
    return CGSizeMake(Homepage_Cell_Image_Width, height+35+cancelImage.size.height);
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];
    if (item.type==2)
    {
        return;
    }

    if( [self.delegate respondsToSelector:@selector(didSelectItemAtConcernMagezine:indexPath:)] )
    {
        [self.delegate didSelectItemAtConcernMagezine:self indexPath:indexPath];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0)
    {
        scrollView.contentOffset=CGPointZero;
    }
}


#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.view];
    [MMiaLoadingView showLoadingForView:self.view center:CGPointMake(0, 40 + VIEW_OFFSET + kNavigationBarHeight)];
    _isLoadding = YES;
    [self getConcernMagezineDataByRequest:0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
