//
//  MmiaLoginViewController.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-11.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaLoginViewController.h"
#import "AdditionHeader.h"
#import "MmiaLoginMacro.h"
#import "MMIARegistViewController.h"
#import "MmiaForgetViewController.h"
#import "MmiaProcessView.h"
#import "MmiaToast.h"
#import <TencentOpenAPI/QQApi.h>

#import "NSString+MKNetworkKitAdditions.h"

#define REGISTER_TAG         101
#define LOGIN_TAG            102
#define FORGET_PASSWORD_TAG  103
#define CLOSE_BTN_TAG        100
#define USER_NAME_TEXT_TAG   200
#define PASS_WORD_TEXT_TAG   201
#define RELATED_LOGIN_TAG    300
#define PROCESS_VIEW_TAG     400

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
@interface MmiaLoginViewController ()

{
    
    id _target;
    SEL logonSuccessAction;
    SEL registerSuccessAction;
    BOOL isPortrait;
//    BOOL _isUp;
}


@end

@implementation MmiaLoginViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 获取标准的self.view.frame
    if( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
    {
        isPortrait = YES;
    }else
        isPortrait = NO;
    

    self.view.frame = self.loginView.bounds;
    if (!iOS8Later) {
        self.loginView.center = self.view.center;
    }


}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHidden)
//                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:Mmia_QQLogin_APPID andDelegate:self];
    _permissions =  [NSMutableArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    

    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    [self creatLogin];
    
}

