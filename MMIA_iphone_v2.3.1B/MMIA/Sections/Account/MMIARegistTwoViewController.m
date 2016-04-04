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

#import "MMIEmailPrompt.h"
//验证成功出现的view
#import "MMIVerSucessView.h"
#import "MMIJudgeTypeUtil.h"
//弹出框
#import "MMIToast.h"

#import "MMIProcessView.h"
#import "MMiaDataBaseManager.h"
#import "LoginUserItem.h"



//弹出框位置


#define RIGHT_BBI_TAG 1
#define LEFT_BBI_TAG 2

#define REGIST_VERTIFICATION_TAG 22
#define REGIST_INPUT_TAG 21
#define REGIST_EMAIL_TAG 11
#define REGIST_USER_NAME_TAG 12
#define REGIST_PASS_WORD_TAG 13

#define REGIST_TAG 20
#define EMAIL_PROMOT_TAG 23

#define VERTITICATION_SUCCESS_TAG 24

//注册成功弹出框
#define REGIST_SUCESS_ALERTVIEW_TAG 25

#define  REGIST_IN_TAG 26


static NSString *code_Mail=@"getValidateCodeForMail/";
static NSString *code_Phone=@"getValidateCodeForPhone/";
static NSString *regist_Code=@"register/";

@interface MMIARegistTwoViewController ()

@end

@implementation MMIARegistTwoViewController
{
    UIView *_bgView;
    UITextField *_mailTextField;
    UITextField *_userNameTextField;
    UITextField *_passWordTextField;
   
    BOOL _isRegist;
   
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"注册成功"]) {
        if (buttonIndex==0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
   
}


#pragma mark - regist
/*
 @param   nil
 @descripation  判断能不能登录（检查输入是否完整）
 */
- (BOOL)canRegist
{
    UITextField *mail = (UITextField *)[self.view viewWithTag:REGIST_EMAIL_TAG];
    UITextField *userName = (UITextField *)[self.view viewWithTag:REGIST_USER_NAME_TAG];
    UITextField *passWord = (UITextField *)[self.view viewWithTag:REGIST_PASS_WORD_TAG];
    if (_isRegist==NO) {
        if (mail.text.length!=0&&userName.text.length!=0&&passWord.text.length!=0) {
            return YES;
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请填写完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }else{
        return NO;
    }
}
/*
 @param   nil
 @descripation 登录
 */
- (void)regist
{
    
//    if ([self canRegist]) {
//        UITextField *mail = (UITextField *)[self.view viewWithTag:REGIST_EMAIL_TAG];
//        UITextField *userName = (UITextField *)[self.view viewWithTag:REGIST_USER_NAME_TAG];
//        UITextField *passWord = (UITextField *)[self.view viewWithTag:REGIST_PASS_WORD_TAG];
//
//        NSString *url = [NSString stringWithFormat:@"http://%@/pages/MmUser/loginCheck.do?mail=%@&username=%@&password=%@&mobile=yes",IP_PORT,mail.text,userName.text,passWord.text];
//        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        //add code...for regist
//        [userName resignFirstResponder];
//        [passWord resignFirstResponder];
//    }
}



#pragma mark - back forward vc
/*
 @param   nil
 @descripation  返回到上一级页面
 */
- (void)backToForwardVC
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index>1) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1] animated:YES];
    }else
        [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
- (void)countForResendNews
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block int i=60;
        while (i>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *btn = (UIButton *)[_bgView viewWithTag:REGIST_VERTIFICATION_TAG];
                
                
               
                [btn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",i--] forState:UIControlStateNormal];
                
                
                
                if (i==0) {
                    [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                    btn.enabled=YES;
                }
            });
            sleep(1);
        }
    });
    
}
 */

