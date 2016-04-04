//
//  MMIASettingViewController.m
//  MMIAAdIphone
//
//  Created by Vivian's Office MAC on 14-2-12.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIASettingViewController.h"
//#import "SDImageCache.h"
//#import "MMIAHttpManager.h"
#import "MMIAGroupTableViewCell.h"
#import "MMIAFeedBackViewController.h"
#import "MMiaCommonUtil.h"
#import "MMIAEditionInforViewController.h"
#import "MMIToast.h"
#import "MobClick.h"
#import "APService.h"
#import "MMIProcessView.h"

#import "MMiaDataSetViewController.h"
#import "MMiaCompanyDataSetViewController.h"
#import "MMiaSetAccountViewController.h"
#import "MyCustomTabBarController.h"
#import "MMiaMainViewController.h"
#import "MMIAPersonalHomePageViewController.h"
#import "MMIALoginViewController.h"


#define TOP_OFF_SET 220
#define EXIT_LOGIN_TAG 22
#define PUSH_OFF_TAG  100
#define PUSH_ON_TAG   101
#define VERSION_TAG 102
#define PROCESS_HEIGHT 0
#define PRCESS_VIEW_TAG  200
#define SWITCH_BUTTON_TAG 103
#define EXIT_ALERTVIEW_TAG  104
@interface MMIASettingViewController (){
    BOOL _isPush;
    
}

@end

@implementation MMIASettingViewController
{
    UIView *_bgView;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    UISwitch *_refreshSwitch;
    NSMutableArray *_imageArray;
    NSString *_path;
    BOOL _isVersion;
    NSTimer *_timer;
    LoginInfoItem *_item;
   
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithLoginInfoItem:(LoginInfoItem *)item
{
    self=[super init];
    if (self)
    {
        _item=item;
    }
    return self;
}
/*
 @param   nil
 @descripation  初始化数据
 */
- (void)initDataArray
{
    _dataArray=[[NSMutableArray alloc]init];
    _imageArray=[[NSMutableArray alloc]init];
    
    
    NSArray *arr0=[NSArray arrayWithObjects:@"资料设置",@"账号设置", nil];
    NSArray *img0=[NSArray arrayWithObjects:@"setting_06.png",@"setting_07.png",nil];
    [_imageArray addObject:img0];
    [_dataArray addObject:arr0];
    
    NSArray *arr1=[NSArray arrayWithObjects:@"意见反馈",@"推送",@"版本更新",nil];
    NSArray *img1=[NSArray arrayWithObjects:@"setting_08.png",@"setting_09.png",@"setting_10.png", nil];
    [_imageArray addObject:img1];
    [_dataArray addObject:arr1];
    
    NSArray *arr2=[NSArray arrayWithObjects:@"版本信息",@"清除本地缓存", nil];
    NSArray *img2=[NSArray arrayWithObjects:@"setting_11.png",@"setting_12.png", nil];
    [_imageArray addObject:img2];
    [_dataArray addObject:arr2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabController hideOrNotCustomTabBar:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _isVersion=NO;
    _path=[[NSString alloc]init];
    [self initDataArray];
    [self loadNavView];
    [self loadBgView];
    
}

#pragma mark - loadUI
/*
 @param   nil
 @descripation  加载导航视图
 */
- (void)loadNavView
{
    [self setTitleString:@"设置"];
       UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
}
/*
 @param   nil
 @descripation  加载主视图
 */
- (void)loadBgView
{
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, SCREEN_WIDTH, Main_Screen_Height-20-44)];
   _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, 310)];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.scrollEnabled=YES;
    _tableView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_tableView];
    [self.view addSubview:_bgView];
    UIImage *exitImage=[UIImage imageNamed:@"btn_logoff.png"];
    UIButton *exitButton=[[UIButton alloc]initWithFrame:CGRectMake((App_Frame_Width-exitImage.size.width)/2, CGRectGetHeight(_tableView.frame)+20, exitImage.size.width, exitImage.size.height)];
    [exitButton setBackgroundImage:exitImage forState:UIControlStateNormal];
    exitButton.tag=EXIT_LOGIN_TAG;
    [exitButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:exitButton];
    
    
}


