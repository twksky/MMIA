//
//  MMIARegistViewController.m
//  MmiaHD
//
//  Created by twksky on 15/3/23.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MMIARegistViewController.h"
#import "AdditionHeader.h"
#import "MmiaLoginMacro.h"
#import "MmiaToast.h"
#import "MmiJudgeTypeUtil.h"
#import "AppDelegate.h"
#import "AdditionHeader.h"
#import "MmiaVerSucessView.h"
#import "MmiaProcessView.h"




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

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

static NSString *code_Mail=@"getValidateCodeForMail/";
static NSString *code_Phone=@"getValidateCodeForPhone/";
static NSString *regist_Code=@"register/";

@interface MMIARegistViewController ()<UITextFieldDelegate,MmiaEmailPromptDelegate,UIAlertViewDelegate>

@end

@implementation MMIARegistViewController

{
    UIButton *messageBtn;
    BOOL _isUp;
    int timeCount;
    id target;
    SEL registerSuccessAction;
    BOOL isPortrait;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 获取标准的self.view.frame
    if( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
    {
        isPortrait = YES;
        
    }
    
//    UIView *view = [self.view viewWithTag:TAG_ALL_VIEW];
//    if (isPortrait) {
//        view.center = CGPointMake(Mmia_Portrait_Weight/2,Mmia_Portrait_Height/2);
//    }else{
//        view.center = CGPointMake(Mmia_Portrait_Height/2,Mmia_Portrait_Weight/2);
//    }
    self.view.frame = self.view.bounds;
    if (!iOS8Later) {
        UIView *view = [self.view viewWithTag:TAG_ALL_VIEW];
        view.center = self.view.center;
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    //键盘收起的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHidden)
//                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    [self creatForget];
}

-(void)creatForget
{
    UIView *loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Vertical_Login_View_Weight, Vertical_Login_View_Height)];
    
    [self.view addSubview:loginView];
    
    //    loginBackView.tag = 11;
    loginView.tag = TAG_ALL_VIEW;
    //背景
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:loginView.bounds];
    bgImageView.image = [UIImage imageNamed:@"login_bg.png"];
    [loginView addSubview:bgImageView];
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
    CancelBtn.tag = Registe_BackButton_Tag;
    [topView addSubview:CancelBtn];
    
    //主标题
    UILabel *title = [[UILabel alloc]init];
    title.text = @"注册";
    title.frame = CGRectMake(0, 0, 80, Vertical_Login_TopView_Height);
    title.center = CGPointMake(Vertical_Login_View_Weight/2, Vertical_Login_TopView_Height/2);
    title.textAlignment = MMIATextAlignmentCenter;
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
    [loginView addSubview:userImageView];
    
    
    UITextField *userTextFiled = [[UITextField alloc]initWithFrame:CGRectMake((Vertical_Login_View_Weight-Vertical_Login_Logo_Weight)/2+userImageView.frame.size.width+Vertical_Login_LeftGap*2, Vertical_Login_TopView_Height+Vertical_Login_TopGap+logoImageView.frame.size.height+Vertical_Login_BottomGap, Vertical_Login_Logo_Weight-Vertical_Login_LeftGap*2-userImageView.frame.size.width, Vertical_Login_Account_Height)];
    userTextFiled.backgroundColor = [UIColor orangeColor];
    userTextFiled.tag = Registe_User_Tag;
    userTextFiled.delegate = self;
    
    userTextFiled.returnKeyType = UIReturnKeyNext;
    userTextFiled.backgroundColor = [UIColor clearColor];
    userTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    UIColor *palceColor = [UIColor whiteColor];
    userTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName: palceColor}];
    userTextFiled.textAlignment = NSTextAlignmentCenter;
    userTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userTextFiled.textColor =  ColorWithHexRGB(0xffffff);
    userTextFiled.font = [UIFont systemFontOfSize:12];
    [loginView addSubview:userTextFiled];
    
    UILabel *userLine = [[UILabel alloc]initWithFrame:CGRectMake((Vertical_Login_View_Weight-Vertical_Login_Logo_Weight)/2, CGRectGetMaxY(userTextFiled.frame), Vertical_Login_Logo_Weight, 0.5)];
    userLine.backgroundColor = ColorWithHexRGB(0xffffff);
    [loginView addSubview:userLine];
    
    
    //密码
    UIImage *passWordImage = [UIImage imageNamed:@"loginpage_passwordicon.png"];
    UIImageView *passWordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(userImageView.frame), CGRectGetMidY(userImageView.frame)+Vertical_Login_Account_Height, passWordImage.size.width, passWordImage.size.height)];
    passWordImageView.contentMode = UIViewContentModeLeft;
    passWordImageView.image = passWordImage;
    [loginView addSubview:passWordImageView];
    UITextField *passWordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake((Vertical_Login_View_Weight-Vertical_Login_Logo_Weight)/2+userImageView.frame.size.width+Vertical_Login_LeftGap*2, Vertical_Login_TopView_Height+Vertical_Login_TopGap+logoImageView.frame.size.height+Vertical_Login_BottomGap+Vertical_Login_Account_Height, Vertical_Login_Logo_Weight-Vertical_Login_LeftGap*2-userImageView.frame.size.width, Vertical_Login_Account_Height)];
    passWordTextFiled.tag = Register_PassWord_Tag;
    passWordTextFiled.delegate = self;
    
    passWordTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    passWordTextFiled.secureTextEntry = YES;
    passWordTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"新密码" attributes:@{NSForegroundColorAttributeName: palceColor}];
    passWordTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passWordTextFiled.textColor =  ColorWithHexRGB(0xffffff);
    passWordTextFiled.textAlignment = NSTextAlignmentCenter;
    passWordTextFiled.font = [UIFont systemFontOfSize:12];
    [loginView addSubview:passWordTextFiled];
    
    UILabel *passWordLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(userLine.frame), CGRectGetMaxY(userLine.frame)+44, Vertical_Login_Account_Weight, 0.5)];
    passWordLine.backgroundColor = ColorWithHexRGB(0xffffff);
    [loginView addSubview:passWordLine];
    
    
    //
    //再输入密码
    UIImage *repeatPasswordImage = [UIImage imageNamed:@"loginpage_repeatpasswordicon.png"];
    UIImageView *repeatPasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(userImageView.frame), CGRectGetMidY(userImageView.frame)+Vertical_Login_Account_Height+Vertical_Login_Account_Height, passWordImage.size.width, passWordImage.size.height)];
    repeatPasswordImageView.contentMode = UIViewContentModeLeft;
    repeatPasswordImageView.image = repeatPasswordImage;
    [loginView addSubview:repeatPasswordImageView];
    
    UITextField *repeatPasswordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake((Vertical_Login_View_Weight-Vertical_Login_Logo_Weight)/2+userImageView.frame.size.width+Vertical_Login_LeftGap*2, Vertical_Login_TopView_Height+Vertical_Login_TopGap+logoImageView.frame.size.height+Vertical_Login_BottomGap+Vertical_Login_Account_Height+Vertical_Login_Account_Height, Vertical_Login_Logo_Weight-Vertical_Login_LeftGap*2-userImageView.frame.size.width, Vertical_Login_Account_Height)];
    repeatPasswordTextFiled.tag = Register_Confirme_PassWord_Tag;
    repeatPasswordTextFiled.delegate = self;
    
    repeatPasswordTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    repeatPasswordTextFiled.secureTextEntry = YES;
    repeatPasswordTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"再次输入新密码" attributes:@{NSForegroundColorAttributeName: palceColor}];
    repeatPasswordTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    repeatPasswordTextFiled.textColor =  ColorWithHexRGB(0xffffff);
    repeatPasswordTextFiled.textAlignment = NSTextAlignmentCenter;
    repeatPasswordTextFiled.font = [UIFont systemFontOfSize:12];
    [loginView addSubview:repeatPasswordTextFiled];
    
    UILabel *repeatPasswordLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(userLine.frame), CGRectGetMaxY(userLine.frame)+Vertical_Login_Account_Height*2, Vertical_Login_Account_Weight, 0.5)];
    repeatPasswordLine.backgroundColor = ColorWithHexRGB(0xffffff);
    [loginView addSubview:repeatPasswordLine];
    
    
    //输入验证码
    UITextField *phoneTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(repeatPasswordLine.frame), CGRectGetMaxY(repeatPasswordLine.frame)+20, repeatPasswordLine.frame.size.width-26-136, 46)];
    phoneTextFiled.tag = Register_Vertify_Tag;
    phoneTextFiled.delegate = self;
    
    phoneTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    phoneTextFiled.secureTextEntry = YES;
    phoneTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"输入验证码" attributes:@{NSForegroundColorAttributeName: palceColor}];
    phoneTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextFiled.textColor =  ColorWithHexRGB(0xffffff);
    phoneTextFiled.textAlignment = NSTextAlignmentCenter;
    phoneTextFiled.font = [UIFont systemFontOfSize:12];
    [loginView addSubview:phoneTextFiled];
    
    UILabel *phoneLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(userLine.frame), CGRectGetMaxY(userLine.frame)+Vertical_Login_Account_Height*3+20, Vertical_Login_Account_Weight-26-136, 0.5)];
    phoneLine.backgroundColor = ColorWithHexRGB(0xffffff);
    [loginView addSubview:phoneLine];
    
    //验证码
    UIButton *vertifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    vertifyButton.frame = CGRectMake(CGRectGetMaxX(phoneLine.frame) + 26, CGRectGetMinY(phoneLine.frame) - 46, 136, 46);
    vertifyButton.tag = Registe_VertifyButton_Tag;
    vertifyButton.clipsToBounds = YES;
    vertifyButton.layer.cornerRadius = 2.5f;
    vertifyButton.layer.borderColor = [ColorWithHexRGB(0xffffff) CGColor];
    vertifyButton.layer.borderWidth = 0.5;
    //    vertifyButton.backgroundColor = [UIColor clearColor];
    vertifyButton.titleLabel.textColor = ColorWithHexRGB(0xffffff);
    [vertifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [vertifyButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [vertifyButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:vertifyButton];
    
    //
    messageBtn = vertifyButton;
    
    //完成
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(CGRectGetMinX(repeatPasswordLine.frame), CGRectGetMaxY(phoneLine.frame) + 20,repeatPasswordLine.frame.size.width, 46);
    finishButton.tag = Registe_Button_Tag;
    [finishButton setTitle:@"注册" forState:UIControlStateNormal];
    finishButton.backgroundColor = ColorWithHexRGB(0x272832);
    finishButton.clipsToBounds = YES;
    finishButton.layer.cornerRadius = 2.5;
    [finishButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:finishButton];
    
    
}

#pragma marks-alertView

- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img
{
    [MmiaToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}

-(void)click:(UIButton *)btn
{
    if (btn.tag == Registe_BackButton_Tag) {
        [self dismissViewControllerAnimated:NO completion:nil];
        NSLog(@"取消");
    }
    else if (btn.tag == Registe_VertifyButton_Tag){
        NSLog(@"获取验证码");
        UITextField *userTextFiled = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
        if (userTextFiled.text.length == 0) {
            [self show_check_phone_info:@"手机号不能为空" image:nil];
            return ;
        }
        if ([MmiJudgeTypeUtil isPhoneNumber:userTextFiled.text] == NO ){
            [self show_check_phone_info:@"请输入正确的手机号" image:nil];
            return ;
        }
        [btn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        [btn.titleLabel setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self sendRequest];
        
    }
    
    if (btn.tag == Registe_Button_Tag){
        NSLog(@"完成");
        if ([self isGetVeryCode] && [self isVertifyCorrect]) {
            MmiaProcessView *processView=[[MmiaProcessView alloc]initWithMessage:@"正在验证信息..." top:App_Frame_Height];
            processView.tag=REGIST_IN_TAG;
            [processView showInRootView:self.view];
            [self sendRegistRequest];
        }
    }
}

- (void)setTarget:(id)tar withRegisterAction:(SEL)action
{
    target = tar;
    registerSuccessAction = action;
}


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
    url=Mmia_REGISTER_PHONE_VERITY_URL;
    [dict setObject:userTextField.text forKey:@"phone"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"validateType"];
    MmiaVerSucessView *sucView=(MmiaVerSucessView *)[self.view viewWithTag:Vertify_Success_Tag];
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:url param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        if ([jsonDict[@"result"]intValue]==0) {
            UITextField *mail = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
            sucView.hidden=NO;
            sucView.vertifyLabel.text=@"验证码已成功发送至手机";
            sucView.vertifyToLabel.text=mail.text;
            
        }else
        {
            sucView.hidden=YES;
            [self show_check_phone_info:@"很遗憾，获取验证码失败" image:nil];
        }
        
        
    }errorHandler:^(NSError *error){
        sucView.hidden=YES;
        if (app.mmiaNetworkEngine.isReachable==NO)
        {
            [self show_check_phone_info:@"没有网络连接" image:nil];
        }else
        {
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
        }
    }];
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
    if ([MmiJudgeTypeUtil isPhoneNumber:userTextFiled.text] == NO ){
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
//发送注册请求
-(void)sendRegistRequest
{
    MmiaProcessView *processView = (MmiaProcessView *)[self.view viewWithTag:REGIST_IN_TAG];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UITextField *userNameTextField = (UITextField *)[self.view viewWithTag:Registe_User_Tag];
    UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:Register_PassWord_Tag];
    UITextField *vertifyTextFiled=(UITextField *)[self.view viewWithTag:Register_Vertify_Tag];
    
    NSString *registerTypeStr=[[NSString alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    registerTypeStr=@"phone";
    [dict setObject:userNameTextField.text forKey:registerTypeStr];
    [dict setObject:[passwordTextField.text md5] forKey:@"password"];
    [dict setObject:vertifyTextFiled.text forKey:@"validateCode"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"userType"];
    
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_REGISTER_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]intValue]==0)
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:jsonDict[@"id"] forKey:USER_ID];
            [defaults setObject:jsonDict[@"ticket"] forKey:USER_TICKET];
            [defaults setBool:YES forKey:USER_IS_LOGIN];
            [defaults synchronize];
            //            [self dismissViewControllerAnimated:NO completion:nil];
            if( [target respondsToSelector:registerSuccessAction] )
            {
                [target performSelector:registerSuccessAction];
            }
        }else{
            [self show_check_phone_info:jsonDict[@"message"] image:nil];
        }
        [processView dismiss];
        
    }errorHandler:^(NSError *error){
        if (app.mmiaNetworkEngine.isReachable==NO) {
            [self show_check_phone_info:@"没有网络连接" image:nil];
        }else{
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
        }
        [processView dismiss];
        
    }];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self allTextFiledResign];
