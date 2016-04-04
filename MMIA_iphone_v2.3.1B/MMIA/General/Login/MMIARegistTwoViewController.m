//
//  MMIARegistTwoViewController.m
//  MMIAAdIphone
//
//  Created by Vivian's Office MAC on 14-2-12.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIARegistTwoViewController.h"
#import "MMIALoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MMiaCommonUtil.h"
#import "MMiaDataEngine.h"
#import "MMIAPersonalHomePageViewController.h"
#import "MMIALoginViewController.h"

#import "MMIEmailPrompt.h"
//验证成功出现的view
#import "MMIVerSucessView.h"
#import "MMIJudgeTypeUtil.h"
//弹出框
#import "MMIToast.h"
#import "MMIProcessView.h"
#import "LoginUserItem.h"


//button tag
#define Registe_BackButton_Tag           100
#define Registe_VertifyButton_Tag        101
#define Registe_Button_Tag               102

//UITextFiled tag
#define Registe_User_Tag                   200
#define Register_PassWord_Tag              201
#define Register_Confirme_PassWord_Tag     202
#define Register_Vertify_Tag               203

//正在验证信息提示
#define REGIST_IN_TAG                      300
//验证码成功提示
#define Vertify_Success_Tag                400

static NSString *code_Mail=@"getValidateCodeForMail/";
static NSString *code_Phone=@"getValidateCodeForPhone/";
static NSString *regist_Code=@"register/";

@interface MMIARegistTwoViewController ()

@end

@implementation MMIARegistTwoViewController
{
    UIButton *messageBtn;
    BOOL _isUp;
    int timeCount;
    id target;
    SEL registerSuccessAction;
}
@synthesize navTitle = _navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
     [appDelegate.tabController hideOrNotCustomTabBar:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUI];
}

#pragma mark - LoadUI

