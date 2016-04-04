//
//  MMIAForgetPasswordViewController.m
//  MMIA
//
//  Created by Vivian's Office MAC on 14-5-30.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIAForgetPasswordViewController.h"
#import "MMiaCommonUtil.h"
#import "MMIProcessView.h"
#import "MMIJudgeTypeUtil.h"
#import "MMIVerSucessView.h"
#import "MMIALoginViewController.h"
//弹出框
#import "MMIToast.h"
//发送成功提示
#define Reset_BackButton_Tag              100
#define Reset_FininshButton_Tag           101
#define Reset_VertifyButton_Tag           102
//TextFiled tag值
#define Reset_UserTextFiled_Tag           200
#define Reset_PassWordTextFiled_Tag       201
#define Reset_ConfirmPassTextFiled_Tag    202
#define Reset_VertifyTextFiled_Tag        203
// view 提示
#define Vertify_Success_Tag               300
#define Reset_In_View_Tag                 301

@interface MMIAForgetPasswordViewController ()

@end

@implementation MMIAForgetPasswordViewController
{
    BOOL _isRegister;
    BOOL _isUp;
    UIButton *messageBtn;
    int timeCount;
    id target;
    SEL registerSuccessAction;
    
}

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
    _isRegister = YES;
    [self loadUI];
}

#pragma mark - Public

