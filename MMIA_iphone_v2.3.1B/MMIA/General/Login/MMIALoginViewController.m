//
//  MMIALoginViewController.m
//  MMIAAdIphone
//
//  Created by Vivian's Office MAC on 14-2-12.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIALoginViewController.h"
#import "MMIARegistTwoViewController.h"
#import "MMIAForgetPasswordViewController.h"
#import "MMiaCommonUtil.h"
#import "MMIProcessView.h"
#import "MMIAPersonalHomePageViewController.h"
#import "LoginUserItem.h"
#import "MMIToast.h"
#import "NSMutableDictionary+extent.h"
// use MD5
#import "NSString+MKNetworkKitAdditions.h"


////////////////////////////////////////////////////////////////////////////////////////
#define REGISTER_TAG         101
#define LOGIN_TAG            102
#define FORGET_PASSWORD_TAG  103
#define CLOSE_BTN_TAG        100
#define USER_NAME_TEXT_TAG   200
#define PASS_WORD_TEXT_TAG   201
#define RELATED_LOGIN_TAG    300
#define PROCESS_VIEW_TAG     400
@interface MMIALoginViewController ()
{
    id target;
    SEL logonSuccessAction;
    SEL registerSuccessAction;
}

@end

@implementation MMIALoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUI];
    [self setNaviBarViewBackgroundColor:[UIColor clearColor]];
    [self addNewBackBtnWithTarget:self selector:@selector(btnClick:)];
}

#pragma mark - LoadUI