-(void)changeButtonTitle{
    [messageBtn setTitle:@"再次发送（60）" forState:UIControlStateNormal];
    messageBtn.enabled = NO;
    timeCount=60;
    [messageBtn setTitle:@"再次发送（60）" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction:) userInfo:nil repeats:YES];
    UITextField *mail = (UITextField *)[_bgView viewWithTag:REGIST_EMAIL_TAG];
    UITextField *userName = (UITextField *)[_bgView viewWithTag:REGIST_USER_NAME_TAG];
    UITextField *passWord = (UITextField *)[_bgView viewWithTag:REGIST_PASS_WORD_TAG];
    mail.enabled=NO;
    userName.enabled=NO;
    passWord.enabled=NO;

    
}
- (void)timerFunction:(NSTimer *)timer{
    messageBtn.enabled = NO;
    timeCount--;
    if (timeCount == 0) {
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
        }
        //        [messageBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [messageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [messageBtn setTitle:[NSString stringWithFormat:@"%d秒重新获取",60] forState:UIControlStateDisabled];
        messageBtn.enabled = YES;
        
        //        messageField.text = nil;
        //        self.messageStr = nil;
        UITextField *mail = (UITextField *)[_bgView viewWithTag:REGIST_EMAIL_TAG];
        UITextField *userName = (UITextField *)[_bgView viewWithTag:REGIST_USER_NAME_TAG];
        UITextField *passWord = (UITextField *)[_bgView viewWithTag:REGIST_PASS_WORD_TAG];
        mail.enabled=YES;
        userName.enabled=YES;
        passWord.enabled=YES;
        
    } else {
        //        [messageBtn setTitle:[NSString stringWithFormat:@"(%d秒)后重新获取",timeCount] forState:UIControlStateNormal];
        [messageBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",timeCount] forState:UIControlStateNormal];
        [messageBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",timeCount] forState:UIControlStateDisabled];
    }
}


#pragma mark - controlEvent
/*
 @param   button
 @descripation  按钮点击事件
 */


- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == RIGHT_BBI_TAG) {
        [self regist];
    }
    
    if (btn.tag==LEFT_BBI_TAG) {
        [self backToForwardVC];
    }
    if (btn.tag==REGIST_VERTIFICATION_TAG) {
       // [DEFAULTS setBool:NO forKey:@"BtnEnabled"];
        
        
            [self allTextFiledResign];
            
            if ([self isGetVeryCode]) {
                [self sendRequest];
            }
            
        
        

        
    }
    if (btn.tag==REGIST_TAG) {
       // MMIProcessView *processView=[[MMIProcessView alloc]initWithMessage:@"注册中..."];
        [self allTextFiledResign];
        MMIProcessView *processView=[[MMIProcessView alloc]initWithMessage:@"注册中..." top:-50];
        processView.tag=REGIST_IN_TAG;
        [processView showInRootView:_bgView];
        
        [self sendRegistRequest];
    }
    
    
}

