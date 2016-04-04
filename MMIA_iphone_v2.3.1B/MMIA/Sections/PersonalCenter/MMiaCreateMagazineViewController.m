//
//  MMiaCreateMagazineViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-11.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaCreateMagazineViewController.h"
#import "MMiaSetDataViewCell.h"
#import "MMIToast.h"
#import "MMIAGroupTableViewCell.h"
#import "MMiaTextPromptAlertView.h"


#define PUBLIC_BUTTON_TAG 100

@interface MMiaCreateMagazineViewController (){
    UIView *_bgView;
    UITableView *_tableView;
    BOOL _isPublic;
    int  _categoryId;
    
}
@property(nonatomic,retain)NSArray *dataArray;

@end

@implementation MMiaCreateMagazineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *typePath = [documentsDirectory stringByAppendingPathComponent:@"magezineType.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:typePath]==NO)
    {
        [self getAllMagezineType];
    }
    
    [self loadNavView];
    [self loadBgView];
    
}

#pragma mark -loadUI
- (void)loadNavView
{
    [self setTitleString:@"创建专题"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];

    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
    [self addRightBtnWithTarget:self selector:@selector(btnClick:)];
    UIButton *rightButton=(UIButton *)[self.view viewWithTag:1002];
    [rightButton setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    UIImage *rightButtonImage=[UIImage imageNamed:@"login_16.png"];
    rightButton.frame=CGRectMake(App_Frame_Width-rightButtonImage.size.width-10, (44-rightButtonImage.size.height)/2 + VIEW_OFFSET, rightButtonImage.size.width, rightButtonImage.size.height);
    //rightButton.frame.size=CGSizeMake(CGRectGetWidth(rightButton.frame), CGRectGetHeight(rightButton.frame));
    rightButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_16.png"]];
    [rightButton setTitle:@"创建" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
}
- (void)loadBgView
{
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, Main_Screen_Height-20-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    NSArray *arr1=[NSArray arrayWithObjects:@"名称",@"专题描述",@"专题类型", nil];
    NSArray *arr2=[NSArray arrayWithObjects:@"是否公开", nil];
    self.dataArray=[NSArray arrayWithObjects:arr1,arr2, nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, 190)];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.bounces=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_bgView addSubview:_tableView];
     
}
#pragma mark -sendRequest
//lx add
//写文件
-(void)writeMagezineType:(NSArray *)array
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *typePath = [documentsDirectory stringByAppendingPathComponent:@"magezineType.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:typePath])
    {
        [fm removeItemAtPath:typePath error:nil];
    }
    [fm createFileAtPath:typePath contents:nil attributes:nil];
    [array writeToFile:typePath atomically:YES];
}

//类型杂志
-(void)getAllMagezineType
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlStr=@"humpback4/getZhuantiCategorys.do";
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:urlStr param:nil requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *dataDict)
     {
         if( [dataDict[@"result"] intValue] == 0 )
         {
             NSArray *dataArr=[dataDict objectForKey:@"data"];
             [self writeMagezineType:dataArr];
         }else
         {
             [MMIToast showWithText:@"获取专题类型失败" topOffset:Main_Screen_Height-20 image:nil];
         }
         
     }errorHandler:^(NSError *error){
         if ([appDelegate.mmiaDataEngine isReachable]==NO)
         {
             [self show_check_phone_info:@"没有网络连接" image:nil];
         }else
         {
             [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
             
         }

     }];
}


-(void)sendCreatMagazineRequest
{
    NSIndexPath *nameIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    MMiaSetDataViewCell *nameCell=(MMiaSetDataViewCell *)[_tableView cellForRowAtIndexPath:nameIndexPath];
    if (nameCell.contentLabel.text.length==0)
    {
        [self show_check_phone_info:@"请输入专题名称" image:nil];
        return;
    }
    NSIndexPath *descriptionIndexPath=[NSIndexPath indexPathForRow:1 inSection:0];
     MMiaSetDataViewCell *descriptionCell=(MMiaSetDataViewCell *)[_tableView cellForRowAtIndexPath:descriptionIndexPath];
    if (descriptionCell.contentLabel.text.length==0)
    {
        //[self show_check_phone_info:@"请输入专题描述" image:nil];
        descriptionCell.contentLabel.text=@"";
    }
    
    NSIndexPath *categoryIndexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    MMiaSetDataViewCell *categoryCell=(MMiaSetDataViewCell *)[_tableView cellForRowAtIndexPath:categoryIndexPath];
    if (categoryCell.contentLabel.text.length==0)
    {
        [self show_check_phone_info:@"请选择专题类型" image:nil];
        return;
    }
    
    UIButton *creatButton=(UIButton *)[self.navigationView viewWithTag:1002];
    [creatButton setEnabled:NO];
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
     NSMutableDictionary *infoDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userid",userTicket,@"ticket",nameCell.contentLabel.text,@"name",descriptionCell.contentLabel.text,@"description",categoryCell.contentLabel.text,@"category",[NSNumber numberWithInt:_categoryId],@"categoryId",nil];
    
    int public;
    if (_isPublic) {
        public=1;
    }else{
        public=0;
    }
    [infoDict setObject:[NSNumber numberWithInt:public] forKey:@"isPublic"];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_CREATE_MAGEZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         [creatButton setEnabled:YES];

        if ([jsonDict[@"result"]intValue]==0) {
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:Change_MagezineData object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        
    }else
        {
            [self show_check_phone_info:jsonDict[@"msg"] image:nil];
  
        }
    }errorHandler:^(NSError *error)
    {
        [creatButton setEnabled:YES];

        if ([app.mmiaDataEngine isReachable]==NO)
        {
            [self show_check_phone_info:@"没有网络连接" image:nil];
        }else
        {
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
            
        }
 
    }];
    
  
}

