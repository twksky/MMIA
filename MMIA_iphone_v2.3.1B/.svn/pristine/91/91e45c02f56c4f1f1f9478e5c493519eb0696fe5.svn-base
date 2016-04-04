//
//  MMIALoginViewController.m
//  MMIAAdIphone
//
//  Created by Vivian's Office MAC on 14-2-12.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIALoginViewController.h"
#import "MMIARegistTwoViewController.h"
//#import "MMIAIndexViewController.h"
//#import "MMIAAppDelegate.h"
//#import "MMIAHttpManager.h"
//#import "MMIAInforItem.h"
#import <QuartzCore/QuartzCore.h>
#import "UMSocial.h"
#import "MMIAForgetPasswordViewController.h"

#import "MMiaCommonUtil.h"
#import "MMIProcessView.h"
#import "MMIAPersonalHomePageViewController.h"

#import "MMiaDataBaseManager.h"
#import "LoginUserItem.h"
#import "MMIToast.h"
#import "NSMutableDictionary+extent.h"



////////////////////////////////////////////////////////////////////////////////////////
#define REGISTER_TAG 1
#define LOGIN_TAG   2
#define FORGET_PASSWORD_TAG   3


#define KEY_WORD_TAG    13
#define REM_PASS_WORD_TAG 14
#define AUTO_LOGIN_TAG 15

#define USER_NAME_TEXT_TAG 26
#define PASS_WORD_TEXT_TAG 27

#define LEFT_BBI_TAG 101

#define RIGHT_BBI_TAG 100

#define RELATED_LOGIN_TAG 1000
#define EMAIL_PROMOT_TAG 20
#define PROCESS_VIEW_TAG 21

@interface MMIALoginViewController ()
{
    BOOL _islogin;
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

#pragma mark - after successed login
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"登录成功"]) {
        NSLog(@"in login--alertView--login success ");
        if ([self.navigationController respondsToSelector:@selector(popToRootViewControllerAnimated:)]||[self.navigationController respondsToSelector:@selector(popToViewController:animated:)]) {
            if (self.backToRootViewController) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
                [self.navigationController  popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1] animated:YES];
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}
#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:kTipsTopOffset image:_img];
    
}