- (void)btnClick:(UIButton *)btn
{
    if (btn.tag ==1001)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    if (btn.tag==EXIT_LOGIN_TAG)
    {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"确定退出广而告之?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil, nil];
        alvertView.tag=EXIT_ALERTVIEW_TAG;
        [alvertView show];
  
    }
    if (btn.tag==SWITCH_BUTTON_TAG)
    {
        if (_isPush)
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否关闭推送？关闭后会错过很多精彩内容！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag=PUSH_OFF_TAG;
            [alertView show];
            
        }else
        {
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否开启推送功能？定时推送精彩内容！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alertView.tag=PUSH_ON_TAG;
//            [alertView show];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"switch_open.png"] forState:UIControlStateNormal];
            _isPush=YES;
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                UIRemoteNotificationTypeAlert) categories:nil];
        }
    }
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIButton *switchButton=(UIButton *)[_tableView viewWithTag:SWITCH_BUTTON_TAG];
    if (alertView.tag==PUSH_OFF_TAG) {
        if (buttonIndex==0) {
            
           
            
        }else{
            [switchButton setBackgroundImage:[UIImage imageNamed:@"switch_close.png"] forState:UIControlStateNormal];
            _isPush=NO;

            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }
    }
    if (alertView.tag==PUSH_ON_TAG) {
        if (buttonIndex==0) {
    
        }else{
            [switchButton setBackgroundImage:[UIImage imageNamed:@"switch_open.png"] forState:UIControlStateNormal];
            _isPush=YES;
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert) categories:nil];
        }
    }
    if (alertView.tag==VERSION_TAG) {
        if (buttonIndex==1) {
            
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_path]];
        }
    }
    if (alertView.tag==EXIT_ALERTVIEW_TAG)
    {
        if (buttonIndex==1)
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:PERSON_HOME_HAVE];

            [defaults setBool:NO forKey:USER_IS_LOGIN];
            [defaults setObject:@"" forKey:USER_ID];
            [defaults setObject:@"" forKey:USER_TICKET];
            [defaults synchronize];
          
//            MMIALoginViewController *loginVC=[[MMIALoginViewController alloc]init];
//            [self.navigationController pushViewController:loginVC animated:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
            
