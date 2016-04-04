//
//  MMiaMagezineEditViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-15.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaMagezineEditViewController.h"
#import "MMiaSetDataViewCell.h"
#import "MMIToast.h"
#import "MMiaTextPromptAlertView.h"
#import "MMIAPersonalHomePageViewController.h"

#define PUBLIC_BUTTON_TAG 100
#define DELETE_BUTTON_TAG 101

@interface MMiaMagezineEditViewController (){
    UIView       *_bgView;
    UITableView  *_tableView;
    NSString     *_name;
    NSString     *_description;
    NSString          *_type;
    int           _public;
    int          _categoryId;
    NSInteger          _magazineId;
    }
@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,retain)NSArray *contentArray;

@end

@implementation MMiaMagezineEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithMagezineId:(NSInteger)magazineId Name:(NSString *)name Description:(NSString *)description Type:(NSString *)type CategoryId:(int)categoryId Public:(int)public
{
    self=[super init];
    if (self)
    {
        _magazineId=magazineId;
        _name=name;
        _description=description;
        _type=type;
        _categoryId=categoryId;
        _public=public;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *arr1=[NSArray arrayWithObjects:_name,_description,_type, nil];
    NSArray *arr2=[NSArray arrayWithObjects:@"", nil];
    self.contentArray=[[NSArray alloc]initWithObjects:arr1,arr2, nil];
    [self loadNavView];
    [self loadBgView];
}
#pragma mark -loadUI
- (void)loadNavView
{
    [self setTitleString:@"编辑专题"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
    [self addRightBtnWithTarget:self selector:@selector(btnClick:)];
    UIButton *rightButton=(UIButton *)[self.view viewWithTag:1002];
    [rightButton setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    UIImage *rightButtonImage=[UIImage imageNamed:@"btn_save.png"];
    rightButton.frame=CGRectMake(App_Frame_Width-rightButtonImage.size.width-10, (44-rightButtonImage.size.height)/2 + VIEW_OFFSET, rightButtonImage.size.width, rightButtonImage.size.height);
    rightButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_save.png"]];
   
    
}
- (void)loadBgView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, Main_Screen_Height-20-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    NSArray *arr1=[NSArray arrayWithObjects:@"名称",@"专题描述",@"专题类型", nil];
    NSArray *arr2=[NSArray arrayWithObjects:@"是否公开", nil];
    self.dataArray=[NSArray arrayWithObjects:arr1,arr2, nil];

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, 190) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor clearColor];
   // _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    _tableView.bounces=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_bgView addSubview:_tableView];
    
       
    UIButton *deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 190, App_Frame_Width-20, 44)];
    deleteButton.tag=DELETE_BUTTON_TAG;
    [deleteButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"login_04.png"] forState:UIControlStateNormal];
    [deleteButton setTitle:@"删除专题" forState:UIControlStateNormal];
    [_bgView addSubview:deleteButton];

    
  
}
#pragma mark -sendRequest
//修改杂志
-(void)sendEditMagezineRequest
{
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
    NSMutableDictionary *infoDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userid",userTicket,@"ticket",nil];
    if (_name.length==0)
    {
         [self show_check_phone_info:@"请输入专题名称" image:nil];
        return;
    }
    if (_type.length==0)
    {
         [self show_check_phone_info:@"请选择专题类型" image:nil];
        return;
    }
    [infoDict setObject:_name forKey:@"name"];
    [infoDict setObject:_description forKey:@"description"];
    [infoDict setObject: _type forKey:@"category"];
    [infoDict setObject:[NSNumber numberWithInt:_categoryId] forKey:@"categoryId"];
        [infoDict setObject:[NSNumber numberWithInt:_public] forKey:@"isPublic"];
    [infoDict setObject:[NSNumber numberWithLong:_magazineId] forKey:@"magazineId"];
    
    UIButton *sureButton=(UIButton *)[self.navigationView viewWithTag:1002];
    [sureButton setEnabled:NO];
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_EDIT_MAGEZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        [sureButton setEnabled:YES];
        if ([jsonDict[@"result"]intValue]==0) {
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:Change_MagezineData object:nil];
            [self show_check_phone_info:jsonDict[@"msg"] image:nil];
            NSArray *controllers=self.navigationController.viewControllers;
            for (UIViewController *vc in controllers)
            {
                if ([vc isKindOfClass:[MMIAPersonalHomePageViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }

        }else
        {
            [self show_check_phone_info:jsonDict[@"msg"] image:nil];
  
        }
        
    }errorHandler:^(NSError *error){
         [sureButton setEnabled:YES];
        if ([app.mmiaDataEngine isReachable]==NO)
        {
            [self show_check_phone_info:@"没有网络连接" image:nil];
        }else
        {
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
            
        }

    }];
   
}
//删除杂志
-(void)sendDeleteMagezineRequest
{
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
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:userTicket,@"ticket",[NSNumber numberWithInt:userId],@"userid",[NSNumber numberWithLong:_magazineId],@"magazineId", nil];
    
    UIButton *deleteButton=(UIButton *)[_bgView viewWithTag:DELETE_BUTTON_TAG];
    [deleteButton setEnabled:NO];
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_DELETE_MAGEZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
         [deleteButton setEnabled:YES];
        
        if ([jsonDict[@"result"]intValue]==0) {
            [self show_check_phone_info:jsonDict[@"msg"] image:nil];
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:Change_MagezineData object:nil];
            
            NSArray *controllers=self.navigationController.viewControllers;
            for (UIViewController *vc in controllers)
            {
                if ([vc isKindOfClass:[MMIAPersonalHomePageViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }

        }else{
            [self show_check_phone_info:jsonDict[@"msg"] image:nil];
        }
            
    }errorHandler:^(NSError *error){
        
          [deleteButton setEnabled:YES];
        
        if ([app.mmiaDataEngine isReachable]==NO)
        {
            [self show_check_phone_info:@"没有网络连接" image:nil];
        }else
        {
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
        }
    }];
}