#pragma mark - update
/*
 @param   root(登录信息解析的数据)（NSDictionary类型）
 @descripation  登录信息解析的数据
*/
- (void)updateData:(NSDictionary *)root
{
    NSLog(@"下载后登录信息 root:%@",root);
    if (root) {
        if ([root objectForKey:@"sessionId"]) {
            //存储登录个人信息
            NSString *userType = nil;
            if ([[root objectForKey:@"userType"] isEqualToString:@"1"]) {
                userType = ENTERPRISE_USER;
            }else
                userType = PRESON_USER;
            
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
            for (NSString *key in [root allKeys]) {
                NSString *string = [root objectForKey:key];
                [dict setObject:string forKey:key];
            }
            [dict setObject:userType forKey:@"userType"];
            [userdefaults setObject:dict forKey:@"privateInfor"];
            [userdefaults synchronize];

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
//            [[MMIAHttpManager sharedManager] removeObjectForKey:@"login"];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户名或密码不正确,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败!" message:@"请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)setRelatedLoginWithPlatform:(UMSocialSnsType)socialSnsType
{
    

    //分享平台
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[UMSocialSnsPlatformManager getSnsPlatformString:socialSnsType]];
//    NSLog(@"%d",socialSnsType);
//    UMSocialSnsPlatformManager *manger = [UMSocialSnsPlatformManager sharedInstance];
//    NSLog(@"allSnsPlatformDictionary  %@",[manger allSnsPlatformDictionary]);
//        NSLog(@"allSnsValuesArray  %@",[manger allSnsValuesArray]);
//    if ([UMSocialAccountManager isOauthWithPlatform:snsPlatform.platformName]) {
//        [[UMSocialDataService defaultDataService] requestUnOauthWithType:snsPlatform.platformName completion:^(UMSocialResponseEntity *response) {
//            NSLog(@"unOauth response is %@",response);
//        }];
//        return;
//    }
//    //
//
//    
//    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        NSLog(@"login response is %@",response);
//        //获取微博的用户名 、uid、token等
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSLog(@"%@",[UMSocialAccountManager socialAccountDictionary]);
//            NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
//        }
//        //这里可以获取到腾讯微博openid,Qzone的token等
//        /*
//         if ([platformName isEqualToString:UMShareToTencent]) {
//         [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
//         NSLog(@"get openid  response is %@",respose);
//         }];
//         }
//         */
//    });
    
}

#pragma mark - login
/*
 @param   nil
 @descripation  判断能不能登录（检查输入是否完整）
*/
- (BOOL)canLogin
{
    UITextField *userName = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
    UITextField *passWord = (UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG];
    if (_islogin==NO) {
        if (userName.text.length!=0&&passWord.text.length!=0) {
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

-(void)sendLoginRequest{
     MMIProcessView *processView=(MMIProcessView *)[_bgView viewWithTag:PROCESS_VIEW_TAG];
    UITextField *userName=(UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
    UITextField *passWord=(UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    _timer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(webTimerOut) userInfo:nil repeats:YES];
    
    [appDelegate.mmiaDataEngine testSendLoginRequest:userName.text password:passWord.text completionHandler:^(NSDictionary *jsonObject){
       
        [processView dismiss];
        
        if ([jsonObject[@"result"] intValue]==0) {
            NSLog(@"登录成功");
            [self do_login_sucess:jsonObject];
        }
        
    }errorHandler:^(NSError *error){
        if (appDelegate.mmiaDataEngine.isReachable==NO) {
            
            [self show_check_phone_info:@"没有网络连接" image:nil];
            
        }else{
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
        }
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }

        [processView dismiss];
        

    }];
    
    
    
    
    
}
-(void)webTimerOut{
    
   
    MMIProcessView *processView=(MMIProcessView *)[_bgView viewWithTag:PROCESS_VIEW_TAG];
    if ([_timer isValid]) {
         [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
        [_timer invalidate];
       _timer = nil;
    }
    
    [processView dismiss];
    [MMiaDataEngine cancelOperationsContainingURLString:@"login/"];

    
}



-(void)do_login_sucess:(NSDictionary *)jsonObject{
    
    LoginUserItem *item=[[LoginUserItem alloc]init];
     UITextField *mail = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
    /*
        item.userName=mail.text;
    item.funsNum=jsonObject[@"funsNum"];
    item.id=jsonObject[@"id"];
    item.phone=jsonObject[@"phone"];
    item.headPicture=jsonObject[@"headPicture"];
    item.ticket=jsonObject[@"ticket"];
    item.nickName=jsonObject[@"nickName"];
    item.email=jsonObject[@"email"];
    MMiaDataBaseManager *manager=[MMiaDataBaseManager sharedManager];
    [manager addUser:item];
    
    */
    NSString *funsNum=jsonObject[@"funsNum"];
    NSString *id=jsonObject[@"id"];
    NSString *phone=jsonObject[@"phone"];
    NSString *ticket=jsonObject[@"ticket"];
    NSString *nickName=jsonObject[@"nickName"];
    NSString *email=jsonObject[@"email"];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    
    [userDefaults setUserDefaultObject:funsNum forKey:@"FUNS_NUM"];
    [userDefaults setUserDefaultObject:id forKey:@"ID"];
    [userDefaults setUserDefaultObject:phone forKey:@"PHONE"];
    [userDefaults setUserDefaultObject:ticket forKey:@"TICKET"];
    [userDefaults setUserDefaultObject:nickName forKey:@"NIKE_NAME"];
    [userDefaults setUserDefaultObject:email forKey:@"EMAIL"];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

     UIImage * imageFromURL = [self getImageFromURL:jsonObject[@"headPicture"]];
    [self saveImage:imageFromURL withFileName:@"MyImage" ofType:@"jpeg" inDirectory:documentsDirectoryPath];
    
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }

    
   
    MMIAPersonalHomePageViewController *ppvc=[[MMIAPersonalHomePageViewController alloc]init];
    ppvc.userName=mail.text;
    [self.navigationController pushViewController:ppvc animated:YES];
}

- (void)login
{
    if ([self canLogin]) {
       // MMIProcessView *processView=[[MMIProcessView alloc]initWithMessage:@"登陆中,请稍后...."];
        MMIProcessView *processView=[[MMIProcessView alloc]initWithMessage:@"登陆中,请稍后...." top:60];
        
        processView.tag=PROCESS_VIEW_TAG;
        [processView showInRootView:_bgView];
        
      [self sendLoginRequest];
    }
    
//    if ([self canLogin]) {
//        UITextField *userName = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
//        UITextField *passWord = (UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG];
//        NSString *url = [NSString stringWithFormat:@"http://%@/pages/MmUser/loginCheck.do?username=%@&password=%@&mobile=yes",IP_PORT,userName.text,passWord.text];
//        self.loginUrl = url;//获取当前登录链接.
//        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //登录中
      // [self showMBProgressHUDOnRootView:self.view withTitle:@"登录中" mode:MBProgressHUDModeActivityIndicatorView animationType:MBProgressHUDAnimationZoom];
//        __block MMIALoginViewController *viewController = self;
//        [self addPostTask:url type:LOGIN_TYPE andClassID:@"login" completion:^(NSDictionary *root) {
//            [viewController hideMBProgress];
//            [viewController updateData:root];
//        }];
//        [userName resignFirstResponder];
//        [passWord resignFirstResponder];
//    }
}

#pragma mark -image
-(UIImage *)getImageFromURL:(NSString *)fileURL{
    UIImage *result;
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result=[UIImage imageWithData:data];
    return result;
}
-(void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath{
    if ([[extension lowercaseString]isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",imageName, @"png"]] options:NSAtomicWrite error:nil];
        
    }else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]){
         [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    }else{
        NSLog(@"文件后缀不认识");
    }
}


#pragma mark - back forward vc
/*
 @param   nil
 @descripation  返回到上一级页面
*/
- (void)backToForwardVC
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    return;
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index>1) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1] animated:YES];
    }else
        [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - controlEvent
/*
 @param   button
 @descripation  按钮点击事件
 */
- (void)btnClick:(UIButton *)btn
{
    [self resignAllResponder];
    if (btn.tag == LOGIN_TAG) {
        [self login];
       /*
        MMIProcessView *processView=(MMIProcessView *)[_bgView viewWithTag:PROCESS_VIEW_TAG];
        [processView dismiss];
        MMIAPersonalHomePageViewController *ppvc=[[MMIAPersonalHomePageViewController alloc]init];
       
        [self.navigationController pushViewController:ppvc animated:YES];
      */
         
    }
    if (btn.tag == REGISTER_TAG) {
        MMIARegistTwoViewController *rvc = [[MMIARegistTwoViewController alloc]init];
       [self.navigationController pushViewController:rvc animated:YES];
    }
    if (btn.tag==LEFT_BBI_TAG) {
        [self backToForwardVC];
    }
    if (btn.tag == FORGET_PASSWORD_TAG) {
        MMIAForgetPasswordViewController *fvc = [[MMIAForgetPasswordViewController alloc]init];
       [self.navigationController pushViewController:fvc animated:YES];
    }
    if (btn.tag>=RELATED_LOGIN_TAG&&btn.tag<=RELATED_LOGIN_TAG+3) {
        //QQ关联
        if (btn.tag==RELATED_LOGIN_TAG) {
            
            [_tencentOAuth authorize:_permissions inSafari:NO];
        }
        //新浪微博
        if (btn.tag==RELATED_LOGIN_TAG+1) {
            
                       [self sinaBtnPressed];
            
        }
        if (btn.tag==RELATED_LOGIN_TAG+3) {
            self.type=ThirdLoginTypeTecentWeiBo;
            [self.wbapi loginWithDelegate:self andRootController:self];
        }
        
        
    /*
        UMSocialSnsType type = UMSocialSnsTypeNone;
        switch (btn.tag-RELATED_LOGIN_TAG) {
            case 0:
                //QQ关联
                type = UMSocialSnsTypeMobileQQ;
                break;
            case 1:
                //sina关联
                type = UMSocialSnsTypeSina;
                break;
            case 2:
                //微信关联
                type = UMSocialSnsTypeWechatTimeline;
                break;
            case 3:
                //腾讯微博关联
                type = UMSocialSnsTypeTenc;
                break;
            default:
                break;
        }
        [self setRelatedLoginWithPlatform:type];
        */
    }
    
    
}
//新浪微博登陆
-(void)sinaBtnPressed{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWbRedirectURI;
    request.scope = @"all";
    /*
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
     */
    
    [WeiboSDK sendRequest:request];

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


#pragma mark - initUI

/*
 @param  textfield的tag值
 @descripation  判断输入框是否设置为加密输入模式
 */
- (BOOL)setSecureTextEntryOrOntWithTextFieldTag:(NSInteger)tag
{
    if (tag == PASS_WORD_TEXT_TAG) {
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
    [self initializeTextFieldWithFrame:CGRectMake(20, (frame.size.height-30)/2.0f, frame.size.width-20, 30) andTag:textFieldTag andPlaceholder:titleName  andSecureTextEntry:[self setSecureTextEntryOrOntWithTextFieldTag:textFieldTag] andSuperView:view];
    
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
    self.leftBarButton.frame = CGRectMake(0, VIEW_OFFSET, 60, 44);
    [self.leftBarButton setImage:[UIImage imageNamed:@"login_01"] forState:UIControlStateNormal];
    [self.leftBarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = @"登录";
    self.titleLabel.textColor = UIColorFromRGB(0xCE212A);

    
}


- (void)loadTextForTextField
{
    UITextField *userName = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
    UITextField *passWord = (UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userNameStr = [userdefaults objectForKey:@"userName"];
    NSString *passWordStr = [userdefaults objectForKey:@"passWord"];
    
    if (userNameStr) {
        userName.text = userNameStr;
        NSString *rememberPassWordStr = [userdefaults objectForKey:@"rememberPassWord"];
        if ([rememberPassWordStr isEqualToString:@"1"])
            passWord.text = passWordStr;
        NSString *autoLoginStr = [userdefaults objectForKey:@"autoLogin"];
        if ([autoLoginStr isEqualToString:@"1"]) {
            passWord.text = passWordStr;
        }
    }
    
    
}

- (void)loadBgView
{
   

    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, App_Frame_Height-20-TABLE_BAR_HEIGHT-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    
    //添加logo
    NSLog(@"%f",App_Frame_Width/2.0f);
    
    //添加信息输入栏
    [self initEditUIWithTitleName:@"邮箱/手机号/昵称" andEditTextImage:@"login_ico_activation" andTextFieldTag:USER_NAME_TEXT_TAG andFrame:CGRectMake(10, 10,_bgView.frame.size.width-20 ,44)];
    
    [self initEditUIWithTitleName:@"密码" andEditTextImage:@"login_ico_password" andTextFieldTag:PASS_WORD_TEXT_TAG andFrame:CGRectMake(10, 58,_bgView.frame.size.width-20 ,44)];
    
    UIButton *btn = [MMiaCommonUtil initializeButtonWithFrame:CGRectMake(10, 122, _bgView.frame.size.width-20, 44) title:@"登录" titleFont:[UIFont systemFontOfSize:15] titleColor:nil backgroundImageNamed:@"login_04@2x" image:nil andSuperView:_bgView andBtnTag:LOGIN_TAG];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    btn = [MMiaCommonUtil initializeButtonWithFrame:CGRectMake(0, 166, 90, 40) title:@"忘记密码" titleFont:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0x7F7F7F) backgroundImageNamed:nil image:nil andSuperView:_bgView andBtnTag:FORGET_PASSWORD_TAG];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

   btn=[MMiaCommonUtil initializeButtonWithFrame:CGRectMake(_bgView.frame.size.width-90, 166,90, 40) title:@"注册新用户" titleFont:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0x7F7F7F) backgroundImageNamed:nil image:nil andSuperView:_bgView andBtnTag:REGISTER_TAG];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    [MMiaCommonUtil initializeImageViewWithFrame:CGRectMake(10, 256, App_Frame_Width-20, 14) imageNamed:@"login_03@2x" andSuperView:_bgView andTag:0];
    
    //添加关联登录按钮
    [self releatedLoginInterFaceButton];
    
    
    UITextField *emailTextFiled = ((UITextField *)[_bgView viewWithTag:USER_NAME_TEXT_TAG]);
    emailTextFiled.delegate=self;
    //email下拉信息表
    
    MMIEmailPrompt *emailPromotView=[[MMIEmailPrompt alloc]initWithFrame:CGRectMake(emailTextFiled.frame.origin.x-10, emailTextFiled.frame.origin.y+emailTextFiled.frame.size.height+17, emailTextFiled.frame.size.width+21, 120)];
    emailPromotView.emailDelegate=self;
    
    emailPromotView.hidden=YES;
    emailPromotView.tag=EMAIL_PROMOT_TAG;
    [_bgView addSubview:emailPromotView];


}

- (void)releatedLoginInterFaceButton
{
    NSArray *array = [NSArray arrayWithObjects:@"login_06@2x",@"login_07@2x",@"login_10@2x",@"login_11@2x",nil];

    CGFloat btnwidth = (App_Frame_Width-3*10)/2.0f;
    CGFloat btnHeight = 42;
    CGFloat space = 10;
    for (int i=0;i<array.count;i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(space+(i%2)*(btnwidth+space), 290+(i/2)*(btnHeight+space),btnwidth,btnHeight);
        [btn setBackgroundImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = RELATED_LOGIN_TAG+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // NSString *appid=@"101102472";
    NSString *appid=@"222222";
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:appid andDelegate:self];
    
    _permissions=[[NSMutableArray alloc]initWithObjects:kOPEN_PERMISSION_GET_USER_INFO, nil];
    
    //腾讯微博
    if(self.wbapi == nil)
    {
        self.wbapi = [[WeiboApi alloc]initWithAppKey:kTCWbAppKey andSecret:kTCWbAppSecret andRedirectUri:kTCWbRedirectURI];
    }
      _islogin = NO;
    [self loadBgView];
    [self loadNavView];
    [self loadTextForTextField];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    UITextField *nameTextField = ((UITextField *)[_bgView viewWithTag:USER_NAME_TEXT_TAG]);
    UITextField *passTextField = ((UITextField *)[_bgView viewWithTag:PASS_WORD_TEXT_TAG]);
    nameTextField.text=nil;
    passTextField.text=nil;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [self showTabebar];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

// yhx add
- (void)addLoadingView
{
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_OFFSET + 44, 320, Main_Screen_Height - VIEW_OFFSET - 44)];
    loadingView.backgroundColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:1.0];
    loadingView.tag = 1001;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, ( Main_Screen_Height / 2 ) - 20, 320, 20)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = @"正在登录...";
    [loadingView addSubview:lbl];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(90, ( Main_Screen_Height / 2 ) - 20, 20, 20)];
    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [loadingView addSubview:activity];
    [activity startAnimating];
    
    [self.view addSubview:loadingView];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:1001]];
}