- (void)loadUI
{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"login_bg.png"];
    [self.view addSubview:bgImageView];
    
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
    userTextFiled.tag = Registe_User_Tag;
    userTextFiled.delegate = self;
    if (iOS7) {
        userTextFiled.tintColor = UIColorFromRGB(0x272832);
    }
    userTextFiled.keyboardType = UIKeyboardTypePhonePad;
    userTextFiled.backgroundColor = [UIColor clearColor];
    userTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    UIColor *palceColor = UIColorFromRGB(0x404040);
    userTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName: palceColor}];
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
    passWordTextFiled.tag = Register_PassWord_Tag;
    passWordTextFiled.delegate = self;
    if (iOS7) {
        passWordTextFiled.tintColor = UIColorFromRGB(0x272832);
    }
    passWordTextFiled.returnKeyType = UIReturnKeyNext;
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
    
    UIImage *confirmImage = [UIImage imageNamed:@"loginpage_repeatpasswordicon.png"];
    UIImageView *confirmImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(passWordLine.frame), confirmImage.size.width + 20, 42)];
    confirmImageView.contentMode = UIViewContentModeLeft;
    confirmImageView.image = confirmImage;
    [self.view addSubview:confirmImageView];
    UITextField *confirmTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(confirmImageView.frame), CGRectGetMaxY(passWordLine.frame), App_Frame_Width - 10 - CGRectGetMaxX(confirmImageView.frame), 42)];
    confirmTextFiled.tag = Register_Confirme_PassWord_Tag;
    confirmTextFiled.delegate = self;
    if (iOS7) {
        confirmTextFiled.tintColor = UIColorFromRGB(0x272832);
    }
    confirmTextFiled.returnKeyType = UIReturnKeyNext;
    confirmTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    confirmTextFiled.secureTextEntry = YES;
    confirmTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"再次输入密码" attributes:@{NSForegroundColorAttributeName: palceColor}];
    confirmTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    confirmTextFiled.textColor =  UIColorFromRGB(0xffffff);
    confirmTextFiled.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:confirmTextFiled];
    UILabel *confirmLine = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(confirmTextFiled.frame), App_Frame_Width - 30, 0.5)];
    confirmLine.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:confirmLine];
    
    UITextField *vertifyTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(confirmImageView.frame) + 10, CGRectGetMaxY(confirmLine.frame) + 15, App_Frame_Width - 10 - CGRectGetMinX(confirmImageView.frame) - 160, 42)];
    vertifyTextFiled.tag = Register_Vertify_Tag;
    vertifyTextFiled.delegate = self;
    if (iOS7) {
        vertifyTextFiled.tintColor = UIColorFromRGB(0x272832);
    }
    vertifyTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    vertifyTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"输入验证码" attributes:@{NSForegroundColorAttributeName: palceColor}];
    vertifyTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    vertifyTextFiled.textColor =  UIColorFromRGB(0xffffff);
    vertifyTextFiled.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:vertifyTextFiled];
    UILabel *vertifyLine = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(vertifyTextFiled.frame), App_Frame_Width - 30 - 160, 0.5)];
    vertifyLine.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:vertifyLine];

    UIButton *vertifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    vertifyButton.frame = CGRectMake(CGRectGetMaxX(vertifyLine.frame) + 25, CGRectGetMaxY(confirmLine.frame) + 15, 270/2, 45);
    vertifyButton.clipsToBounds = YES;
    vertifyButton.tag = Registe_VertifyButton_Tag;
    vertifyButton.layer.cornerRadius = 2.5f;
    vertifyButton.layer.borderColor = [UIColorFromRGB(0xffffff) CGColor];
    vertifyButton.layer.borderWidth = 0.5;
    vertifyButton.backgroundColor = [UIColor clearColor];
    vertifyButton.titleLabel.textColor = UIColorFromRGB(0xffffff);
    [vertifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [vertifyButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [vertifyButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vertifyButton];
    messageBtn = vertifyButton;
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(15, CGRectGetMaxY(vertifyLine.frame) + 25, App_Frame_Width - 30, 45);
    registerButton.tag = Registe_Button_Tag;
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setBackgroundColor:UIColorFromRGB(0x272832)];
    registerButton.clipsToBounds = YES;
    registerButton.layer.cornerRadius = 2.5;
    [registerButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    //提示验证码成功时，验证码发送的地方
    MMIVerSucessView *verView=[[MMIVerSucessView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(registerButton.frame), App_Frame_Width, 40)];
    verView.hidden=YES;
    verView.vertifyLabel.text=@"验证码已成功发送至手机";
    verView.tag = Vertify_Success_Tag;
    [self.view addSubview:verView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = Registe_BackButton_Tag;
    backButton.frame = CGRectMake(0, App_Frame_Height - 30 - 3, 60, 30);
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    backButton.titleLabel.textAlignment = MMIATextAlignmentLeft;
    [backButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

#pragma mark - Public

- (void)setTarget:(id)tar withRegisterAction:(SEL)action
{
    target = tar;
    registerSuccessAction = action;
}


#pragma mark - controlEvent
/*
 @param   button
 @descripation  按钮点击事件
 */
- (void)btnClick:(UIButton *)btn
{
    [self allTextFiledResign];
    if (btn.tag == Registe_BackButton_Tag)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag==Registe_VertifyButton_Tag) {
        UITextField *userTextFiled = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
        if (userTextFiled.text.length == 0) {
            [self show_check_phone_info:@"手机号不能为空" image:nil];
            return ;
        }
        if ([MMIJudgeTypeUtil isPhoneNumber:userTextFiled.text] == NO ){
            [self show_check_phone_info:@"请输入正确的手机号" image:nil];
            return ;
        }
        [btn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        [btn.titleLabel setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self sendRequest];
    }
    if (btn.tag == Registe_Button_Tag) {
        if ([self isGetVeryCode] && [self isVertifyCorrect]) {
            MMIProcessView *processView=[[MMIProcessView alloc]initWithMessage:@"正在验证信息..." top:App_Frame_Height];
            processView.tag=REGIST_IN_TAG;
            [processView showInRootView:self.view];
            [self sendRegistRequest];
        }
    }
}

- (void)changeButtonTitle
{
    messageBtn.enabled = NO;
    timeCount=60;
    [messageBtn setTitle:@"重新发送(60)" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction:) userInfo:nil repeats:YES];
    UITextField *mail = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
    mail.enabled=NO;
}

- (void)timerFunction:(NSTimer *)timer{
    messageBtn.enabled = NO;
    timeCount--;
    if (timeCount == 0) {
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
        }
        [messageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [messageBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)",60] forState:UIControlStateDisabled];
        [messageBtn setBackgroundColor:[UIColor clearColor]];
        [messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        messageBtn.enabled = YES;
        
        UITextField *userTextFiled = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
        UITextField *passWordTextFiled = (UITextField *)[self.view viewWithTag:Register_PassWord_Tag];
        UITextField *confirmTextFiled = (UITextField *)[self.view viewWithTag:Register_Confirme_PassWord_Tag];
        userTextFiled.enabled=YES;
        passWordTextFiled.enabled=YES;
        confirmTextFiled.enabled=YES;
        
    } else {
        [messageBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)",timeCount] forState:UIControlStateDisabled];
    }
}


//是否可以验证
-(BOOL)isGetVeryCode
{
    UITextField *userTextFiled = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
    UITextField *passWordTextFiled = (UITextField *)[self.view viewWithTag:Register_PassWord_Tag];
    UITextField *confirmTextFiled = (UITextField *)[self.view viewWithTag: Register_Confirme_PassWord_Tag];
    
    if (userTextFiled.text.length == 0) {
        [self show_check_phone_info:@"手机号不能为空" image:nil];
        return NO;
    }
    if ([MMIJudgeTypeUtil isPhoneNumber:userTextFiled.text] == NO ){
         [self show_check_phone_info:@"请输入正确的手机号" image:nil];
        return NO;
    }
   
    if (passWordTextFiled.text.length == 0) {
        [self show_check_phone_info:@"密码不能为空" image:nil];
        return NO;
    }
    if (passWordTextFiled.text.length < 6 || passWordTextFiled.text.length > 20) {
        [self show_check_phone_info:@"密码为6-20个字母、数字" image:nil];
        return NO;
    }
    if (confirmTextFiled.text.length == 0) {
        [self show_check_phone_info:@"确认密码不能为空" image:nil];
        return NO;
    }
    if ([passWordTextFiled.text isEqualToString:confirmTextFiled.text] == NO) {
        [self show_check_phone_info:@"两次密码输入不一致" image:nil];
        return NO;
    }
    
     return YES;
}
//判断验证码
-(BOOL)isVertifyCorrect
{
    UITextField *vertifyTextFiled = (UITextField *)[self.view viewWithTag:Register_Vertify_Tag];
    if (vertifyTextFiled.text.length==0)
    {
        [self show_check_phone_info:@"验证码为空" image:nil];
        return NO;
    }
    return YES;
}

#pragma mark -textFiledResign

-(void)allTextFiledResign
{
    UITextField *userName = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
    UITextField *password = (UITextField *)[self.view viewWithTag:Register_PassWord_Tag];
    UITextField *confirmTextField = ((UITextField *)[self.view viewWithTag: Register_Confirme_PassWord_Tag]);
    UITextField *vertifyTextFiled=(UITextField *)[self.view viewWithTag:Register_Vertify_Tag];
    [userName resignFirstResponder];
    [password resignFirstResponder];
    [confirmTextField resignFirstResponder];
    [vertifyTextFiled resignFirstResponder];
    if (_isUp)
    {
        [self restoreLocation];
    }
}
-(void)restoreLocation
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _isUp=NO;
    }];
}

#pragma marks-alertView

- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img
{
    [MMIToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];

}

#pragma mark-endRequestAndResult
//获得验证码
-(void)sendRequest
{
    [self changeButtonTitle];
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UITextField *userTextField = ((UITextField *)[self.view viewWithTag:Registe_User_Tag]);
    
    NSString *url=[[NSString alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
   /*
    //只能手机注册
    if ([MMIJudgeTypeUtil isEmailNumber:userTextField.text])
    {
        url=MMia_REGISTER_MAIL_VERITY_URL;
       [dict setObject:userTextField.text forKey:@"email"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"validateType"];
    }
    else
    {
        url=MMia_REGISTER_PHONE_VERITY_URL;
        [dict setObject:userTextField.text forKey:@"phone"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"validateType"];
    }
    */
    url=MMia_REGISTER_PHONE_VERITY_URL;
    [dict setObject:userTextField.text forKey:@"phone"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"validateType"];
    MMIVerSucessView *sucView=(MMIVerSucessView *)[self.view viewWithTag:Vertify_Success_Tag];
    [app.mmiaDataEngine startAsyncRequestWithUrl:url param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        if ([jsonDict[@"result"]intValue]==0) {
            UITextField *mail = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
            sucView.hidden=NO;
            sucView.vertifyLabel.text=@"验证码已成功发送至手机";
//            if ([MMIJudgeTypeUtil isPhoneNumber:mail.text]) {
//                sucView.vertifyLabel.text=@"验证码已成功发送至手机";
//            }
//            if ([MMIJudgeTypeUtil isEmailNumber:mail.text]) {
//                sucView.vertifyLabel.text=@"验证码已成功发送至邮箱";
//            }
            sucView.vertifyToLabel.text=mail.text;
            
        }else
        {
             sucView.hidden=YES;
            [self show_check_phone_info:@"很遗憾，获取验证码失败" image:nil];
        }
        

    }errorHandler:^(NSError *error){
         sucView.hidden=YES;
        if (app.mmiaDataEngine.isReachable==NO)
        {
            [self show_check_phone_info:@"没有网络连接" image:nil];
        }else
        {
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
        }
    }];
}

//点击注册的操作,信息写入本地并验证是否注册成功
-(void)sendRegistRequest
{
    MMIProcessView *processView = (MMIProcessView *)[self.view viewWithTag:REGIST_IN_TAG];
     AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UITextField *userNameTextField = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
    UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:Register_PassWord_Tag];
    UITextField *vertifyTextFiled=(UITextField *)[self.view viewWithTag:Register_Vertify_Tag];
    
    NSString *registerTypeStr=[[NSString alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    registerTypeStr=@"phone";
//      if ([MMIJudgeTypeUtil isEmailNumber:userNameTextField.text])
//      {
//         registerTypeStr=@"email";
//        [dict setObject:nikeNameTextFiled.text forKey:@"nickName"];
//      }else{
//          registerTypeStr=@"phone";
//           [dict setObject:nikeNameTextFiled.text forKey:@"nickName"];
//      }
    [dict setObject:userNameTextField.text forKey:registerTypeStr];
    [dict setObject:[passwordTextField.text md5] forKey:@"password"];
    [dict setObject:vertifyTextFiled.text forKey:@"validateCode"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"userType"];
    
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_REGISTER_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
       
        if ([jsonDict[@"result"]intValue]==0)
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:jsonDict[@"id"] forKey:USER_ID];
            [defaults setObject:jsonDict[@"ticket"] forKey:USER_TICKET];
            [defaults setBool:YES forKey:USER_IS_LOGIN];
            [defaults synchronize];
            if( [target respondsToSelector:registerSuccessAction] )
            {
                [target performSelector:registerSuccessAction];
            }
        }else{
            [self show_check_phone_info:jsonDict[@"message"] image:nil];
        }
        [processView dismiss];
        
    }errorHandler:^(NSError *error){
        if (app.mmiaDataEngine.isReachable==NO) {
        [self show_check_phone_info:@"没有网络连接" image:nil];
        }else{
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
        }
        [processView dismiss];
        // o1jn o
        
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self allTextFiledResign];
    
}