- (void)loadUI
{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"login_bg.png"];
    [self.view insertSubview:bgImageView belowSubview:self.navigationView];
    
    UIImage *logoImage = [UIImage imageNamed:@"loginpage_icon.png"];
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((App_Frame_Width - logoImage.size.width)/2, VIEW_OFFSET + 55, logoImage.size.width, logoImage.size.height)];
    logoImageView.image = logoImage;
    [self.view addSubview:logoImageView];
    int offset = 0;
    if (App_Frame_Height < 568)
    {
        offset = 10;
    }
    UIImage *userImage = [UIImage imageNamed:@"loginpage_usernameicon.png"];
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(logoImageView.frame) + 40 - offset, userImage.size.width + 20, 42)];
    userImageView.contentMode = UIViewContentModeLeft;
    userImageView.image = userImage;
    [self.view addSubview:userImageView];
    UITextField *userTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImageView.frame), CGRectGetMaxY(logoImageView.frame) + 40 - offset, App_Frame_Width - 10 - CGRectGetMaxX(userImageView.frame), 42)];
    userTextFiled.tag = USER_NAME_TEXT_TAG;
    userTextFiled.delegate = self;
    if (iOS7)
    {
        userTextFiled.tintColor = UIColorFromRGB(0x272832);

    }
    userTextFiled.returnKeyType = UIReturnKeyNext;
    userTextFiled.backgroundColor = [UIColor clearColor];
    userTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    UIColor *palceColor = UIColorFromRGB(0x404040);
    userTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入邮箱/手机号" attributes:@{NSForegroundColorAttributeName: palceColor}];
    userTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userTextFiled.textColor =  UIColorFromRGB(0xffffff);
    userTextFiled.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:userTextFiled];
    UILabel *userLine = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(userTextFiled.frame), App_Frame_Width - 30, 0.5)];
    userLine.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:userLine];
    
    UIImage *passWordImage = [UIImage imageNamed:@"loginpage_passwordicon.png"];
    UIImageView *passWordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(userLine.frame), passWordImage.size.width + 20, 42)];
    passWordImageView.contentMode = UIViewContentModeLeft;
    passWordImageView.image = passWordImage;
    [self.view addSubview:passWordImageView];
    UITextField *passWordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passWordImageView.frame), CGRectGetMaxY(userLine.frame), App_Frame_Width - 10 - CGRectGetMaxX(passWordImageView.frame), 42)];
    passWordTextFiled.tag = PASS_WORD_TEXT_TAG;
    passWordTextFiled.delegate = self;
    if (iOS7)
    {
       passWordTextFiled.tintColor = UIColorFromRGB(0x272832);
    }
    passWordTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    passWordTextFiled.secureTextEntry = YES;
    passWordTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"密码：6位-20位密码" attributes:@{NSForegroundColorAttributeName: palceColor}];
    passWordTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passWordTextFiled.textColor =  UIColorFromRGB(0xffffff);
    passWordTextFiled.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:passWordTextFiled];
    UILabel *passWordLine = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(passWordTextFiled.frame), App_Frame_Width - 30, 0.5)];
    passWordLine.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:passWordLine];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.tag = LOGIN_TAG;
    loginButton.frame = CGRectMake((App_Frame_Width - 290)/2, CGRectGetMaxY(passWordLine.frame) + 25, 290, 89/2);
    loginButton.backgroundColor = UIColorFromRGB(0xe43f50);
    loginButton.layer.cornerRadius = 2.5;
    loginButton.clipsToBounds = YES;
    [loginButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setImage:[UIImage imageNamed:@"loginpage_loginbutton.png"] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    CGFloat yOffset = 135;
    if (App_Frame_Height > 480)
    {
        yOffset = 175;
    }
    
    //qq and sina
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqButton.frame = CGRectMake((App_Frame_Width - 290)/2, App_Frame_Height - yOffset, 290, 45);
    qqButton.tag = RELATED_LOGIN_TAG;
    qqButton.clipsToBounds = YES;
    qqButton.layer.cornerRadius = 2.5;
    qqButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    qqButton.layer.borderColor = [UIColorFromRGB(0xffffff)CGColor];
    qqButton.layer.borderWidth = 0.5;
    [qqButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [qqButton setImage:[UIImage imageNamed:@"loginpage_qqicon.png"] forState:UIControlStateNormal];
    [qqButton setImage:[UIImage imageNamed:@"loginpage_qqicon.png"] forState:UIControlStateHighlighted];
    [qqButton setTitle:@" QQ登录" forState:UIControlStateNormal];
    qqButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:qqButton];
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaButton.tag = RELATED_LOGIN_TAG + 1;
    sinaButton.frame = CGRectMake((App_Frame_Width - 290)/2, CGRectGetMaxY(qqButton.frame) + 15/2, 290, 45);
    sinaButton.clipsToBounds = YES;
    sinaButton.layer.cornerRadius = 2.5;
    sinaButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    sinaButton.layer.borderColor = [UIColorFromRGB(0xffffff)CGColor];
    sinaButton.layer.borderWidth = 0.5;
    [sinaButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sinaButton setImage:[UIImage imageNamed:@"loginpage_sinaicon.png"] forState:UIControlStateNormal];
    [sinaButton setImage:[UIImage imageNamed:@"loginpage_sinaicon.png"] forState:UIControlStateHighlighted];
    [sinaButton setTitle:@" 微博登录" forState:UIControlStateNormal];
    sinaButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:sinaButton];
    
    //忘记密码 注册
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(0, App_Frame_Height - 30 - 3, 90, 30);
    forgetButton.tag = FORGET_PASSWORD_TAG;
    [forgetButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetButton.titleLabel setTextAlignment:MMIATextAlignmentLeft];
    [forgetButton setBackgroundColor:[UIColor clearColor]];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [self.view addSubview:forgetButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.tag = REGISTER_TAG;
    registerButton.frame = CGRectMake(App_Frame_Width - 60, App_Frame_Height - 30 - 3, 60, 30);
    [registerButton setBackgroundColor:[UIColor clearColor]];
    [registerButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    registerButton.titleLabel.textAlignment = MMIATextAlignmentRight;
    [self.view addSubview:registerButton];    
}

- (void)setTarget:(id)tar withSuccessAction:(SEL)action withRegisterAction:(SEL)action1
{
    target = tar;
    logonSuccessAction = action;
    registerSuccessAction = action1;
}

#pragma mark - controlEvent
/*
 @param   button
 @descripation  按钮点击事件
 */
- (void)btnClick:(UIButton *)btn
{
    [self resignAllResponder];
    if (btn.tag==1003)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == LOGIN_TAG)
    {
        [self login];
        
    }
    if (btn.tag == REGISTER_TAG)
    {
        MMIARegistTwoViewController *rvc = [[MMIARegistTwoViewController alloc]init];
        [rvc setTarget:target withRegisterAction:registerSuccessAction];
        [self.navigationController pushViewController:rvc animated:YES];
    }
    
    if (btn.tag == FORGET_PASSWORD_TAG) {
        MMIAForgetPasswordViewController *newPassVC = [[MMIAForgetPasswordViewController alloc]init];
        [newPassVC setTarget:target withRegisterAction:registerSuccessAction];
        [self.navigationController pushViewController:newPassVC animated:YES];
    }
    if (btn.tag>=RELATED_LOGIN_TAG&&btn.tag<=RELATED_LOGIN_TAG+3) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"丧心病狂开发中..." message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
        //QQ关联
        if (btn.tag==RELATED_LOGIN_TAG) {
        }
        //新浪微博
        if (btn.tag==RELATED_LOGIN_TAG+1) {
            
        }
    }
}