#pragma mark-TextFiledDelegate
-(void)resignAllResponder{
     UITextField *nameTextField = ((UITextField *)[_bgView viewWithTag:USER_NAME_TEXT_TAG]);
    UITextField *passTextField = ((UITextField *)[_bgView viewWithTag:PASS_WORD_TEXT_TAG]);
    [nameTextField resignFirstResponder];
    [passTextField resignFirstResponder];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     MMIEmailPrompt *emailPromptView=(MMIEmailPrompt *)[self.view viewWithTag:EMAIL_PROMOT_TAG];
    UITextField *textField = ((UITextField *)[_bgView viewWithTag:USER_NAME_TEXT_TAG]);
    [textField resignFirstResponder];
    textField = ((UITextField *)[_bgView viewWithTag:PASS_WORD_TEXT_TAG]);
    [textField resignFirstResponder];
    [emailPromptView setHidden:YES];
    //    [textField endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITextField *userName = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
    UITextField *password = (UITextField *)[self.view viewWithTag:PASS_WORD_TEXT_TAG];
    
    if (userName == textField) {
        password.text = nil;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    UITextField *emailTextFiled = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
   MMIEmailPrompt *emailPromptView=(MMIEmailPrompt *)[self.view viewWithTag:EMAIL_PROMOT_TAG];
    
    

   
    
    if (textField==emailTextFiled) {
        
        
        if ([string isEqualToString:@"@"]) {
            NSMutableString *str=[NSMutableString stringWithFormat:@"%@@",emailTextFiled.text];
        [emailPromptView reinitDataArray:str];
            [emailPromptView.tableView reloadData];
            [emailPromptView setHidden:NO];
        }
        

   }
    return YES;

}

#pragma mark-MMIEmailPromptDelegate
-(void)sendSelectCellStr:(NSString *)str{
    UITextField *mail = (UITextField *)[self.view viewWithTag:USER_NAME_TEXT_TAG];
   // NSMutableString *mutabMailTextStr=[NSMutableString stringWithString:mail.text];
    //[mutabMailTextStr appendString:str];
    mail.text=str;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TencentSessionDelegate
-(void)tencentDidLogin{
    if (_tencentOAuth.accessToken && 0 !=[_tencentOAuth.accessToken length]) {
        NSLog(@"授权成功 %@",_tencentOAuth.accessToken);
        
        
    }else{
        NSLog(@"授权不成功");
    }
}
//非网络错误导致登录失败
-(void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        NSLog(@"用户取消登录");
    }else{
        NSLog(@"登录失败");
    }
}
//网络错误导致登录失败：
-(void)tencentDidNotNetWork{
    NSLog(@"无网络连接，请设置网络");
}

#pragma marks -WBHttpRequestDelegate
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    NSLog(@"%@",result);
    
}

#pragma mark WeiboAuthDelegate

-(void)DidAuthFinished:(WeiboApi *)wbapi
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r\n openid = %@\r\n appkey=%@ \r\n appsecret=%@ \r\n refreshtoken=%@ ", wbapi.accessToken, wbapi.openid, wbapi.appKey, wbapi.appSecret, wbapi.refreshToken];
    NSLog( @"授权成功！str = %@", str );
}

- (void)DidAuthCanceled:(WeiboApi *)wbapi_
{
    NSLog(@"取消授权！");
}

- (void)DidAuthFailWithError:(NSError *)error
{
    NSLog(@"授权失败！");
}

@end
