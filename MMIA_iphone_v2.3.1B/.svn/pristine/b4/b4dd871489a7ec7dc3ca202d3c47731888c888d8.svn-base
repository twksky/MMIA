//
//  MMiaConcernPersonViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-18.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaConcernPersonViewController.h"
#import "MJRefresh.h"
#import "MMiaErrorTipView.h"
#import "MMIToast.h"
#import "MagezineItem.h"
#import "MMiaCommonUtil.h"
#import "MMiaFunsTableViewCell.h"
#import "AppDelegate.h"
#import "MMiaNoDataView.h"

#define CANCEL_BUTTONBASE_TAG  2000


@interface MMiaConcernPersonViewController ()
{
    BOOL      _isLoadding;
    BOOL      _isRefresh;
    BOOL      _showErrTipView;
     NSInteger _downNum;
    int        _deleteCount;
     MMiaNoDataView *_nodataView;
    
}
@property(nonatomic,retain)UITableView *tableView;
@end


@implementation MMiaConcernPersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UITableView *)tableView
{
   if( !_tableView)
   {
       _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
       _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
       _tableView.delegate=self;
       _tableView.dataSource=self;
    [self.view addSubview:_tableView];

   }
    return _tableView;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tableView.frame=self.view.bounds;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=UIColorFromRGB(0xE1E1E1);
    self.dataArray=[[NSMutableArray alloc]init];
    _nodataView=[[MMiaNoDataView alloc]initWithImageName:@"no_funs.png" TitleLabel:@"暂时没有关注的人！" height:40];
    _nodataView.hidden=YES;
    [self.tableView addSubview:_nodataView];

   _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view center:CGPointMake(0, 40 + VIEW_OFFSET + kNavigationBarHeight)];
   [self addRefreshHeader];
   [self getMyFavourPersonDataByRequest:0];


}
-(void)doReturnBlock:(int)follow indexPath:(NSIndexPath *)indexPath
{
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];
    if (follow==1) {
        MagezineItem *newItem=item;
        newItem.likeNum=1;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newItem];
    }else if (follow==-1)
    {
        MagezineItem *newItem=item;
        newItem.likeNum=0;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newItem];
    }
    [self.tableView reloadData];
//    if (_isLoadding)
//    {
//        return;
//    }
//    _isLoadding=YES;
//    _isRefresh=YES;
//    [MMiaLoadingView showLoadingForView:self.view];
//    [self getMyFavourPersonDataByRequest:0];
    

}
#pragma mark-request
- (void)getMyFavourPersonDataByRequest:(NSInteger)start
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ticket=[defaults objectForKey:USER_TICKET];
    if (!ticket)
    {
        ticket=@"";
    }
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:self.userId],@"userid", [NSNumber numberWithLong:start],@"start", [NSNumber numberWithInt:Request_Data_Count],@"size",ticket,@"ticket", nil];
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_GET_FAVOURPERSON_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject)
     {
         
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
                 
                 item.userId = [[dict objectForKey:@"userid"] intValue];
                 item.title=[dict objectForKey:@"nickname"];
                 item.subTitle=[dict objectForKey:@"signature"];
                 item.pictureImageUrl = [dict objectForKey:@"headImgUrl"];
                 item.likeNum=[[dict objectForKey:@"isAttention"]intValue];
                
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
             
             [self refreshConcernPersonPage];
         }else
         {
             _nodataView.hidden=YES;
          [self netWorkError:nil];
         }
         
     }errorHandler:^(NSError *error){
        [self netWorkError:error];
     }];
}
//取消关注
-(void)getCancelFollowSomeOneDataWithTargetUser:(UIButton *)button MagezineItem:(MagezineItem *)item
{
    NSIndexPath* indexPath;
    indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[button superview]superview]];
    if ([[[UIDevice currentDevice] systemVersion] intValue] == 7)
    {
        indexPath=[self.tableView indexPathForCell:(UITableViewCell *)[[[button superview]superview]superview]];
    }
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
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"myUserid", userTicket,@"ticket", [NSNumber numberWithLong:item.userId],@"targetUserid", nil];
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_CANCEL_FOLLOWONE_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
        
        if ([jsonObject[@"result"] intValue]==0)
        {
            
            [button setBackgroundImage:[UIImage imageNamed:@"attentionsmall.png"] forState:UIControlStateNormal];
            [MMIToast showWithText:@"取消关注成功" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
            MagezineItem *newItem=item;
            newItem.likeNum=0;
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newItem];
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:Change_PersonData object:nil];
            
        }else
        {
            [MMIToast showWithText:@"取消关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
        }
        
    }errorHandler:^(NSError *error){
        [MMIToast showWithText:@"取消关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
    }];
    
}