#pragma mark - login
/*
 @param   nil
 @descripation  判断能不能登录（检查输入是否完整）
 */

- (void)login
{
    MMIProcessView *processView=(MMIProcessView *)[self.view viewWithTag:PROCESS_VIEW_TAG];
    [processView dismiss];
    if ([self canLogin])
    {
        MMIProcessView *processView=[[MMIProcessView alloc]initWithMessage:@"登录中..." top:Main_Screen_Height];
        processView.tag=PROCESS_VIEW_TAG;
        [processView showInRootView:self.view];
        [self sendLoginRequest];
    }
    
}

- (BOOL)canLogin
{
    UITextField *userName = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
    UITextField *passWord = (UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG];
    
    if (userName.text.length!=0&&passWord.text.length!=0) {
        return YES;
    }else{
        [self show_check_phone_info:@"账号/密码不能为空" image:nil];
        return NO;
    }
}
#pragma marks-SendRequest
/*
 @param   nil
 @descripation 登录
 */

-(void)sendLoginRequest{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    MMIProcessView *processView = (MMIProcessView *)[self.view viewWithTag:PROCESS_VIEW_TAG];
    UITextField *userName = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
    UITextField *passWord = (UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG];
    NSDictionary *infoDict=[[NSDictionary alloc]initWithObjectsAndKeys:userName.text,@"loginName",[passWord.text md5],@"password", nil];
    
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_LOGIN_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
               [processView dismiss];
        // 登录成功
        if ([jsonObject[@"result"]intValue]==0)
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:jsonObject[@"id"] forKey:USER_ID];
            [defaults setObject:jsonObject[@"ticket"] forKey:USER_TICKET];
            [defaults setBool:YES forKey:USER_IS_LOGIN];
            [defaults setObject:jsonObject[@"userType"] forKey:USER_TYPE];
            
            [defaults synchronize];
            if( [target respondsToSelector:logonSuccessAction] )
            {
                [target performSelector:logonSuccessAction];
            }
        }
        else
        {
            [self show_check_phone_info:jsonObject[@"message"] image:nil];
        }
        
    }errorHandler:^(NSError* error){
        [processView dismiss];

        if ([appDelegate.mmiaDataEngine isReachable]==NO)
        {
            [self show_check_phone_info:@"没有网络连接" image:nil];
        }else
        {
            [self show_check_phone_info:@"网络异常，请重试" image:nil];
            
        }
        [processView dismiss];
    }
     
     ];
}

#pragma mark-TextFiledDelegate

- (void)resignAllResponder
{
    UITextField *nameTextField = ((UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG]);
    UITextField *passTextField = ((UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG]);
    [nameTextField resignFirstResponder];
    [passTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField *textField = ((UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG]);
     UITextField *passWordtextField = ((UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG]);
    [textField resignFirstResponder];
    [passWordtextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *passWordTextFiled=(UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG];
    if (textField.tag == USER_NAME_TEXT_TAG)
    {
        [textField resignFirstResponder];
        [passWordTextFiled becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

//#pragma mark-MMIEmailPromptDelegate
//-(void)sendSelectCellStr:(NSString *)str{
//    UITextField *mail = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
//    // NSMutableString *mutabMailTextStr=[NSMutableString stringWithString:mail.text];
//    //[mutabMailTextStr appendString:str];
//    mail.text=str;
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