- (void)setTarget:(id)tar withRegisterAction:(SEL)action
{
    target = tar;
    registerSuccessAction = action;
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
    userTextFiled.tag = Reset_UserTextFiled_Tag;
    userTextFiled.delegate = self;
    if (iOS7)
    {
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
    passWordTextFiled.tag = Reset_PassWordTextFiled_Tag;
    passWordTextFiled.delegate = self;
    if (iOS7)
    {
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
    confirmTextFiled.tag = Reset_ConfirmPassTextFiled_Tag;
    confirmTextFiled.delegate = self;
    if (iOS7)
    {
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
    vertifyTextFiled.tag = Reset_VertifyTextFiled_Tag;
    vertifyTextFiled.delegate = self;
    if (iOS7)
    {
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
    vertifyButton.tag = Reset_VertifyButton_Tag;
    vertifyButton.clipsToBounds = YES;
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
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(15, CGRectGetMaxY(vertifyLine.frame) + 25, App_Frame_Width - 30, 45);
    finishButton.tag = Reset_FininshButton_Tag;
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    finishButton.backgroundColor = UIColorFromRGB(0xe43f50);
    finishButton.clipsToBounds = YES;
    finishButton.layer.cornerRadius = 2.5;
    [finishButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    
    //提示验证码成功时，验证码发送的地方
    MMIVerSucessView *verView=[[MMIVerSucessView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(finishButton.frame), App_Frame_Width, 40)];
    verView.hidden=YES;
    verView.vertifyLabel.text=@"验证码已成功发送至手机";
    verView.tag = Vertify_Success_Tag;
    [self.view addSubview:verView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = Reset_BackButton_Tag;
    backButton.frame = CGRectMake(0, App_Frame_Height - 30 - 3, 60, 30);
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    backButton.titleLabel.textAlignment = MMIATextAlignmentLeft;
    [backButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

#pragma mark - controlEvent
/*
 @param   button
 @descripation  按钮点击事件
 */
- (void)btnClick:(UIButton *)btn
{
    [self resignAllFiled];
    if (btn.tag == Reset_BackButton_Tag)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (btn.tag == Reset_VertifyButton_Tag)
    {
        UITextField *userTextFiled = (UITextField *)[self.view viewWithTag:Reset_UserTextFiled_Tag];
        if (userTextFiled.text.length == 0)
        {
            [self show_check_phone_info:@"手机号不能为空"];
            return ;
        }
        if ([MMIJudgeTypeUtil isPhoneNumber:userTextFiled.text] == NO)
        {
            [self show_check_phone_info:@"请输入正确的手机号"];
            return;
        }
        [btn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        [btn.titleLabel setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self sendVertifyRequest];
    }
    
    if (btn.tag == Reset_FininshButton_Tag)
    {
        if ([self isAbleToSendVertifyRequest] == YES && [self isVertifyCorrect] == YES)
        {
           
            if (_isRegister == YES)
            {
                MMIProcessView *processView = [[MMIProcessView alloc]initWithMessage:@"修改密码中..." top:App_Frame_Height];
                processView.tag = Reset_In_View_Tag;
                [processView showInRootView:self.view];
                [self sendPassWordRequest];
            }else
            {
                MMIProcessView *processView = [[MMIProcessView alloc]initWithMessage:@"正在验证信息..." top:App_Frame_Height];
                processView.tag = Reset_In_View_Tag;
                [processView showInRootView:self.view];
                [self sendRegistRequest];
            }
            
        }
    }
}

- (void)changeButtonTitle{
    messageBtn.enabled = NO;
    timeCount=60;
    [messageBtn setTitle:@"重新发送(60)" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction:) userInfo:nil repeats:YES];
    UITextField *userTextFiled = (UITextField *)[self.view viewWithTag:Reset_UserTextFiled_Tag];
    userTextFiled.enabled=NO;
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
        // messageBtn.backgroundColor=[UIColor lightGrayColor];
        [messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        messageBtn.enabled = YES;
        UITextField *userTextFiled = (UITextField *)[self.view viewWithTag:Reset_UserTextFiled_Tag];
        userTextFiled.enabled = YES;
    } else {
        [messageBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)",timeCount] forState:UIControlStateDisabled];
    }
}


#pragma mark -isAbleToComplete And sendRequest
- (BOOL)isAbleToSendVertifyRequest
{
    UITextField *newPassword = (UITextField *)[self.view viewWithTag:Reset_PassWordTextFiled_Tag];
    UITextField *ensurepassWord = (UITextField *)[self.view viewWithTag:Reset_ConfirmPassTextFiled_Tag];
    if (newPassword.text.length==0) {
        [self show_check_phone_info:@"密码不能为空"];
        return NO;
    }
    if (newPassword.text.length<6 || newPassword.text.length>20) {
        [self show_check_phone_info:@"密码为6-20个字母、数字"];
        return NO;
    }
    if (ensurepassWord.text.length==0) {
        [self show_check_phone_info:@"确认密码不能为空"];
        return NO;
    }
    
    if ([newPassword.text isEqualToString:ensurepassWord.text]==NO) {
        [self show_check_phone_info:@"密码和确认密码不一样"];
        return NO;
    }
    return YES;
}
//判断验证码
- (BOOL)isVertifyCorrect
{
    UITextField *vertifyTextFiled=(UITextField *)[self.view viewWithTag:Reset_VertifyTextFiled_Tag];
    if (vertifyTextFiled.text.length == 0) {
        [self show_check_phone_info:@"验证码为空"];
        return NO;
    }
    return YES;
}

#pragma mark-replaceAlertView
- (void) show_check_phone_info:(NSString *)_str
{
    [MMIToast showWithText:_str topOffset:Main_Screen_Height-20 image:nil];
    
}
#pragma mark-sendRequest
/* 获取验证码 */
- (void)sendVertifyRequest{
    [self changeButtonTitle];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UITextField *userTextFiled = (UITextField *)[self.view viewWithTag:Reset_UserTextFiled_Tag];
    NSString *url = [[NSString alloc]init];
    NSString *userTypeStr = [[NSString alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    url = MMia_REGISTER_PHONE_VERITY_URL;
    userTypeStr = @"phone";
//    if ([MMIJudgeTypeUtil isEmailNumber:userTextFiled.text])
//    {
//        url = MMia_REGISTER_MAIL_VERITY_URL;
//        userTypeStr = @"email";
//        //无输入昵称的项，参数却有
//        //[dict setObject:@"fault" forKey:@"nickName"];
//    }else{
//        url = MMia_REGISTER_PHONE_VERITY_URL;
//        userTypeStr = @"phone";
//    }
    [dict setObject:userTextFiled.text forKey:userTypeStr];
    if (_isRegister)
    {
         [dict setObject:[NSNumber numberWithInt:1] forKey:@"validateType"];
    }else
    {
         [dict setObject:[NSNumber numberWithInt:0] forKey:@"validateType"];
    }
    MMIVerSucessView *sucView=(MMIVerSucessView *)[self.view viewWithTag:Vertify_Success_Tag];
    [app.mmiaDataEngine startAsyncRequestWithUrl:url param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]intValue] == 0) {
            sucView.hidden=NO;
             sucView.vertifyLabel.text = @"验证码已成功发送至手机";
//            if ([MMIJudgeTypeUtil isPhoneNumber:userTextFiled.text]) {
//                sucView.vertifyLabel.text = @"验证码已成功发送至手机";
//            }
//            if ([MMIJudgeTypeUtil isEmailNumber:userTextFiled.text]) {
//                sucView.vertifyLabel.text = @"验证码已成功发送至邮箱";
//            }
            sucView.vertifyToLabel.text = userTextFiled.text;
        }else if ([jsonDict[@"result"]intValue] == 3)
        {
            sucView.hidden=YES;
            [self show_check_phone_info:@"该用户没有注册"];
            _isRegister = NO;
            UIButton *resigsterButton = (UIButton *)[self.view viewWithTag:Reset_FininshButton_Tag];
            [resigsterButton setTitle:@"注册" forState:UIControlStateNormal];
            [resigsterButton setBackgroundColor:UIColorFromRGB(0x272832)];
        }
        else
        {
            sucView.hidden=YES;
            [self show_check_phone_info:@"很遗憾，获取验证码失败"];
        }
        
    }errorHandler:^(NSError *error){
        if (app.mmiaDataEngine.isReachable==NO)
        {
            [self show_check_phone_info:@"没有网络连接"];
        }else
        {
            [self show_check_phone_info:@"网络不给力，请稍后重试"];
            
        }
        sucView.hidden=YES;
    }];
    
}

- (void)sendPassWordRequest
{
    //完成按钮
    MMIProcessView *processView = (MMIProcessView *)[self.view viewWithTag:Reset_In_View_Tag];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UITextField *userTextFiled = (UITextField *)[self.view viewWithTag:Reset_UserTextFiled_Tag];
    UITextField *passWordTextFiled = (UITextField *)[self.view viewWithTag:Reset_PassWordTextFiled_Tag];
    UITextField *vertifyTextFiled = (UITextField *)[self.view viewWithTag:Reset_VertifyTextFiled_Tag];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:userTextFiled.text,@"loginName",[passWordTextFiled.text md5],@"new_password",vertifyTextFiled.text,@"validateCode", nil];
    
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_FORGET_PASSWORD_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]intValue]==0) {
            
            for (UIViewController *vc in self.navigationController.viewControllers)
            {
                if ([vc isKindOfClass:[MMIALoginViewController class]]){
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
        }else{
    
            [self show_check_phone_info:jsonDict[@"message"]];
        }
        [processView dismiss];
        
    }errorHandler:^(NSError *error){
         [processView dismiss];
        if (app.mmiaDataEngine.isReachable==NO) {
            [self show_check_phone_info:@"没有网络连接"];
        }else{
            [self show_check_phone_info:@"网络不给力，请稍后重试"];
        }
        
    }];
   
}

//点击注册的操作,信息写入本地并验证是否注册成功
-(void)sendRegistRequest
{
    MMIProcessView *processView = (MMIProcessView *)[self.view viewWithTag:Reset_In_View_Tag];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UITextField *userNameTextField = (UITextField *)[self.view viewWithTag:Reset_UserTextFiled_Tag];
    UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:Reset_PassWordTextFiled_Tag];
    UITextField *vertifyTextFiled=(UITextField *)[self.view viewWithTag:Reset_VertifyTextFiled_Tag];
    
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
            _isRegister = YES;
        }
        else{
            [self show_check_phone_info:jsonDict[@"message"]];
        }
        [processView dismiss];
        
    }errorHandler:^(NSError *error){
        if (app.mmiaDataEngine.isReachable==NO) {
            [self show_check_phone_info:@"没有网络连接"];
        }else{
            [self show_check_phone_info:@"网络不给力，请稍后重试"];
        }
        [processView dismiss];
        // o1jn o
        
    }];
}