//是否可以验证
-(BOOL)isGetVeryCode
{
    UITextField *mail = (UITextField *)[_bgView viewWithTag:REGIST_EMAIL_TAG];
    UITextField *userName = (UITextField *)[_bgView viewWithTag:REGIST_USER_NAME_TAG];
    UITextField *passWord = (UITextField *)[_bgView viewWithTag:REGIST_PASS_WORD_TAG];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
   
    
    if (mail.text.length==0) {
        //[self show_check_phone_info:@"邮箱/手机号不能为空"];
        [self show_check_phone_info:@"邮箱/手机号不能为空" image:nil];
        //[self alertviewTitle:@"验证失败" message:@"手机号文本框为空时"];
        return NO;
    }
    if ([MMIJudgeTypeUtil isEmailNumber:mail.text]==NO && [MMIJudgeTypeUtil isPhoneNumber:mail.text]==NO ){
       // [self show_check_phone_info:@"请输入正确的手机号或邮箱"];
         [self show_check_phone_info:@"请输入正确的手机号或邮箱" image:nil];
      //[self alertviewTitle:@"验证失败" message:@"请输入正确的手机号或邮箱"];
   return NO;
    }
   
    
    
    if (userName.text.length==0) {
        [self show_check_phone_info:@"密码不能为空" image:nil];

       // [self show_check_phone_info:@"密码不能为空"];
        //[self alertviewTitle:@"验证失败" message:@"密码不能为空"];
        return NO;
    }
    if (userName.text.length>=6 && userName.text.length<=20) {
        [self show_check_phone_info:@"密码为6-20个字母、数字" image:nil];

        //[self show_check_phone_info:@"密码为6-20个字母、数字"];
        //[self alertviewTitle:@"验证失败" message:@"密码为6-20个字母、数字"];
        return NO;
    }
    if (passWord.text.length==0) {
        [self show_check_phone_info:@"确认密码不能为空" image:nil];

       // [self show_check_phone_info:@"确认密码不能为空"];
        //[self alertviewTitle:@"验证失败" message:@"确认密码不能为空"];
        return NO;
    }
    if ([userName.text isEqualToString:passWord.text]==NO) {
        [self show_check_phone_info:@"两次密码输入不一致" image:nil];
        //[self show_check_phone_info:@"两次密码输入不一致"];
        //[self alertviewTitle:@"验证失败" message:@"两次密码输入不一致"];
        return NO;
    }
    
    

return YES;
}

#pragma mark -textFiledResign
-(void)allTextFiledResign{
    UITextField *userName = (UITextField *)[_bgView viewWithTag:REGIST_EMAIL_TAG];
    UITextField *password = (UITextField *)[_bgView viewWithTag:REGIST_USER_NAME_TAG];
    UITextField *confirmTextField = ((UITextField *)[_bgView viewWithTag:REGIST_PASS_WORD_TAG]);
    [userName resignFirstResponder];
    [password resignFirstResponder];
    [confirmTextField resignFirstResponder];
}
#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:kTipsTopOffset image:_img];

}



-(void)alertviewTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
}


#pragma mark-endRequestAndResult
-(void)sendRequest
{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UITextField *textField = ((UITextField *)[_bgView viewWithTag:REGIST_USER_NAME_TAG]);
    
    NSString *urlStand=[[NSString alloc]init];
    if ([textField.text rangeOfString:@"@"].location!=NSNotFound) {
        self.type=UserTypePhone;
        
        urlStand=code_Mail;
            }else{
                self.type=UserTypeMail;
                urlStand=code_Phone;
        
    }
    ////////
    [app.mmiaDataEngine testSendMailOrPhoneID:textField.text URL:urlStand completionHandler:^(NSDictionary *jsonObject){
        NSString *StandardStr=jsonObject[@"msg"];
        [self judgeResult:StandardStr];
        
        
    }errorHandler:^(NSError *error){
        if (app.mmiaDataEngine.isReachable==NO) {
           
            [self show_check_phone_info:@"没有网络连接" image:nil];
            
        }else{
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
        }
       
    }];
   
    
   
}