-(void)creatLogin
{
    self.loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Vertical_Login_View_Weight, Vertical_Login_View_Height)];

    [self.view addSubview:self.loginView];
    
    self.loginView.tag = TAG_ALL_VIEW;
    //背景
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.loginView.bounds];
    bgImageView.image = [UIImage imageNamed:@"login_bg.png"];
    [self.loginView addSubview:bgImageView];
    //黑上框
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Vertical_Login_View_Weight, Vertical_Login_TopView_Height)];
    topView.backgroundColor = ColorWithHexRGB(0x272832);
    [bgImageView addSubview:topView];
    bgImageView.userInteractionEnabled = YES;
    //取消按钮
    UIButton *CancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CancelBtn.frame = CGRectMake(Vertical_Login_Btn_LeftGap, Vertical_Login_Btn_TopGap, 32, 32);
    [CancelBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    CancelBtn.titleLabel.font = [UIFont systemFontOfSize:Login_FrontSize];
    CancelBtn.backgroundColor = [UIColor clearColor];
    CancelBtn.tag = CLOSE_BTN_TAG;
    [topView addSubview:CancelBtn];
    
    //主标题
    UILabel *title = [[UILabel alloc]init];
    title.text = @"登录";
    title.frame = CGRectMake(0, 0, 80, Vertical_Login_TopView_Height);
    title.center = CGPointMake(Vertical_Login_View_Weight/2, Vertical_Login_TopView_Height/2);
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:Login_TitleFrontSize];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    [topView addSubview:title];
    
    //logo
    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginpage_icon.png"]];
    logoImageView.frame = CGRectMake((Vertical_Login_View_Weight-logoImageView.frame.size.width)/2, Vertical_Login_TopView_Height+Vertical_Login_TopGap, logoImageView.frame.size.width, logoImageView.frame.size.height);
    [bgImageView addSubview:logoImageView];
    
    
    //用户名和密码
    UIImage *userImage = [UIImage imageNamed:@"loginpage_usernameicon.png"];
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Vertical_Login_View_Weight-Vertical_Login_Logo_Weight)/2+Vertical_Login_LeftGap, Vertical_Login_TopView_Height+Vertical_Login_TopGap+logoImageView.frame.size.height+Vertical_Login_BottomGap, userImage.size.width, userImage.size.height)];
    userImageView.contentMode = UIViewContentModeLeft;
    userImageView.image = userImage;
    [self.loginView addSubview:userImageView];
    
    
    UITextField *userTextFiled = [[UITextField alloc]initWithFrame:CGRectMake((Vertical_Login_View_Weight-Vertical_Login_Logo_Weight)/2+userImageView.frame.size.width+Vertical_Login_LeftGap*2, Vertical_Login_TopView_Height+Vertical_Login_TopGap+logoImageView.frame.size.height+Vertical_Login_BottomGap, Vertical_Login_Logo_Weight-Vertical_Login_LeftGap*2-userImageView.frame.size.width, Vertical_Login_Account_Height)];
    userTextFiled.backgroundColor = [UIColor orangeColor];
    userTextFiled.tag = USER_NAME_TEXT_TAG;
    userTextFiled.delegate = self;
    
    userTextFiled.returnKeyType = UIReturnKeyNext;
    userTextFiled.backgroundColor = [UIColor clearColor];
    userTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    UIColor *palceColor = [UIColor whiteColor];
    userTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"User Name" attributes:@{NSForegroundColorAttributeName: palceColor}];
    userTextFiled.textAlignment = NSTextAlignmentCenter;
    userTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userTextFiled.textColor =  ColorWithHexRGB(0xffffff);
    userTextFiled.font = [UIFont systemFontOfSize:12];
    [self.loginView addSubview:userTextFiled];
    
    UILabel *userLine = [[UILabel alloc]initWithFrame:CGRectMake((Vertical_Login_View_Weight-Vertical_Login_Logo_Weight)/2, CGRectGetMaxY(userTextFiled.frame), Vertical_Login_Logo_Weight, 0.5)];
    userLine.backgroundColor = ColorWithHexRGB(0xffffff);
    [self.loginView addSubview:userLine];
    
    
    //密码
    UIImage *passWordImage = [UIImage imageNamed:@"loginpage_passwordicon.png"];
    UIImageView *passWordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(userImageView.frame), CGRectGetMidY(userImageView.frame)+Vertical_Login_Account_Height, passWordImage.size.width, passWordImage.size.height)];
    passWordImageView.contentMode = UIViewContentModeLeft;
    passWordImageView.image = passWordImage;
    [self.loginView addSubview:passWordImageView];
    UITextField *passWordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake((Vertical_Login_View_Weight-Vertical_Login_Logo_Weight)/2+userImageView.frame.size.width+Vertical_Login_LeftGap*2, Vertical_Login_TopView_Height+Vertical_Login_TopGap+logoImageView.frame.size.height+Vertical_Login_BottomGap+Vertical_Login_Account_Height, Vertical_Login_Logo_Weight-Vertical_Login_LeftGap*2-userImageView.frame.size.width, Vertical_Login_Account_Height)];
    passWordTextFiled.tag = PASS_WORD_TEXT_TAG;
    passWordTextFiled.delegate = self;
    
    passWordTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    passWordTextFiled.secureTextEntry = YES;
    passWordTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: palceColor}];
    passWordTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passWordTextFiled.textColor =  ColorWithHexRGB(0xffffff);
    passWordTextFiled.textAlignment = NSTextAlignmentCenter;
    passWordTextFiled.font = [UIFont systemFontOfSize:12];
    [self.loginView addSubview:passWordTextFiled];
    
    UILabel *passWordLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(userLine.frame), CGRectGetMaxY(userLine.frame)+44, Vertical_Login_Account_Weight, 0.5)];
    passWordLine.backgroundColor = ColorWithHexRGB(0xffffff);
    [self.loginView addSubview:passWordLine];
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.tag = LOGIN_TAG;
    loginButton.frame = CGRectMake(CGRectGetMinX(userLine.frame), CGRectGetMaxY(userLine.frame)+Vertical_Login_Account_Height+Vertical_Login_Gap1, Vertical_Login_Account_Weight, Vertical_Login_Yanzhengma_Height);
    loginButton.backgroundColor = ColorWithHexRGB(0xe43f50);
    loginButton.layer.cornerRadius = 2.5;
    loginButton.clipsToBounds = YES;
    [loginButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setImage:[UIImage imageNamed:@"loginpage_loginbutton.png"] forState:UIControlStateNormal];
    [self.loginView addSubview:loginButton];
    
    //qq and sina
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqButton.frame = CGRectMake(CGRectGetMinX(userLine.frame), CGRectGetMaxY(userLine.frame)+Vertical_Login_Account_Height+Vertical_Login_Gap1+Vertical_Login_Gap2+loginButton.frame.size.height, Vertical_Login_Account_Weight, Vertical_Login_Yanzhengma_Height);
    qqButton.tag = RELATED_LOGIN_TAG;
    qqButton.clipsToBounds = YES;
    qqButton.layer.cornerRadius = 2.5;
    qqButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    qqButton.layer.borderColor = [ColorWithHexRGB(0xffffff)CGColor];
    qqButton.layer.borderWidth = 0.5;
    [qqButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [qqButton setImage:[UIImage imageNamed:@"loginpage_qqicon.png"] forState:UIControlStateNormal];
    [qqButton setImage:[UIImage imageNamed:@"loginpage_qqicon.png"] forState:UIControlStateHighlighted];
    [qqButton setTitle:@" QQ登录" forState:UIControlStateNormal];
    qqButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.loginView addSubview:qqButton];
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaButton.tag = RELATED_LOGIN_TAG+1;
    sinaButton.frame = CGRectMake(CGRectGetMinX(qqButton.frame), CGRectGetMaxY(qqButton.frame)+10, qqButton.frame.size.width, qqButton.frame.size.height);
    sinaButton.clipsToBounds = YES;
    sinaButton.layer.cornerRadius = 2.5;
    sinaButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    sinaButton.layer.borderColor = [ColorWithHexRGB(0xffffff)CGColor];
    sinaButton.layer.borderWidth = 0.5;
    [sinaButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [sinaButton setImage:[UIImage imageNamed:@"loginpage_sinaicon.png"] forState:UIControlStateNormal];
    [sinaButton setImage:[UIImage imageNamed:@"loginpage_sinaicon.png"] forState:UIControlStateHighlighted];
    [sinaButton setTitle:@" 微博登录" forState:UIControlStateNormal];
    sinaButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.loginView addSubview:sinaButton];
    
    //忘记密码 注册
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(Vertical_Login_Btn_LeftGap, Vertical_Login_View_Height - 30 - 20, 56, 30);
    forgetButton.tag = FORGET_PASSWORD_TAG;
    [forgetButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [forgetButton.titleLabel setTextAlignment:MMIATextAlignmentLeft];
    [forgetButton setBackgroundColor:[UIColor clearColor]];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:Login_FrontSize]];
    
    [self.loginView addSubview:forgetButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.tag = REGISTER_TAG;
    registerButton.frame = CGRectMake(Vertical_Login_View_Weight - 20-28, Vertical_Login_View_Height - 30 - 20, 28, 30);
    [registerButton setBackgroundColor:[UIColor clearColor]];
    [registerButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:Login_FrontSize]];
    registerButton.titleLabel.textAlignment = MMIATextAlignmentRight;
    [self.loginView addSubview:registerButton];
    
}

