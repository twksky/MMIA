//
//  MMiaChangePassWordViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-16.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaChangePassWordViewController.h"
#import "MMIToast.h"
#import "MMIALoginViewController.h"
// use MD5
#import "NSString+MKNetworkKitAdditions.h"

#define OLD_PASSWORED_TAG   100
#define NEW_PASSWORED_TAG   101
#define SURE_PASSWORED_TAG  102
#define FINISH_BUTTON_TAG   103

@interface MMiaChangePassWordViewController (){
    UIView *_bgView;
}

@end

@implementation MMiaChangePassWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initEditUIWithTitleName:(NSString *)titleName andEditTextImage:(NSString *)editImage andTextFieldTag:(NSInteger)textFieldTag andFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 3.0f;
    view.layer.borderColor = [UIColorFromRGB(0xEAEAEA) CGColor];
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowColor = [UIColorFromRGB(0x000000) CGColor];
    view.layer.shadowOpacity = 0.5;
    
    //添加输入视图
    [self initializeTextFieldWithFrame:CGRectMake(20, (frame.size.height-30)/2.0f, frame.size.width-20, 30) andTag:textFieldTag andPlaceholder:titleName  andSecureTextEntry:YES andSuperView:view];
    
    [_bgView addSubview:view];
}
#pragma marks-textFiledInit
- (void)initializeTextFieldWithFrame:(CGRect)rect andTag:(NSInteger)tag andPlaceholder:(NSString *)placeholder andSecureTextEntry:(BOOL)secureTextEntry andSuperView:(UIView *)superView
{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate=self;
    if (tag!=0) {
        textField.tag=tag;
    }
    if (placeholder!=nil) {
        textField.placeholder=placeholder;
    }
    if (secureTextEntry) {
        textField.secureTextEntry=secureTextEntry;
        
    }
    textField.clearButtonMode=UITextFieldViewModeAlways;
    textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [superView addSubview:textField];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNavView];
    [self loadBgView];
}

#pragma mark -LoadUI
- (void)loadNavView
{
    [self setTitleString:@"修改密码"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
   
}
-(void)loadBgView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, SCREEN_WIDTH, Main_Screen_Height-20-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    
    //添加信息输入栏
    [self initEditUIWithTitleName:@"旧密码" andEditTextImage:@"login_ico_activation" andTextFieldTag:OLD_PASSWORED_TAG andFrame:CGRectMake(10, 10,_bgView.frame.size.width-20 ,44)];
    UITextField *oldPassTextFiled = ((UITextField *)[_bgView viewWithTag:OLD_PASSWORED_TAG]);
    oldPassTextFiled.delegate=self;
    
    
    [self initEditUIWithTitleName:@"密码:6位-20位密码" andEditTextImage:@"login_ico_password" andTextFieldTag:NEW_PASSWORED_TAG andFrame:CGRectMake(10, 58,_bgView.frame.size.width-20 ,44)];
    UITextField *passWordTextFiled = ((UITextField *)[_bgView viewWithTag:NEW_PASSWORED_TAG]);
    passWordTextFiled.delegate=self;
    
    
    [self initEditUIWithTitleName:@"确认密码" andEditTextImage:@"login_ico_password" andTextFieldTag: SURE_PASSWORED_TAG andFrame:CGRectMake(10, 106,_bgView.frame.size.width-20 ,44)];
    UITextField *confirmTextField = ((UITextField *)[_bgView viewWithTag: SURE_PASSWORED_TAG]);
    confirmTextField.delegate=self;
    
    
    UIButton *finishButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 160, App_Frame_Width-20, 44)];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"login_04.png"] forState:UIControlStateNormal];
    finishButton.tag=FINISH_BUTTON_TAG;
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:finishButton];
    
}

-(BOOL)isCanChange
{
     UITextField *oldPassTextFiled = ((UITextField *)[_bgView viewWithTag:OLD_PASSWORED_TAG]);
    UITextField *passWordTextFiled = ((UITextField *)[_bgView viewWithTag:NEW_PASSWORED_TAG]);
     UITextField *confirmTextField = ((UITextField *)[_bgView viewWithTag: SURE_PASSWORED_TAG]);
    if (oldPassTextFiled.text.length==0)
    {
        [self show_check_phone_info:@"请输入旧密码" image:nil];
        return NO;
    }
    if (passWordTextFiled.text.length==0)
    {
        [self show_check_phone_info:@"请输入新密码" image:nil];
        return NO;
    }
    if (confirmTextField.text.length==0)
    {
        [self show_check_phone_info:@"请输入确认密码" image:nil];
        return NO;

    }
    if (passWordTextFiled.text.length!=6)
    {
        [self show_check_phone_info:@"密码为6-20个字母、数字" image:nil];
        return NO;
    }
    if ([passWordTextFiled.text isEqualToString:confirmTextField.text]==NO)
    {
         [self show_check_phone_info:@"新密码和确认密码不一样" image:nil];
        return NO;
    }
    return YES;
    
    
}
#pragma mark -btnClick
-(void)btnClick:(UIButton *)button
{
    if (button.tag==1001)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag==FINISH_BUTTON_TAG)
    {
        if ([self isCanChange])
        {
            [self resiginAllResponder];
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSString *userTicket=[defaults objectForKey:USER_TICKET];
            if (!userTicket)
            {
                userTicket=@"";
            }
            //int userId=[[defaults objectForKey:USER_ID]intValue];
            UITextField *oldPassTextFiled = ((UITextField *)[_bgView viewWithTag:OLD_PASSWORED_TAG]);
            UITextField *passWordTextFiled = ((UITextField *)[_bgView viewWithTag:NEW_PASSWORED_TAG]);
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:userTicket,@"ticket",[oldPassTextFiled.text md5],@"oldpassword",[passWordTextFiled.text md5],@"newpassword", nil];
        
            AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_CHANGE_PASSWORD_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *dict){
                if ([[dict objectForKey:@"result"]intValue]==0) {
                    [self show_check_phone_info:@"修改密码成功" image:nil];
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    [ defaults setBool:NO forKey:USER_IS_LOGIN];
                    [defaults setObject:@"" forKey:USER_ID];
                    [defaults setObject:@"" forKey:USER_TICKET];
                    [defaults synchronize];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else
                {
                    [self show_check_phone_info:dict[@"message"] image:nil];
   
                }
                
            }errorHandler:^(NSError *error){
                if ([app.mmiaDataEngine isReachable]==NO)
                {
                    [self show_check_phone_info:@"没有网络连接" image:nil];
                }else
                {
                    [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
                    
                }

                
            }];
        }
    }
    
}

#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self resiginAllResponder];
    
}
-(void)resiginAllResponder
{
    UITextField *oldPassTextFiled = ((UITextField *)[_bgView viewWithTag:OLD_PASSWORED_TAG]);
    UITextField *passWordTextFiled = ((UITextField *)[_bgView viewWithTag:NEW_PASSWORED_TAG]);
    UITextField *confirmTextField = ((UITextField *)[_bgView viewWithTag: SURE_PASSWORED_TAG]);
    [oldPassTextFiled resignFirstResponder];
    [passWordTextFiled resignFirstResponder];
    [confirmTextField resignFirstResponder];
}
#pragma mark - textFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==NEW_PASSWORED_TAG )
    {
        if (textField.text.length>=6 && ![string isEqualToString:@""])
        {
            return NO;
        }
        
        
    }
    return YES;
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
