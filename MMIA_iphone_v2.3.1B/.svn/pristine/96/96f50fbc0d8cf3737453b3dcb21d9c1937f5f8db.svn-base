//
//  MMiaFunsViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-17.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaFunsViewController.h"
#import "MagezineItem.h"
#import "MMIToast.h"
#import "MMiaFunsTableViewCell.h"
#import "MMiaCommonUtil.h"
#import "MMiaErrorTipView.h"
#import "MJRefresh.h"
#import "MMiaConcernPersonHomeViewController.h"
#import "MMiaNoDataView.h"

#define BUTTON_BASE_TAG  2000
@interface MMiaFunsViewController (){
    UIView *_bgView;
    BOOL      _isLoadding;
    BOOL      _isRefresh;
    BOOL      _showErrTipView;
    NSInteger _downNum;
    BOOL      _isAttention;
    MMiaNoDataView *_nodataView;
    NSInteger _userId;

}
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *dataArray;

@end

@implementation MMiaFunsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUserId:(NSInteger)userId
{
    self = [super init];
    if (self)
    {
        _userId = userId;
    }
    return self;
}

-(UITableView *)tableView
{
    if( !_tableView)
    {
          _tableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 10, App_Frame_Width-20, CGRectGetHeight(_bgView.frame)-10)];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_bgView addSubview:_tableView];
        
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self loadNavView];
    [self loadBgView];
    _nodataView=[[MMiaNoDataView alloc]initWithImageName:@"no_funs.png" TitleLabel:@"暂时还没有人关注你" height:40];
    [self.tableView addSubview:_nodataView];
    _nodataView.hidden=YES;
    _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    [self addRefreshHeader];
    [self getUserFansByRequest:0];
}
- (void)loadNavView
{
    [self setTitleString:@"粉丝"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
}
-(void)loadBgView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, Main_Screen_Height-20-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    
}
#pragma mark -sendRequest
- (void)getUserFansByRequest:(NSInteger)start
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ticket=[defaults objectForKey:USER_TICKET];
    if (!ticket)
    {
        ticket=@"";
    }
   
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_userId],@"userid", [NSNumber numberWithLong:start],@"start", [NSNumber numberWithInt:Request_Data_Count],@"size",ticket,@"ticket", nil];
   
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_GET_USERFUNS_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         if ([jsonDict[@"result"]intValue]==0)
         {
              _downNum = [jsonDict[@"num"] intValue];
             if( _isRefresh )
             {
                 [self.dataArray removeAllObjects];
             }
             NSArray *dataArray1=jsonDict[@"data"];
             for (NSDictionary *dataDict in dataArray1)
             {
                 MagezineItem *item=[[MagezineItem alloc]init];
                 item.title=[dataDict objectForKey:@"nickname"];
                 item.subTitle=[dataDict objectForKey:@"signature"];
                 item.userId=[[dataDict objectForKey:@"userid"]intValue];
                 item.pictureImageUrl=[dataDict objectForKey:@"headImgUrl"];
                 item.likeNum=[[dataDict objectForKey:@"isAttention"]intValue];
                 [self.dataArray addObject:item];
                 
             }
             if (self.dataArray.count==0)
             {
                 _nodataView.hidden=NO;
             }else
             {
                  _nodataView.hidden=YES;
             }
             
            
             [self refreshFunsPage];
 
         }else
         {
             _nodataView.hidden=YES;
             [self netWorkError:nil];
         }
         
     }errorHandler:^(NSError *error){
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
        [_tableView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_tableView footerEndRefreshing];
    }
    if( self.dataArray.count == 0 )
    {
        CGFloat errTipY = (CGRectGetHeight(self.tableView.bounds) - 125)/2;
        CGFloat errTipX = CGRectGetWidth(self.tableView.bounds) / 2;
        [MMiaErrorTipView showErrorTipForView:self.tableView center:CGPointMake(errTipX, errTipY) error:error delegate:self];
        _showErrTipView = YES;
    }
    else
    {
        [MMiaErrorTipView showErrorTipForErroe:error];
        [MMiaErrorTipView hideErrorTipForView:self.tableView];
        _showErrTipView = NO;
    }
}

- (void)refreshFunsPage
{
    if( _showErrTipView )
    {
        [MMiaErrorTipView hideErrorTipForView:self.tableView];
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
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:userId],@"myUserid", userTicket,@"ticket", [NSNumber numberWithLong:item.userId],@"targetUserid", nil];
    
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
            // [self.tableView reloadData];
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



#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaFunsViewController* funsVC = self;
    [self.tableView addHeaderWithCallback:^{
        if( funsVC->_isLoadding )
            return;
        
        if( funsVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:funsVC.tableView];
        }
        funsVC->_isRefresh = YES;
        funsVC->_isLoadding = YES;
        [MMiaLoadingView showLoadingForView:funsVC.view];
        [funsVC getUserFansByRequest:0];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaFunsViewController* funsVC = self;
    [self.tableView addFooterWithCallback:^{
        if( funsVC->_isLoadding )
            return;
        funsVC->_isRefresh = NO;
        funsVC->_isLoadding = YES;
        [funsVC getUserFansByRequest:funsVC.dataArray.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_tableView isFooterHidden])
    {
        [_tableView removeFooter];
    }
}


#pragma mark-btnClick
-(void)btnClick:(UIButton *)button
{
    if (button.tag==1001)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*关注取消按钮*/
-(void)cellButtonClick:(UIButton *)button
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

#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.tableView];
    _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    
    [self getUserFansByRequest:0];
}


#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
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
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.concernButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor=[UIColor clearColor];
    }
      MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl] placeholderImage:[UIImage imageNamed:@"personal_03.png"]];
    
    cell.headImageView.clipsToBounds=YES;
    cell.headImageView.layer.cornerRadius=CGRectGetHeight(cell.headImageView.frame)/2;
    
 cell.titleLable.text=item.title;
 cell.subTitleLabel.text=item.subTitle;
    cell.concernButton.enabled=YES;
    if (item.likeNum==1)
    {
       // [cell.concernButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [cell.concernButton setBackgroundImage:[UIImage imageNamed:@"attentionsmall_quxiao.png"] forState:UIControlStateNormal];
    }else if(item.likeNum==0)
    {
       
     [cell.concernButton setBackgroundImage:[UIImage imageNamed:@"attentionsmall.png"] forState:UIControlStateNormal];
        
    }else
    {
        [cell.concernButton setBackgroundImage:[UIImage imageNamed:@"concern_funs_own.png"] forState:UIControlStateNormal];
        cell.concernButton.enabled=NO;
    }
    cell.lineView.hidden=YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];

    if (item.likeNum==1) {
    }else if (item.likeNum==0)
    {
    }else
    {
        return;
    }
  
    MMiaConcernPersonHomeViewController *concernVC=[[MMiaConcernPersonHomeViewController alloc]initWithUserid:item.userId];
       concernVC.funsBlock=^(int follow){
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
//           if (_isLoadding)
//           {
//               return ;
//           }
//           _isLoadding=YES;
//           _isRefresh=YES;
//           [self getUserFansByRequest:0];

    };
    
   // concernVC.isConcern=isConcern;
    [self.navigationController pushViewController:concernVC animated:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0)
    {
        scrollView.contentOffset=CGPointZero;
    }
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