//    
//}

#pragma mark-TextFiledDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (isPortrait == NO) {
//    if ( _isUp==NO )
//    {
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            self.view.center = CGPointMake(Mmia_Portrait_Weight/2,Mmia_Portrait_Height/2-120);
//        UIView *view = [self.view viewWithTag:TAG_ALL_VIEW];
//            view.center = self.view.center;
////            [self.view setFrame:CGRectMake(0, -100, 1024, 768)];
//            _isUp=YES;
//            NSLog(@"%@",NSStringFromCGRect(self.view.frame));
//        }];
//    }
//    }
    if (textField.tag == Register_Vertify_Tag) {
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
    UITextField *passwordTextField = ((UITextField *)[self.view viewWithTag: Register_PassWord_Tag]);
    UITextField *confirmTextField = ((UITextField *)[self.view viewWithTag: Register_Confirme_PassWord_Tag]);
    UITextField *vertifyTextFiled=(UITextField *)[self.view viewWithTag:Register_Vertify_Tag];
    
    if (textField.tag == Registe_User_Tag) {
        [passwordTextField becomeFirstResponder];
        return NO;
    }
    else if (textField.tag == Register_PassWord_Tag)
    {
        //        [textField resignFirstResponder];
        [confirmTextField becomeFirstResponder];
        return NO;
    }else if (textField.tag == Register_Confirme_PassWord_Tag)
    {
        //        [textField resignFirstResponder];
        [vertifyTextFiled becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
//    [self restoreLocation];
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


//-(void)keyboardWillHidden{
//    if (isPortrait == NO) {
//
//    if ( _isUp==YES )
//    {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.view.center = CGPointMake(Mmia_Portrait_Weight/2,Mmia_Portrait_Height/2);
//            _isUp=NO;
//        }];
//    }
//    }
//}



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
//        [self restoreLocation];
    }
}

//-(void)restoreLocation
//{
//    if (isPortrait == NO) {
//
//    [UIView animateWithDuration:0.2 animations:^{
//        self.view.center = CGPointMake(Mmia_Portrait_Weight/2,Mmia_Portrait_Height/2);
//        _isUp=NO;
//    }];
//    }
//}


#pragma mark - UIViewControllerRotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.presentingViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    UIView *view = [self.view viewWithTag:TAG_ALL_VIEW];
    if( !UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        // 竖屏
        isPortrait = YES;
        view.center = CGPointMake(Mmia_Portrait_Height/2,Mmia_Portrait_Weight/2);
    }
    else
    {
        // 横屏
        isPortrait = NO;
        view.center = CGPointMake(Mmia_Portrait_Weight/2,Mmia_Portrait_Height/2);
        
    }
//    if (!iOS8Later) {
//        UIView *view = [self.view viewWithTag:TAG_ALL_VIEW];
        view.center = self.view.center;
//    }
    [view reloadInputViews];
    
}

//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}

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