//关注
-(void)getFocusFollowSomeOneDataWithTargetUser:(UIButton *)button MagezineItem:(MagezineItem *)item
{
    NSIndexPath* indexPath;
    indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[button superview]superview]];
    if ([[[UIDevice currentDevice] systemVersion] intValue] == 7)
    {
        indexPath=[self.tableView indexPathForCell:(UITableViewCell *)[[[button superview]superview]superview]];
    }

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
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"myUserid", userTicket,@"ticket", [NSNumber numberWithLong:item.userId],@"targetUserid", nil];
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_FOCUS_FOLLOWONE_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
        
        if ([jsonObject[@"result"] intValue]==0)
        {
            
            [button setBackgroundImage:[UIImage imageNamed:@"attentionsmall_quxiao.png"] forState:UIControlStateNormal];
            [MMIToast showWithText:@"关注成功" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
            MagezineItem *newItem=item;
            newItem.likeNum=1;
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newItem];
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:Change_PersonData object:nil];
            
        }else
        {
            [MMIToast showWithText:@"关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
            
        }
        
    }errorHandler:^(NSError *error){
        [MMIToast showWithText:@"关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
        
    }];
    
}



- (void)refreshConcernPersonPage
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
        [_tableView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_tableView footerEndRefreshing];
    }
    [self.tableView reloadData];
    
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
        [_tableView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_tableView footerEndRefreshing];
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
    __block MMiaConcernPersonViewController* concernPersonVC = self;
    [self.tableView addHeaderWithCallback:^{
        if( concernPersonVC->_isLoadding )
            return;
        
        if( concernPersonVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:concernPersonVC.view];
        }
        concernPersonVC->_isRefresh = YES;
        concernPersonVC->_isLoadding = YES;
        [concernPersonVC getMyFavourPersonDataByRequest:0];
    }];
}
- (void)addRefreshFooter
{
    __block MMiaConcernPersonViewController* concernPersonVC = self;
    [self.tableView addFooterWithCallback:^{
        if( concernPersonVC->_isLoadding )
            return;
        concernPersonVC->_isRefresh = NO;
        concernPersonVC->_isLoadding = YES;
        [concernPersonVC getMyFavourPersonDataByRequest:concernPersonVC.dataArray.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_tableView isFooterHidden])
    {
        [_tableView removeFooter];
    }
}

#pragma mark-buttonClick:
-(void)buttonClick:(UIButton *)button
{

    NSIndexPath* indexPath;
    indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[button superview]superview]];
    if ([[[UIDevice currentDevice] systemVersion] intValue] == 7)
    {
        indexPath=[self.tableView indexPathForCell:(UITableViewCell *)[[[button superview]superview]superview]];
    }
   
    
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];
    
    if (item.likeNum==1)
    {
        [self getCancelFollowSomeOneDataWithTargetUser:button MagezineItem:item];
    }else
    {
        [self getFocusFollowSomeOneDataWithTargetUser:button MagezineItem:item];
    }

    
}


#pragma mark-UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaFunsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil)
    {
        cell=[[MMiaFunsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.contentView.backgroundColor=[UIColor whiteColor];
        cell.contentView.layer.cornerRadius=5.0;
        cell.contentView.layer.borderColor=[UIColorFromRGB(0xE1E1E1)CGColor];
        cell.contentView.layer.borderWidth=1.0;
        [cell.concernButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    cell.concernButton.enabled=YES;
        MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];
    if (item.likeNum==1) {
         [cell.concernButton setBackgroundImage:[UIImage imageNamed:@"attentionsmall_quxiao.png"] forState:UIControlStateNormal];
    }else if (item.likeNum==0)
    {
         [cell.concernButton setBackgroundImage:[UIImage imageNamed:@"attentionsmall.png"] forState:UIControlStateNormal];
    }else
    {
        [cell.concernButton setBackgroundImage:[UIImage imageNamed:@"concern_funs_own.png"] forState:UIControlStateNormal];
        cell.concernButton.enabled=NO;
    }
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl] placeholderImage:[UIImage imageNamed:@"personal_03.png"]];
    cell.headImageView.clipsToBounds=YES;
    cell.headImageView.layer.cornerRadius=CGRectGetHeight(cell.headImageView.frame)/2;
   cell.titleLable.text=item.title;
    cell.subTitleLabel.text=item.subTitle;
    //cell.titleLable.text=item.title;
//    if (item.title.length>10) {
//         NSMutableString *titleStr=[[NSMutableString alloc]init];
//       NSString *str1=[item.title substringToIndex:10];
//        [titleStr appendString:str1];
//        [titleStr appendString:@"..."];
//         cell.titleLable.text=titleStr;
//    }else
//    {
//        cell.titleLable.text=item.title;
//    }
//    if (item.subTitle.length>15) {
//        NSMutableString *titleStr=[[NSMutableString alloc]init];
//        NSString *str1=[item.subTitle substringToIndex:15];
//        [titleStr appendString:str1];
//        [titleStr appendString:@"..."];
//        cell.subTitleLabel.text=titleStr;
//    }else
//    {
//        cell.subTitleLabel.text=item.subTitle;
//    }
  //  cell.concernButton.tag=indexPath.row+CANCEL_BUTTONBASE_TAG;
   
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];
    if (item.likeNum==2)
    {
        return;
    }
    if( [self.delegate respondsToSelector:@selector(didSelectItemAtConcernPerson:indexPath:)] )
    {
        [self.delegate didSelectItemAtConcernPerson:self indexPath:indexPath];
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
    _isLoadding = YES;
     [MMiaLoadingView showLoadingForView:self.view center:CGPointMake(0, 40 + VIEW_OFFSET + kNavigationBarHeight)];
    [self getMyFavourPersonDataByRequest:0];
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
