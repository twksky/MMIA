//
//  MMIASetNewPassWordViewController.m
//  MMIA
//
//  Created by Vivian's Office MAC on 14-5-30.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIASetNewPassWordViewController.h"
#import "MMiaCommonUtil.h"
#import <QuartzCore/QuartzCore.h>
//弹出框
#import "MMIToast.h"


#define RIGHT_BBI_TAG 1
#define LEFT_BBI_TAG 2

#define RESET_PASSWORD_TAG 20

#define NEW_PASSWORD_TAG 12
#define ENSURE_PASSWORD_TAG 13

#define FINISH_TAG 20
//增加验证码
#define VERITIFY_CODE_TEXTVIEW_TAG 10

@interface MMIASetNewPassWordViewController ()

@end

@implementation MMIASetNewPassWordViewController
{
    UIView *_bgView;
    UITextField *_newPasswordTextField;
    UITextField *_ensurePassWordTextField;
    BOOL _isResetPassword;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - regist
/*
 @param   nil
 @descripation  判断能不能从设置（检查输入是否完整）
 */
- (BOOL)canReset
{
    UITextField *newPassword = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
    UITextField *ensurepassWord = (UITextField *)[self.view viewWithTag:ENSURE_PASSWORD_TAG];
    if (_isResetPassword==NO) {
        if (newPassword.text.length!=0&&ensurepassWord.text.length!=0) {
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
 @descripation 设置新密码
 */
- (void)reset
{
    
    if ([self canReset]) {
        UITextField *newPassword = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
        UITextField *ensurepassWord = (UITextField *)[self.view viewWithTag:ENSURE_PASSWORD_TAG];
        
        NSString *url = nil;
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //add code...for regist
        [newPassword resignFirstResponder];
        [ensurepassWord resignFirstResponder];
    }
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
#pragma mark - controlEvent
/*
 @param   button
 @descripation  按钮点击事件
 */
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == RIGHT_BBI_TAG) {
        [self reset];
    }
    
    if (btn.tag==LEFT_BBI_TAG) {
        [self backToForwardVC];
    }
    if (btn.tag==RESET_PASSWORD_TAG) {
        [self resignAllFiled];
        
        if ([self isAbleToSendRequest]) {
            [self sendRequest];
        }
    }
}
#pragma mark - resign
-(void)resignAllFiled{
    UITextField *newPassword = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
    UITextField *ensurepassWord = (UITextField *)[self.view viewWithTag:ENSURE_PASSWORD_TAG];
    [newPassword resignFirstResponder];
    [ensurepassWord resignFirstResponder];
}
#pragma mark -isAbleToComplete And sendRequest
-(BOOL)isAbleToSendRequest
{
    UITextField *newPassword = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
    UITextField *ensurepassWord = (UITextField *)[self.view viewWithTag:ENSURE_PASSWORD_TAG];
    //UITextField *veritify=(UITextField *)[self.view viewWithTag:VERITIFY_CODE_TEXTVIEW_TAG];
    
    if (newPassword.text.length==0 || ensurepassWord.text.length==0 ) {
        [self show_check_phone_info:@"信息填写不完整"];
        return NO;
        
    }
    if ([newPassword.text isEqualToString:ensurepassWord.text]==NO) {
        [self show_check_phone_info:@"密码和确认密码不一样"];
        return NO;
    }
    return YES;
}
#pragma mark-replaceAlertView
- (void) show_check_phone_info:(NSString *)_str{
   // [MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:kTipsTopOffset image:nil];

}
#pragma mark-sendRequest
-(void)sendRequest{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
     UITextField *newPassword = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
    int type=0;
    if (self.veritifyType==MMIUserTypeEmail) {
        type=1;
        //逻辑还未明白
        [self show_check_phone_info:@"请去登录邮箱修改"];
    }
    if (self.veritifyType==MMIUserTypePhoneNumber) {
        type=0;
    }
    
    
    [app.mmiaDataEngine testGetPassWordAndSetNewPassWordUser:self.phoneOrEmailText newPassWord:newPassword.text retriveType:0 completionHandler:^(NSDictionary *jsonObject){
        if ([jsonObject[@"result"]intValue]==0) {
            [self show_check_phone_info:@"修改密码成功"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }errorHandler:^(NSError *error){
        [self show_check_phone_info:@"修改密码失败"];
    }];
    
    
}

#pragma mark - initUI

/*
 @param  textfield的tag值
 @descripation  判断输入框是否设置为加密输入模式
 */
- (BOOL)setSecureTextEntryOrOntWithTextFieldTag:(NSInteger)tag
{
    if (tag==VERITIFY_CODE_TEXTVIEW_TAG) {
        return NO;
    }
    return YES;
    
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
  
    [_bgView addSubview:view];
}

/*
 @param   nil
 @descripation  加载导航视图
 */
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
    [self.leftBarButton setImage:[UIImage imageNamed:@"login_02"] forState:UIControlStateNormal];
    [self.leftBarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = @"设置新密码";
    self.titleLabel.textColor = UIColorFromRGB(0xCE212A);
    
}


/*
 @param   nil
 @descripation  加载主视图
 */

- (void)loadBgView
{
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, SCREEN_WIDTH, SCREEN_HEIGHT-20-TABLE_BAR_HEIGHT-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    
    //添加logo
    NSLog(@"%f",SCREEN_WIDTH/2.0f);
    
    //添加信息输入栏
    [self initEditUIWithTitleName:@"新密码" andEditTextImage:@"login_ico_activation" andTextFieldTag:NEW_PASSWORD_TAG andFrame:CGRectMake(10, 10,_bgView.frame.size.width-20 ,44)];
    
    [self initEditUIWithTitleName:@"确认密码" andEditTextImage:@"login_ico_password" andTextFieldTag:ENSURE_PASSWORD_TAG andFrame:CGRectMake(10, 58,_bgView.frame.size.width-20 ,44)];
    /*
     因页面发生变化，增加验证码
     
     */
    //验证码
    
   // [self initEditUIWithTitleName:@"验证码" andEditTextImage:@"login_ico_password" andTextFieldTag:VERITIFY_CODE_TEXTVIEW_TAG andFrame:CGRectMake(10, 106,_bgView.frame.size.width-20, 44)];
    
    
    
    
    UIButton *btn = [MMiaCommonUtil initializeButtonWithFrame:CGRectMake(10, 122, _bgView.frame.size.width-20, 44) title:@"完成" titleFont:[UIFont systemFontOfSize:15] titleColor:nil backgroundImageNamed:@"login_04@2x" image:nil andSuperView:_bgView andBtnTag:RESET_PASSWORD_TAG];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _isResetPassword = NO;
    [self loadBgView];
    [self loadNavView];
    NSLog(@"%@",_bgView.subviews);
    
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
    
    UITextField *newPassword = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
    UITextField *ensurepassWord = (UITextField *)[self.view viewWithTag:ENSURE_PASSWORD_TAG];
    UITextField *veritify=(UITextField *)[self.view viewWithTag:VERITIFY_CODE_TEXTVIEW_TAG];
    [newPassword resignFirstResponder];
    [ensurepassWord resignFirstResponder];
    [veritify resignFirstResponder];
    //    [textField endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
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