#pragma mark -btnClick
-(void)btnClick:(UIButton *)button
{
    if (button.tag==1001)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag==1002) {
        //保存
        [self sendEditMagezineRequest];
    }
    
    if (button.tag==PUBLIC_BUTTON_TAG) {
        if (_public) {
            [UIView animateWithDuration:0.3 animations:^{
                [button setBackgroundImage:[UIImage imageNamed:@"switch_close.png"] forState:UIControlStateNormal];
                
            }];
            _public=NO;
            
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [button setBackgroundImage:[UIImage imageNamed:@"switch_open.png"] forState:UIControlStateNormal];
            }];
            
            _public=YES;
        }
        
        
    }
    if (button.tag==DELETE_BUTTON_TAG)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"删除专题" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }

}

- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    [MMIToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}




#pragma mark -alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self sendDeleteMagezineRequest];
    }
}
#pragma marks -tableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[self.dataArray objectAtIndex:section] count];
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
    NSString *contentStr=[[self.contentArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
   
    cell.contentLabel.text=contentStr;
    if (indexPath.section==1)
    {
        cell.accessoryImageView.hidden=YES;
        UIButton *switchButton=[[UIButton alloc]initWithFrame:CGRectMake(App_Frame_Width-20-10-40,(CGRectGetHeight(cell.contentView.bounds)-44/2)/2, 40, 44/2)];
               [switchButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (_public==1)
        {
            _public=YES;
            [switchButton setBackgroundImage:[UIImage imageNamed:@"switch_open.png"] forState:UIControlStateNormal];

        }else
        {
            _public=NO;
            [switchButton setBackgroundImage:[UIImage imageNamed:@"switch_close.png"] forState:UIControlStateNormal];
                
        }
        switchButton.tag=PUBLIC_BUTTON_TAG;
        [cell.lineContentView addSubview:switchButton];
        
    }
    [cell resetSubViewWithSize:[tableView rectForRowAtIndexPath:indexPath].size withCellIndexPath:indexPath cellNumber:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        return;
    }
      NSString *title=[[self.dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    MMiaSetDataViewCell *cell=(MMiaSetDataViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
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
            if (indexPath.section==0 && indexPath.row==0)
            {
                _name=contentStr;
            }else if (indexPath.section==0 && indexPath.row==1)
            {
                _description=contentStr;
            }
//            if (contentStr.length>8 && indexPath.row!=2 && indexPath.section==0)
//            {
//                contentStr=[NSString stringWithFormat:@"%@...",[textView.text substringToIndex:8]];
//            }
            
            cell.contentLabel.text=contentStr;
        }];
        [self.view addSubview:alert];
        [alert show];
        
    }else
    {
        
         MMiaMagezineTypeView *typeView=[[MMiaMagezineTypeView alloc]initWithFrame:self.view.bounds selctStr:_type];
      
        typeView.delegate=self;
        [self.view addSubview:typeView];
    }
    
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

#pragma mark - MMiaMagezineTypeViewDelegate
-(void)sendMMiaMagezineType:(MMiaMagezineTypeView *)magazineTypeView
{
    NSIndexPath* indexPath = [_tableView indexPathForSelectedRow];
    MMiaSetDataViewCell *cell=(MMiaSetDataViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.text=magazineTypeView.item.secondType;
    _type=magazineTypeView.item.secondType;
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
