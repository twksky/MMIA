//
//  MMiaSearchShopViewController.m
//  MMIA
//
//  Created by lixiao on 14-10-30.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaSearchShopViewController.h"
#import "MagezineItem.h"
#import "MMIToast.h"
#import "MMiaFunsTableViewCell.h"
#import "MMiaCommonUtil.h"
#import "MMiaErrorTipView.h"
#import "MJRefresh.h"


#define Search_View_Tag        100
#define Delete_ImageView_Tag   101

@interface MMiaSearchShopViewController (){
    UITextField  *_searchTextFiled;
    NSInteger _downNum;
    BOOL      _showErrTipView;
}
@property(nonatomic,assign)CGFloat scrollHeight;
@end

@implementation MMiaSearchShopViewController

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
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
   self.tableView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.scrollHeight=CGRectGetHeight(self.view.bounds);
    self.shopArray=[[NSMutableArray alloc]init];
    [self addRefreshHeader];
    _isLoadding = YES;
    self.tableView.scrollEnabled=NO;
    [MMiaLoadingView showLoadingForView:self.view center:CGPointMake(0, 29 + VIEW_OFFSET + 44)];
    [self getShopDataByRequest:0];
    self.nodataView=[[MMiaNoDataView alloc]initWithImageName:@"no_shop.png" TitleLabel:@"抱歉！暂时没有找到相关商家" height:40];
    [self.tableView addSubview:self.nodataView];
    self.nodataView.hidden=YES;
}
#pragma mark -ButtonClick
-(void)bttonClick:(UIButton *)button
{
    if (button.tag==1001)
    {
        [self.navigationController popViewControllerAnimated:YES];;
    }
}

- (void)topBtnClicked:(UIButton *)button
{
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}

/*关注取消按钮*/
-(void)cellButtonClick:(UIButton *)button
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL islogin=[defaults boolForKey:USER_IS_LOGIN];
    if (!islogin)
    {
        if ([self.delegate respondsToSelector:@selector(doLogin)])
        {
            [self.delegate doLogin];
        }

    }else{
       
        NSIndexPath* indexPath;
        
        indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[button superview]superview]];
        if ([[[UIDevice currentDevice] systemVersion] intValue] == 7)
        {
            indexPath=[self.tableView indexPathForCell:(UITableViewCell *)[[[button superview]superview]superview]];
        }
        MagezineItem *item=[self.shopArray objectAtIndex:indexPath.row];
        if (item.likeNum==1)
        {
            [self getCancelFollowSomeOneDataWithTargetUser:button MagezineItem:item];
        }else
        {
            [self getFocusFollowSomeOneDataWithTargetUser:button MagezineItem:item];
        }

        
    }
    
}

#pragma mark -sendRequest
- (void)getShopDataByRequest:(NSInteger)start
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.userid],@"userid",[NSNumber numberWithLong:start],@"start",[NSNumber numberWithInt:Request_Data_Count],@"size",[NSNumber numberWithInt:1],@"type",self.shopKeyWord,@"keyword",nil];
    NSString *searchUrl=@"ados/search/searchWord";
    [app.mmiaDataEngine startAsyncRequestWithUrl:searchUrl param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         if ([jsonDict[@"result"] intValue]==0)
         {
             NSArray* goodsArray = jsonDict[@"data"];
             _downNum = [jsonDict[@"num"] intValue];
             if( self.isRefresh )
             {
                 [self.shopArray removeAllObjects];
             }
             
             for( NSDictionary *dict in goodsArray)
             {
                 MagezineItem* item =[[MagezineItem alloc] init];
                 
                 item.userId = [[dict objectForKey:@"companyId"] intValue];
                 item.pictureImageUrl = [dict objectForKey:@"logo"];
                 item.likeNum = [[dict objectForKey:@"isAttention"] intValue];
                 item.title=[dict objectForKey:@"companyName"];
                 item.subTitle=[dict objectForKey:@"companyDesc"];
                 if( item.pictureImageUrl.length > 0 )
                 {
                     [self.shopArray addObject:item];
                 }
             }
             if (self.shopArray.count==0)
             {
                 self.nodataView.hidden=NO;
             }else
             {
                 self.nodataView.hidden=YES;
             }
             [self refreshShopPage];
             
         }else
         {
             [self netWorkError:nil];
        
         }
         
     }errorHandler:^(NSError *error)
     {
         
             [self netWorkError:error];
         
     }];
    
}
//取消关注
-(void)getCancelFollowSomeOneDataWithTargetUser:(UIButton *)button MagezineItem:(MagezineItem *)item
{
    NSIndexPath* indexPath;
    if ([[[UIDevice currentDevice] systemVersion] intValue] == 7)
    {
        indexPath=[self.tableView indexPathForCell:(UITableViewCell *)[[[button superview]superview]superview]];
    }else
    {
        indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[button superview]superview]];
    }
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
      int userId=[[defaults objectForKey:USER_ID]intValue];
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
            [self.shopArray replaceObjectAtIndex:indexPath.row withObject:newItem];

            
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
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] == 7)
    {
        indexPath=[self.tableView indexPathForCell:(UITableViewCell *)[[[button superview]superview]superview]];
    }else
    {
        indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[button superview]superview]];
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
            [self.shopArray replaceObjectAtIndex:indexPath.row withObject:newItem];
            
        }else
        {
            [MMIToast showWithText:@"关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
            
        }
        
    }errorHandler:^(NSError *error){
        [MMIToast showWithText:@"关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
        
    }];
    
}