- (void)setTarget:(id)tar withSuccessAction:(SEL)action withRegisterAction:(SEL)action1
{
    _target = tar;
    logonSuccessAction = action;
    registerSuccessAction = action1;
}

-(void)click:(UIButton *)btn
{
//    [self resignAllResponder];
    if(btn.tag == CLOSE_BTN_TAG)
    {
        NSLog(@"取消");
//        UIView *loginBackView = (UIView *)[self.view viewWithTag:11];
//        UIView *loginView = (UIView *)[self.view viewWithTag:12];
//        [loginBackView removeFromSuperview];
//        [loginView removeFromSuperview];
//        self.navigationController.navigationBarHidden = NO;
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else if (btn.tag == FORGET_PASSWORD_TAG)
    {
        NSLog(@"忘记密码");
        MmiaForgetViewController *forgetView = [[MmiaForgetViewController alloc]init];
//        if (!iOS8Later)
        forgetView.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:forgetView animated:NO completion:nil];
    }
    else if (btn.tag == LOGIN_TAG)
    {
        NSLog(@"登录");
        [self login];
    }
    else if (btn.tag == REGISTER_TAG)
    {
        MMIARegistViewController *registVC = [[MMIARegistViewController alloc]init];
//        if (!iOS8Later)
        registVC.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:registVC animated:NO completion:nil];
        [registVC setTarget:_target withRegisterAction:registerSuccessAction];
        NSLog(@"注册");
    }
    else if (btn.tag == RELATED_LOGIN_TAG){
//        if ([QQApi isQQInstalled]) {
            [_tencentOAuth authorize:_permissions inSafari:NO];
//        }else{
//            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先下载QQ才能进行QQ登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [aler show];
//            [_tencentOAuth authorize:_permissions inSafari:NO];
//        }
    }
    else if (btn.tag == RELATED_LOGIN_TAG+1){
        [[NSNotificationCenter defaultCenter] addObserver:_target selector:logonSuccessAction name:@"logonSuccessAction" object:nil];
        if ([WeiboSDK isCanSSOInWeiboApp]) {
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = @"http://www.mmia.com";
            request.scope = @"all";
            [WeiboSDK sendRequest:request];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备好像没有安装新浪微博客户端，建议下载新浪微博客户端再进行三方登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
}

#pragma mark -login
- (void)login
{
    MmiaProcessView *processView=(MmiaProcessView *)[self.view viewWithTag:PROCESS_VIEW_TAG];
    [processView dismiss];
    if ([self canLogin])
    {
        MmiaProcessView *processView=[[MmiaProcessView alloc]initWithMessage:@"登录中..." top:Main_Screen_Height];
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
#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img
{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MmiaToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}

-(void)sendLoginRequest{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    MmiaProcessView *processView = (MmiaProcessView *)[self.view viewWithTag:PROCESS_VIEW_TAG];
    UITextField *userName = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
    UITextField *passWord = (UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG];
    NSDictionary *infoDict=[[NSDictionary alloc]initWithObjectsAndKeys:userName.text,@"loginName",[passWord.text md5],@"password", nil];
    
    [appDelegate.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_LOGIN_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
        [processView dismiss];
        // 登录成功
        if ([jsonObject[@"result"]intValue]==0)
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:jsonObject[@"id"] forKey:USER_ID];
            [defaults setObject:jsonObject[@"ticket"] forKey:USER_TICKET];
            [defaults setBool:YES forKey:USER_IS_LOGIN];
            [defaults setObject:jsonObject[@"userType"] forKey:@"userType"];
            
//            [defaults setValue:@1 forKey:@"loginStatus"];
            
            [defaults synchronize];
            if( [_target respondsToSelector:logonSuccessAction] )
            {
                [_target performSelector:logonSuccessAction];
            }
//            [self dismissViewControllerAnimated:NO completion:nil];
        }
        else
        {
            NSLog(@"%d",[jsonObject[@"result"]intValue]);
            [self show_check_phone_info:jsonObject[@"message"] image:nil];
        }
        
    }errorHandler:^(NSError* error){
        [processView dismiss];
        
        if ([appDelegate.mmiaNetworkEngine isReachable]==NO)
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

//- (void)resignAllResponder
//{
//    UITextField *nameTextField = ((UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG]);
//    UITextField *passTextField = ((UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG]);
//    [nameTextField resignFirstResponder];
//    [passTextField resignFirstResponder];
////    if (_isUp)
////    {
////        [self restoreLocation];
////    }
//}

//-(void)restoreLocation
//{
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        _isUp=NO;
//    }];
//}


//-(void)keyboardWillHidden{
//    if ( _isUp==YES )
//    {
//        [UIView animateWithDuration:0.2 animations:^{
//            [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
//            _isUp=NO;
//        }];
//    }
//    
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (iOS8Later) {
//        [self resignAllResponder];
//    }
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if ( _isUp==NO )
//    {
//        [UIView animateWithDuration:0.2 animations:^{
//            [self.view setFrame:CGRectMake(self.view.frame.origin.x, -120, self.view.frame.size.width, self.view.frame.size.height)];
//            _isUp=YES;
//        }];
//    }
    if (textField.tag == PASS_WORD_TEXT_TAG) {
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    
}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (_isUp) {
//        [self restoreLocation];
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *passWordTextFiled=(UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG];
    if (textField.tag == USER_NAME_TEXT_TAG)
    {
        [textField resignFirstResponder];
        [passWordTextFiled becomeFirstResponder];
        return NO;
    }
    else{
//    [textField resignFirstResponder];
//        [self resignAllResponder];
    return YES;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


#pragma mark - UIViewControllerRotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.presentingViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    UIView *view = [self.view viewWithTag:TAG_ALL_VIEW];
    
    if( !UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        // 竖屏
        isPortrait = YES;
        self.loginView.center = CGPointMake(Mmia_Portrait_Height/2,Mmia_Portrait_Weight/2);
    }
    else
    {
        // 横屏
        isPortrait = NO;
        self.loginView.center = CGPointMake(Mmia_Portrait_Weight/2,Mmia_Portrait_Height/2);

    }
//    if (!iOS8Later) {
        self.loginView.center = self.view.center;
//    }
    [self.loginView reloadInputViews];

}

#pragma mark -QQ互联登录完成
//QQ互联登录
-(void)tencentDidLogin{
    NSLog(@"QQ互联登录完成");
    [self sendQQLoginRequest];
}

-(void)sendQQLoginRequest{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    MmiaProcessView *processView = (MmiaProcessView *)[self.view viewWithTag:PROCESS_VIEW_TAG];
    NSString *qqAccessToken = [NSString stringWithFormat:@"%@",_tencentOAuth.accessToken];
    NSDate *qqExpireinDate = _tencentOAuth.expirationDate;
    NSTimeInterval qqExpirein = [qqExpireinDate timeIntervalSinceNow];
    NSString *qqExpireinStr = [NSString stringWithFormat:@"%f",qqExpirein];
    NSDictionary *infoDict=[[NSDictionary alloc]initWithObjectsAndKeys:qqAccessToken,@"accessToken",qqExpireinStr,@"expirein", nil];
    
    [appDelegate.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_QQLogin_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
        [processView dismiss];
        // 登录成功
        if ([jsonObject[@"result"]intValue]==0)
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:jsonObject[@"id"] forKey:USER_ID];
            [defaults setObject:jsonObject[@"ticket"] forKey:USER_TICKET];
            [defaults setBool:YES forKey:USER_IS_LOGIN];
            [defaults setObject:jsonObject[@"userType"] forKey:@"userType"];
            
            [defaults synchronize];
            if( [_target respondsToSelector:logonSuccessAction] )
            {
                [_target performSelector:logonSuccessAction];
            }
        }
    }errorHandler:^(NSError *error) {
    }];
     
}
     
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled){
        NSLog(@"用户取消登录");
    }
    else {
        NSLog(@"登录失败");
    }
}
-(void)tencentDidNotNetWork
{
    NSLog(@"无网络连接，请设置网络");
}
-(void)tencentDidLogout
{
    NSLog(@"退出登录成功，请重新登录");
}

#pragma mark -sina登录
/*新浪登录成功回调函数方法写在appDelegate里面*/

//欲知方法怎么实现的请去appDelegate寻找！！！

////sina登录回调函数，登录成功实现的方法
//
//-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
//
//}
//
//-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
//
//}

#pragma mark - UIAlertViewDelegate Methods

#pragma mark - WBLogInAlertViewDelegate Methods


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:_target name:@"logonSuccessAction" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