-(void)judgeResult:(NSString *)str
{
    if ([str isEqualToString:@"OK"]) {
         UITextField *mail = (UITextField *)[self.view viewWithTag:REGIST_EMAIL_TAG];
        
       UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"获取验证码成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
               [alert show];
        [self changeButtonTitle];

        MMIVerSucessView *sucView=(MMIVerSucessView *)[_bgView viewWithTag:VERTITICATION_SUCCESS_TAG];
        sucView.hidden=NO;
        if ([MMIJudgeTypeUtil isPhoneNumber:mail.text]) {
            sucView.vertifyLabel.text=@"验证码已成功发送至手机";
        }
        if ([MMIJudgeTypeUtil isEmailNumber:mail.text]) {
            sucView.vertifyLabel.text=@"验证码已成功发送至邮箱";
        }
        sucView.vertifyToLabel.text=mail.text;
        //[sucView creatLabe];
        
    }else{
         UITextField *textField = ((UITextField *)[_bgView viewWithTag:REGIST_INPUT_TAG]);
        //获取放在验证失败后
         //[self countForResendNews];
        if (textField.text.length==0) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"验证码为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"验证码输入有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
  
        }
        
    }
}
//点击注册的操作,信息写入本地并验证是否注册成功
-(void)sendRegistRequest
{
    MMIProcessView *processView=(MMIProcessView *)[_bgView viewWithTag:REGIST_IN_TAG];

     AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UITextField *textField = ((UITextField *)[_bgView viewWithTag:REGIST_EMAIL_TAG]);
    _webTimer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(webTimerOut) userInfo:nil repeats:YES];
    [app.mmiaDataEngine testSendMailOrPhoneID:textField.text URL:regist_Code completionHandler:^(NSDictionary *jsonObject){
        
        [processView dismiss];
        if ([jsonObject[@"result"]intValue]==0) {
            
            if ([_webTimer isValid]) {
                [_webTimer invalidate];
                _webTimer = nil;
            }
           
           // [self alertviewTitle:@"注册" message:@"注册成功"];
            [self show_check_phone_info:@"注册成功" image:@"personal_10.png"];
            
            
            
        }
        
    }errorHandler:^(NSError *error){
        if ([_webTimer isValid]) {
            [_webTimer invalidate];
            _webTimer = nil;
        }
        [processView dismiss];
        if (app.mmiaDataEngine.isReachable==NO) {
            
            [self show_check_phone_info:@"没有网络连接" image:nil];
            
        }else{
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
        }

    }];
    
}
-(void)webTimerOut{
    [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
     MMIProcessView *processView=(MMIProcessView *)[_bgView viewWithTag:REGIST_IN_TAG];
    if ([_webTimer isValid]) {
        [_webTimer invalidate];
        _webTimer = nil;
    }

    [processView dismiss];
    [MMiaDataEngine cancelOperationsContainingURLString:regist_Code];
    
}




#pragma mark - initUI

/*
 @param  textfield的tag值
 @descripation  判断输入框是否设置为加密输入模式
 */
- (BOOL)setSecureTextEntryOrOntWithTextFieldTag:(NSInteger)tag
{
    if (tag == REGIST_PASS_WORD_TAG) {
        return YES;
    }else
        return NO;
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
    [MMiaCommonUtil initializeTextFieldWithFrame:CGRectMake(20, (frame.size.height-30)/2.0f, frame.size.width-20, 30) andTag:textFieldTag andPlaceholder:titleName  andSecureTextEntry:[self setSecureTextEntryOrOntWithTextFieldTag:textFieldTag] andSuperView:view];

//    [MMiaCommonUtil initializeTextFieldWithFrame:CGRectMake(20, (frame.size.height-30)/2.0f, frame.size.width-20, 30) andTag:textFieldTag andPlaceholder:titleName  andSecureTextEntry:YES andSuperView:view];

    [_bgView addSubview:view];
}

#pragma mark - LoadUI
- (void)loadNavView
{
    
    self.navigationImageView.image = nil;
    CGRect rect = self.navigationImageView.frame;
    rect.origin.y = VIEW_OFFSET;
    rect.size.height = 44;
    self.navigationImageView.frame = rect;
    self.navigationImageView.backgroundColor = UIColorFromRGB(0xF4F5F7);

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    
    self.rightBarButton.hidden = YES;
    self.leftBarButton.tag = LEFT_BBI_TAG;
    self.leftBarButton.frame = CGRectMake(0, VIEW_OFFSET, 55, self.navigationView.frame.size.height-VIEW_OFFSET);
    [self.leftBarButton setImage:[UIImage imageNamed:@"login_02"] forState:UIControlStateNormal];
    [self.leftBarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = @"注册";
    self.titleLabel.textColor = UIColorFromRGB(0xCE212A);
    
}




- (void)loadBgView
{
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width , App_Frame_Height-20-TABLE_BAR_HEIGHT-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    
    //添加logo
    NSLog(@"%f",App_Frame_Width /2.0f);
    
    //添加信息输入栏
    [self initEditUIWithTitleName:@"邮箱/手机号" andEditTextImage:@"login_ico_activation" andTextFieldTag:REGIST_EMAIL_TAG andFrame:CGRectMake(10, 10,_bgView.frame.size.width-20 ,44)];
    UITextField *emailTextFiled = ((UITextField *)[_bgView viewWithTag:REGIST_EMAIL_TAG]);
    emailTextFiled.delegate=self;
    
    
   
    
    
    
    
    [self initEditUIWithTitleName:@"密码" andEditTextImage:@"login_ico_password" andTextFieldTag:REGIST_USER_NAME_TAG andFrame:CGRectMake(10, 58,_bgView.frame.size.width-20 ,44)];
    UITextField *passWordTextFiled = ((UITextField *)[_bgView viewWithTag:REGIST_USER_NAME_TAG]);
    passWordTextFiled.delegate=self;

    
    
    
    [self initEditUIWithTitleName:@"确认密码" andEditTextImage:@"login_ico_password" andTextFieldTag:REGIST_PASS_WORD_TAG andFrame:CGRectMake(10, 106,_bgView.frame.size.width-20 ,44)];
    UITextField *confirmTextField = ((UITextField *)[_bgView viewWithTag:REGIST_PASS_WORD_TAG]);
    confirmTextField.delegate=self;

    

    
   // [self initEditUIWithTitleName:@"昵称" andEditTextImage:@"login_ico_password" andTextFieldTag:REGIST_PASS_WORD_TAG andFrame:CGRectMake(10, 154,_bgView.frame.size.width-20 ,44)];

   UIButton *btn = [MMiaCommonUtil initializeButtonWithFrame:CGRectMake(10, 218, _bgView.frame.size.width-20, 44) title:@"注册" titleFont:[UIFont systemFontOfSize:15] titleColor:nil backgroundImageNamed:@"login_04@2x" image:nil andSuperView:_bgView andBtnTag:REGIST_TAG];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //提示验证码成功时，验证码发送的地方
    
    MMIVerSucessView *verView=[[MMIVerSucessView alloc]initWithFrame:CGRectMake(20, 272, 200, 40)];
    verView.hidden=NO;
   // verView.backgroundColor=[UIColor greenColor];
    verView.tag=VERTITICATION_SUCCESS_TAG;
    
    
    [_bgView addSubview:verView];
    
    
    
    
    //验证码
    [self initEditUIWithTitleName:@"请输入验证码" andEditTextImage:nil andTextFieldTag:REGIST_INPUT_TAG andFrame:CGRectMake(10, 154,_bgView.frame.size.width/2-2-10 , 44)];
     UITextField *inPuttextField = ((UITextField *)[_bgView viewWithTag:REGIST_INPUT_TAG]);
    inPuttextField.delegate=self;
    /*
    UIButton *getBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    getBtn.backgroundColor=[UIColor lightGrayColor];
    getBtn.frame=CGRectMake(10+_bgView.frame.size.width/2, 154, _bgView.frame.size.width/2-2, 44);
    getBtn.tag=REGIST_VERTIFICATION_TAG;
    getBtn.titleLabel.textColor=[UIColor darkGrayColor];
    [getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    */
    
    
    UIButton *getBtn=[MMiaCommonUtil initializeButtonWithFrame:CGRectMake(10+_bgView.frame.size.width/2, 154, _bgView.frame.size.width/2-2-20, 44) title:@"获取验证码" titleFont:[UIFont systemFontOfSize:17] imageNamed:nil andSuperView:_bgView andBtnTag:REGIST_VERTIFICATION_TAG];
    getBtn.layer.borderColor = [UIColorFromRGB(0xEAEAEA) CGColor];
    //getBtn.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    getBtn.layer.borderWidth=1;
    getBtn.layer.cornerRadius=4;
    getBtn.backgroundColor=[UIColor lightGrayColor];
    getBtn.titleLabel.textColor=[UIColor darkGrayColor];
    [getBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:getBtn];
    messageBtn=getBtn;
    
    
    //email下拉信息表
    /*
    MMIEmailPrompt *emailPromotView=[[MMIEmailPrompt alloc]initWithFrame:CGRectMake(emailTextFiled.frame.origin.x, emailTextFiled.frame.origin.y+emailTextFiled.frame.size.height+10, emailTextFiled.frame.size.width, 120)];
     */
    
    MMIEmailPrompt *emailPromotView=[[MMIEmailPrompt alloc]initWithFrame:CGRectMake(emailTextFiled.frame.origin.x-10, emailTextFiled.frame.origin.y+emailTextFiled.frame.size.height+17, emailTextFiled.frame.size.width+21, 120)];
    

     emailPromotView.emailDelegate=self;
    emailPromotView.hidden=YES;
    emailPromotView.tag=EMAIL_PROMOT_TAG;
    [_bgView addSubview:emailPromotView];
    
    //////
       }


- (void)viewDidLoad
{
    [super viewDidLoad];
   
        self.navigationController.navigationBarHidden = YES;
    _isRegist = NO;
    [self loadBgView];
    [self loadNavView];
   
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [self showTabebar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
     MMIEmailPrompt *emailPromptView=(MMIEmailPrompt *)[self.view viewWithTag:EMAIL_PROMOT_TAG];
    emailPromptView.hidden=YES;
   
    
    UITextField *textField = ((UITextField *)[_bgView viewWithTag:REGIST_USER_NAME_TAG]);
    [textField resignFirstResponder];
    textField = ((UITextField *)[_bgView viewWithTag:REGIST_PASS_WORD_TAG]);
    [textField resignFirstResponder];
    textField = ((UITextField *)[_bgView viewWithTag:REGIST_EMAIL_TAG]);
    [textField resignFirstResponder];
    textField=((UITextField *)[_bgView viewWithTag:REGIST_INPUT_TAG]);
    [textField resignFirstResponder];
    //    [textField endEditing:YES];
}

#pragma mark-TextFiledDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    UITextField *mail = (UITextField *)[self.view viewWithTag:REGIST_EMAIL_TAG];
    UITextField *userName = (UITextField *)[self.view viewWithTag:REGIST_USER_NAME_TAG];
    UITextField *password = (UITextField *)[self.view viewWithTag:REGIST_PASS_WORD_TAG];
  UITextField *confirmTextField = ((UITextField *)[_bgView viewWithTag:REGIST_PASS_WORD_TAG]);
    
    
    if (userName == textField) {
        password.text = nil;
        confirmTextField.text=nil;
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    UITextField *inputVery = (UITextField *)[_bgView viewWithTag:REGIST_INPUT_TAG];
    
    if (inputVery==textField) {
        if (inputVery.text.length>=6 && ![string isEqualToString:@""]) {
            return NO;
        }
    
        
    }
    
     UITextField *mail = (UITextField *)[self.view viewWithTag:REGIST_EMAIL_TAG];
    MMIEmailPrompt *emailPromptView=(MMIEmailPrompt *)[self.view viewWithTag:EMAIL_PROMOT_TAG];
   
   // emailPromptView.backgroundColor=[UIColor redColor];
    
    if (textField==mail) {
        
        if ([string isEqualToString:@"@"]) {
             NSMutableString *str=[NSMutableString stringWithFormat:@"%@@",mail.text];
            [emailPromptView reinitDataArray:str];
            [emailPromptView.tableView reloadData];
            [emailPromptView setHidden:NO];
                    }
    }
       return YES;
}


#pragma mark-MMIEmailPromptDelegate
-(void)sendSelectCellStr:(NSString *)str{
    UITextField *mail = (UITextField *)[self.view viewWithTag:REGIST_EMAIL_TAG];
       mail.text=str;
    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