//            AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
//            [app.tabController switchToFirst];
        }
    }
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[_dataArray objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"ListID";
    MMIAGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[MMIAGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName ];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
           cell.setGroup = YES;
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *imgStr=[[_imageArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.MGTVCImageView.image=[UIImage imageNamed:imgStr];
    cell.MGTVCTitleLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.MGTVCAccessoryView.image=[UIImage imageNamed:@"setting_01.png"];
    if (indexPath.section==1 &&  indexPath.row==1) {
        cell.MGTVCAccessoryView.hidden=YES;
        UIButton *switchButton=[[UIButton alloc]initWithFrame:CGRectMake(App_Frame_Width-20-10-40, (40-22)/2, 40, 43/2)];
        [switchButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        switchButton.tag=SWITCH_BUTTON_TAG;
        [switchButton setBackgroundImage:[UIImage imageNamed:@"switch_open.png"] forState:UIControlStateNormal];
        _isPush=YES;
       
        [cell.MGTVCContentView addSubview:switchButton];
    }
    
    
    /*
     if (indexPath.row==0&&indexPath.section == 1) {
     cell.MGTVCTitleLabel.textAlignment =  MMIATextAlignmentCenter;
     }
     */
    [cell resetSubViewWithSize:[tableView rectForRowAtIndexPath:indexPath].size withCellIndexPath:indexPath cellNumber:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==0)
    {
     
        int type=_item.userType;
        if (type==1)
        {
            MMiaCompanyDataSetViewController *companyDSvc = [[MMiaCompanyDataSetViewController alloc]initWithLoginItem:_item];
            [self.navigationController pushViewController:companyDSvc animated:YES];
           
        }else
        {
            MMiaDataSetViewController *dataSetVc = [[MMiaDataSetViewController alloc]initWithLoginItem:_item];
            [self.navigationController pushViewController:dataSetVc animated:YES];
        }
    }
    if (indexPath.section==0 && indexPath.row==1)
    {
        MMiaSetAccountViewController *setAccountVC=[[MMiaSetAccountViewController alloc]init];
        [self.navigationController pushViewController:setAccountVC animated:YES];
    }
    if (indexPath.section==1  && indexPath.row==0)
    {
        MMIAFeedBackViewController *feedVC=[[MMIAFeedBackViewController alloc]init];
        [self.navigationController pushViewController:feedVC animated:YES];
    }
    if (indexPath.section==1 && indexPath.row==2)
    {
        if (_isVersion==NO) {
            
                        [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
                        _timer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(webTimerOut) userInfo:nil repeats:YES];
                      MMIProcessView *processView=[[MMIProcessView alloc]initWithMessage:@"版本检测中,请稍后..." top:Main_Screen_Height-60];
                       processView.tag=PRCESS_VIEW_TAG;
                        [processView showInRootView:_bgView];
                       _isVersion=YES;
                    }

    }
    if (indexPath.section==2 && indexPath.row==0)
    {
        MMIAEditionInforViewController *editionVC=[[MMIAEditionInforViewController alloc]init];
        [self.navigationController pushViewController:editionVC animated:YES];
    }
    if (indexPath.section==2 && indexPath.row==1)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                       AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                        [appDelegate.mmiaDataEngine emptyCache];
           
                       dispatch_sync(dispatch_get_main_queue(), ^{
            
                                              [MMIToast showWithText:@"本地缓存清除成功" topOffset:Main_Screen_Height-20 image:nil];
                           
                                       });
                                  });
    }
    
   
//    if ( indexPath.row!=2 && indexPath.row!=3 ) {
//    }else if (indexPath.row==2)
//    {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//            [appDelegate.mmiaDataEngine emptyCache];
//            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                
//                                    [MMIToast showWithText:@"本地缓存清除成功" topOffset:TOP_OFF_SET image:nil];
//                
//               
//            });
//        });
//        
//        
//    }else if (indexPath.section==1) {
//        if (_isVersion) {
//           
//            [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
//             _timer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(webTimerOut) userInfo:nil repeats:YES];
//            MMIProcessView *processView=[[MMIProcessView alloc]initWithMessage:@"版本检测中,请稍后..." top:PROCESS_HEIGHT];
//            processView.tag=PRCESS_VIEW_TAG;
//            [processView showInRootView:_bgView];
//            _isVersion=NO;
//        }
//        
//        
//        
//    }
//    
    
    
}
- (void) show_check_phone_info:(NSString *)_str{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:kTipsTopOffset image:nil];
    
}
//超时判断
-(void)webTimerOut
{
    MMIProcessView *processView=(MMIProcessView *)[_bgView viewWithTag:PRCESS_VIEW_TAG];
    if ([_timer isValid]) {
        [MMIToast showWithText:@"版本检测失败，请稍后重试" topOffset:Main_Screen_Height-20 image:nil];
        [_timer invalidate];
        _timer = nil;
    }
    _isVersion=NO;
    [processView dismiss];
}



-(void)updateMethod:(NSDictionary *)info
{
    MMIProcessView *processView=(MMIProcessView *)[_bgView viewWithTag:PRCESS_VIEW_TAG];
    
    
    if (info==nil) {
        _isVersion=NO;
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }

        
        [processView dismiss];
        return;
    }
    
    NSString *path=[info objectForKey:@"path"];
//    if ([path rangeOfString:@"https://"].location==NSNotFound) {
//        _path=[NSString stringWithFormat:@"https://%@",path];
//    }else{
//        _path=path;
//    }
    _path=path;
    
    if ([[info objectForKey:@"update"]isEqualToString:@"NO"]) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"已经是最新版本" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alertView show];
        
    }
    if ([[info objectForKey:@"update"]isEqualToString:@"YES"]) {
        
        
        NSString *title=[NSString stringWithFormat:@"版本%@",[info objectForKey:@"version"]];
        NSString *message=[info objectForKey:@"update_log"];
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"忽略此版本" otherButtonTitles:@"访问Store", nil];
        alertView.tag=VERSION_TAG;
        [alertView show];
        
        
        
    }
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }

    [processView dismiss];
    _isVersion=NO;
   // [_processView dismiss];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