#pragma mark-btnClick
-(void)btnClick:(UIButton *)button
{
    if (button.tag==1001)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (button.tag==1002)
    {
        [self sendCreatMagazineRequest];
    }
    if (button.tag==PUBLIC_BUTTON_TAG) {
        if (_isPublic) {
            [UIView animateWithDuration:0.3 animations:^{
                [button setBackgroundImage:[UIImage imageNamed:@"switch_close.png"] forState:UIControlStateNormal];
  
            }];
                        _isPublic=NO;
            
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [button setBackgroundImage:[UIImage imageNamed:@"switch_open.png"] forState:UIControlStateNormal];
            }];
            
            _isPublic=YES;
        }
      
        
    }
}
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    [MMIToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}


#pragma marks -tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  [[self.dataArray objectAtIndex:section] count];
      //return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    MMiaSetDataViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[MMiaSetDataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
       // cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor=[UIColor clearColor];
    }
    cell.typeLabel.text=[[self.dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    //cell.typeLabel.text=[self.dataArray objectAtIndex:indexPath.row];
     cell.accessoryImageView.image=[UIImage imageNamed:@"setting_01.png"];
    if (indexPath.section==1)
    {
        cell.accessoryImageView.hidden=YES;
        UIButton *switchButton=[[UIButton alloc]initWithFrame:CGRectMake(App_Frame_Width-20-10-40,(CGRectGetHeight(cell.contentView.bounds)-44/2)/2, 40, 44/2)];
        [switchButton setBackgroundImage:[UIImage imageNamed:@"switch_open.png"] forState:UIControlStateNormal];
        [switchButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _isPublic=YES;
        switchButton.tag=PUBLIC_BUTTON_TAG;
        [cell.lineContentView addSubview:switchButton];
        
    }
     [cell resetSubViewWithSize:[tableView rectForRowAtIndexPath:indexPath].size withCellIndexPath:indexPath cellNumber:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        return;
    }
    MMiaSetDataViewCell *cell=(MMiaSetDataViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *title=[[self.dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    if ( indexPath.row!=2)
    {
        UITextView *textView;
        MMiaTextPromptAlertView *alert = [MMiaTextPromptAlertView promptWithTitle:title message:nil textView:&textView block:^(MMiaTextPromptAlertView *alert){
            
            [alert.textView resignFirstResponder];
            [alert removeFromSuperview];
            return YES;
        }];
        if (indexPath.row==0)
        {
            [alert setMaxLength:16];
        }else if (indexPath.row==1)
        {
            [alert setMaxLength:69];
        }else
        {
            [alert setMaxLength:1000];
        }
        [alert setCancelButtonWithTitle:@"退出" block:nil];
        [alert addButtonWithTitle:@"保存" block:^{
            NSString *contentStr=textView.text;

            
          cell.contentLabel.text=contentStr;
        }];
        [self.view addSubview:alert];
        [alert show];

    }else
    {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *typePath = [documentsDirectory stringByAppendingPathComponent:@"magezineType.plist"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:typePath]==NO)
        {
            return;
        }

         MMiaMagezineTypeView *typeView=[[MMiaMagezineTypeView alloc]initWithFrame:self.view.bounds selctStr:nil];
        typeView.delegate=self;
        [self.view addSubview:typeView];
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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

#pragma mark -alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }else{
        UITextField *textFiled=[alertView textFieldAtIndex:0];
     NSIndexPath* indexPath = [_tableView indexPathForSelectedRow];
        MMiaSetDataViewCell *cell=(MMiaSetDataViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        cell.contentLabel.text=textFiled.text;
        
    }
}
#pragma mark - MMiaMagezineTypeViewDelegate
-(void)sendMMiaMagezineType:(MMiaMagezineTypeView *)magazineTypeView
{
    NSIndexPath* indexPath = [_tableView indexPathForSelectedRow];
    MMiaSetDataViewCell *cell=(MMiaSetDataViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.text=magazineTypeView.item.secondType;
    _categoryId=magazineTypeView.item.secondId;
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