#pragma mark-TextFiledDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if ((textField.tag == Register_Confirme_PassWord_Tag  || textField.tag == Register_Vertify_Tag)&& _isUp==NO )
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, -120, self.view.frame.size.width, self.view.frame.size.height)];
            _isUp=YES;
        }];
    }
    
    }
-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *confirmTextField = ((UITextField *)[self.view viewWithTag: Register_Confirme_PassWord_Tag]);
    UITextField *vertifyTextFiled=(UITextField *)[self.view viewWithTag:Register_Vertify_Tag];
    if (textField.tag == Register_PassWord_Tag)
    {
        [textField resignFirstResponder];
        [confirmTextField becomeFirstResponder];
        return NO;
    }else if (textField.tag == Register_Confirme_PassWord_Tag)
    {
        [textField resignFirstResponder];
        [vertifyTextFiled becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    [self restoreLocation];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    UITextField *inputVery = (UITextField *)[self.view viewWithTag:Register_Vertify_Tag];
    if (inputVery==textField) {
        if (inputVery.text.length>=6 && ![string isEqualToString:@""]) {
            return NO;
        }
    
    }
    return YES;
}


//#pragma mark-MMIEmailPromptDelegate
//-(void)sendSelectCellStr:(NSString *)str{
//    UITextField *mail = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
//       mail.text=str;
//    
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