- (void)netWorkError:(NSError *)error
{
    self.tableView.scrollEnabled=YES;
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
    if( self.shopArray.count == 0 )
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

- (void)refreshShopPage
{
    self.tableView.scrollEnabled=YES;
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

#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaSearchShopViewController* shopVC = self;
    [self.tableView addHeaderWithCallback:^{
        if( shopVC->_isLoadding )
            return;
        
        if( shopVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:shopVC.tableView];
        }
        shopVC->_isRefresh = YES;
        shopVC->_isLoadding = YES;
        [shopVC getShopDataByRequest:0];
    }];
}

- (void)addRefreshFooter
{
    __block MMiaSearchShopViewController* ShopVC = self;
    [self.tableView addFooterWithCallback:^{
        if( ShopVC->_isLoadding )
            return;
        ShopVC->_isRefresh = NO;
        ShopVC->_isLoadding = YES;
       [ShopVC getShopDataByRequest:ShopVC.shopArray.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_tableView isFooterHidden])
    {
        [_tableView removeFooter];
    }
}
#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.shopArray.count;
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
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.concernButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor=[UIColor clearColor];
    }
    MagezineItem *item=[self.shopArray objectAtIndex:indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl] placeholderImage:[UIImage imageNamed:@"default_company.png"]];
    
    cell.headImageView.clipsToBounds=YES;
    cell.headImageView.layer.cornerRadius=CGRectGetHeight(cell.headImageView.frame)/2;
    
    cell.titleLable.text=item.title;
    cell.subTitleLabel.text=item.subTitle;
    cell.concernButton.enabled=YES;
    if (item.likeNum==1)
    {
        [cell.concernButton setBackgroundImage:[UIImage imageNamed:@"attentionsmall_quxiao.png"] forState:UIControlStateNormal];
    }else if(item.likeNum==0)
    {
        
        [cell.concernButton setBackgroundImage:[UIImage imageNamed:@"attentionsmall.png"] forState:UIControlStateNormal];
    }else
    {
        [cell.concernButton setBackgroundImage:[UIImage imageNamed:@"concern_funs_own.png"] forState:UIControlStateNormal];
        cell.concernButton.enabled=NO;
    }
    cell.lineView.frame=CGRectMake(0, 59, App_Frame_Width, 1);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem *item=[self.shopArray objectAtIndex:indexPath.row];
    if (item.likeNum==2)
    {
        [MMIToast showWithText:@"自己的主页请进入个人中心查看" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(viewController:didSelectRowAtIndexPath:)])
    {
        [self.delegate viewController:self didSelectRowAtIndexPath:indexPath];
    }

   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(searchShopScrollViewDidScroll)])
    {
        [self.delegate searchShopScrollViewDidScroll];
    }
}
#pragma mark -errorTipClick
- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.tableView];
    _isLoadding = YES;
    self.tableView.scrollEnabled=NO;
    [MMiaLoadingView showLoadingForView:self.view center:CGPointMake(0, 29 + VIEW_OFFSET + 44)];
    [self getShopDataByRequest:0];
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