#pragma mark - resign

- (void)resignAllFiled{
    UITextField *userName = (UITextField *)[self.view viewWithTag:Reset_UserTextFiled_Tag];
    UITextField *password = (UITextField *)[self.view viewWithTag:Reset_PassWordTextFiled_Tag];
    UITextField *confirmTextField = ((UITextField *)[self.view viewWithTag: Reset_ConfirmPassTextFiled_Tag]);
    UITextField *vertifyTextFiled=(UITextField *)[self.view viewWithTag:Reset_VertifyTextFiled_Tag];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self resignAllFiled];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if ((textField.tag == Reset_ConfirmPassTextFiled_Tag  || textField.tag == Reset_VertifyTextFiled_Tag)&& _isUp==NO )
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
    UITextField *confirmTextField = ((UITextField *)[self.view viewWithTag: Reset_ConfirmPassTextFiled_Tag]);
    UITextField *vertifyTextFiled=(UITextField *)[self.view viewWithTag:Reset_VertifyTextFiled_Tag];
    if (textField.tag == Reset_PassWordTextFiled_Tag)
    {
        [textField resignFirstResponder];
        [confirmTextField becomeFirstResponder];
        return NO;
    }else if (textField.tag == Reset_ConfirmPassTextFiled_Tag)
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
    
    UITextField *inputVery = (UITextField *)[self.view viewWithTag:Reset_VertifyTextFiled_Tag];
    if (inputVery==textField)
    {
        if (inputVery.text.length>=6 && ![string isEqualToString:@""])
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
