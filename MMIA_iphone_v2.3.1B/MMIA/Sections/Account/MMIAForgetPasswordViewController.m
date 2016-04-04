//
//  MMIAForgetPasswordViewController.m
//  MMIA
//
//  Created by Vivian's Office MAC on 14-5-30.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIAForgetPasswordViewController.h"
#import "MMIAVeritifyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MMIJudgeTypeUtil.h"

#import "MMIAPassSucViewController.h"



#import "MMiaCommonUtil.h"

//弹出框
#import "MMIToast.h"
#import "MMIProcessView.h"


#define RIGHT_BBI_TAG 1
#define LEFT_BBI_TAG 2

#define EMAIL_PHONE_NUMBER_TAG 11
#define VERITIFY_CODE_TAG 12

#define NEXT_STEP_BTN_TAG 20

#define EMAIL_PROMOT_TAG 21



@interface MMIAForgetPasswordViewController ()

@end

@implementation MMIAForgetPasswordViewController
{
    UIView *_bgView;
    UITextField *_mailTextField;
    UITextField *_userNameTextField;
    UITextField *_passWordTextField;
    BOOL _isRegist;
    
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
 @descripation  （检查输入是否完整）
 */
- (BOOL)canReset
{
    UITextField *emailOrPhoneNumberText = (UITextField *)[self.view viewWithTag:EMAIL_PHONE_NUMBER_TAG];
    UITextField *veritifyCodeText = (UITextField *)[self.view viewWithTag:VERITIFY_CODE_TAG];
    if (_isRegist==NO) {
        if (emailOrPhoneNumberText.text.length!=0&&veritifyCodeText.text.length!=0) {
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
 @descripation
 */
- (void)reset
{
    
    if ([self canReset]) {
        UITextField *emailOrPhoneNumberText = (UITextField *)[self.view viewWithTag:EMAIL_PHONE_NUMBER_TAG];
        UITextField *veritifyCodeText = (UITextField *)[self.view viewWithTag:VERITIFY_CODE_TAG];
        
        NSString *url = nil;
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //add code...for regist
        [emailOrPhoneNumberText resignFirstResponder];
        [veritifyCodeText resignFirstResponder];
    }
}
#pragma mark -setRequest
-(void)sendRequest{
   MMIAPassSucViewController *mpvc=[[MMIAPassSucViewController alloc]init];
    int type=0;
     UITextField *textField = ((UITextField *)[_bgView viewWithTag:EMAIL_PHONE_NUMBER_TAG]);
    if ([MMIJudgeTypeUtil isPhoneNumber:textField.text]) {
       
        type=0;
    }
    if ([MMIJudgeTypeUtil isEmailNumber:textField.text]) {
        
        type=1;
    }
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.mmiaDataEngine testGetPassWordRequest:textField.text retrive:type completionHandler:^(NSDictionary *jsonObject){
        
        //发送成功
        if ([jsonObject[@"result"] intValue]==0) {
            
            
           
            [self.navigationController pushViewController:mpvc animated:YES];
        }
        
    }errorHandler:^(NSError *error){
        if (app.mmiaDataEngine.isReachable==NO) {
            [self show_check_phone_info:@"没有网络连接"];
           
            
        }else{
            [self show_check_phone_info:@"网络不给力，请稍后重试"];
                    }

    }];
    
   
    
    
    
    
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
    if (NEXT_STEP_BTN_TAG == btn.tag) {
        [self TextFiledFirstResign];
        
        if ([self isAbleToNext]) {
            /*
            MMIAVeritifyViewController *mvvc = [[MMIAVeritifyViewController alloc]init];
            mvvc.phoneOrEmailText=textField.text;
            if ([MMIJudgeTypeUtil isEmailNumber:textField.text]) {
                mvvc.veritifyType=MMIAVeritifyTypeEmail;
            }
            if ([MMIJudgeTypeUtil isPhoneNumber:textField.text]) {
                mvvc.veritifyType=MMIAVeritifyTypePhoneNumber;
            }
            
            [self.navigationController pushViewController:mvvc animated:YES];*/
            [self sendRequest];
        }
        
        
       
    }
}




-(BOOL)isAbleToNext{
    UITextField *userName = (UITextField *)[_bgView viewWithTag:EMAIL_PHONE_NUMBER_TAG];
    if (userName.text.length==0) {
       // [self alertviewTitle:@"跳转失败" message:@"邮箱/手机号不能为空"];
        [self show_check_phone_info:@"邮箱/手机号不能为空"];
        return NO;
    }
    if ([MMIJudgeTypeUtil isEmailNumber:userName.text]==NO && [MMIJudgeTypeUtil isPhoneNumber:userName.text]==NO) {
        //[self alertviewTitle:@"跳转失败" message:@"请输入正确的手机号或邮箱"];
        [self show_check_phone_info:@"请输入正确的手机号或邮箱"];
        return NO;
    }
    /*
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    if (![ud objectForKey:userName.text]){
        //[self alertviewTitle:@"验证失败" message:@"手机（邮箱）未验证"];
        [self show_check_phone_info:@"手机（邮箱）未验证"];
        return NO;
    }
     */
    return YES;

    
    
}
#pragma mark-resign
-(void)TextFiledFirstResign{
   UITextField *userName = (UITextField *)[self.view viewWithTag:EMAIL_PHONE_NUMBER_TAG];
    [userName resignFirstResponder];
    
    
}

#pragma mark-AlertView
-(void)alertviewTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
}


- (void) show_check_phone_info:(NSString *)_str{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:kTipsTopOffset image:nil];
    
}




#pragma mark - initUI


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
    [MMiaCommonUtil initializeTextFieldWithFrame:CGRectMake(20, (frame.size.height-30)/2.0f, frame.size.width-20, 30) andTag:textFieldTag andPlaceholder:titleName  andSecureTextEntry:NO andSuperView:view];
    //    UITextField *text = (UITextField *)[view viewWithTag:textFieldTag];
    //    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithName:editImage]];
    //    imageView.frame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
    //    text.leftViewMode = UITextFieldViewModeAlways;
    //    text.leftView = imageView;
    //    MMIA_RELEASE(imageView);
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
    self.leftBarButton.frame = CGRectMake(0, VIEW_OFFSET, 55, self.navigationView.frame.size.height-VIEW_OFFSET);
    [self.leftBarButton setImage:[UIImage imageNamed:@"login_02"] forState:UIControlStateNormal];
    [self.leftBarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = @"忘记密码";
    self.titleLabel.textColor = UIColorFromRGB(0xCE212A);
    
}




- (void)loadBgView
{
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, SCREEN_WIDTH, SCREEN_HEIGHT-20-TABLE_BAR_HEIGHT-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    
    //添加logo
    NSLog(@"%f",SCREEN_WIDTH/2.0f);
    
    
    [MMiaCommonUtil initializeLabelWithFrame:CGRectMake(10, 10, _bgView.frame.size.width-20, 30) text:@"使用已注册的邮箱或手机号找回密码" textFont:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] textAlignment:MMIATextAlignmentLeft andbgColor:[UIColor clearColor] andSuperView:_bgView andTag:0];
    
    //添加信息输入栏
    [self initEditUIWithTitleName:@"邮箱/手机号" andEditTextImage:@"login_ico_activation" andTextFieldTag:EMAIL_PHONE_NUMBER_TAG andFrame:CGRectMake(10, 40,_bgView.frame.size.width-20 ,44)];
    /*
    [self initEditUIWithTitleName:@"验证码" andEditTextImage:@"login_ico_password" andTextFieldTag:VERITIFY_CODE_TAG andFrame:CGRectMake(10, 98,116 ,44)];
    
    [MMiaCommonUtil initializeImageViewWithFrame:CGRectMake(140, 96, 120, 44) imageNamed:@"login_04@2x" andSuperView:_bgView andTag:0];
    //add code for imageview
    */
    
    
   
    
    UIButton *btn = [MMiaCommonUtil initializeButtonWithFrame:CGRectMake(10, 100, _bgView.frame.size.width-20, 44) title:@"下一步" titleFont:[UIFont systemFontOfSize:15] titleColor:nil backgroundImageNamed:@"login_04@2x" image:nil andSuperView:_bgView andBtnTag:NEXT_STEP_BTN_TAG];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //添加邮箱输入时的view
    UITextField *textField = ((UITextField *)[_bgView viewWithTag:EMAIL_PHONE_NUMBER_TAG]);
    textField.delegate=self;

    MMIEmailPrompt *emailPromotView=[[MMIEmailPrompt alloc]initWithFrame:CGRectMake(textField.frame.origin.x-10, textField.frame.origin.y+textField.frame.size.height+45, textField.frame.size.width+21, 120)];
    emailPromotView.emailDelegate=self;
    emailPromotView.hidden=YES;
    emailPromotView.tag=EMAIL_PROMOT_TAG;
    [_bgView addSubview:emailPromotView];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _isRegist = NO;
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
    MMIEmailPrompt *emailPromptView=(MMIEmailPrompt *)[_bgView viewWithTag:EMAIL_PROMOT_TAG];
    emailPromptView.hidden=YES;
    
    UITextField *textField = ((UITextField *)[_bgView viewWithTag:EMAIL_PHONE_NUMBER_TAG]);
    [textField resignFirstResponder];
    textField = ((UITextField *)[_bgView viewWithTag:VERITIFY_CODE_TAG]);
    [textField resignFirstResponder];
 
    //    [textField endEditing:YES];
}

#pragma mark-TextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    UITextField *mail = (UITextField *)[self.view viewWithTag:REGIST_EMAIL_TAG];
    UITextField *userName = (UITextField *)[self.view viewWithTag:EMAIL_PHONE_NUMBER_TAG];
    UITextField *password = (UITextField *)[self.view viewWithTag:VERITIFY_CODE_TAG];
    
    if (userName == textField) {
        password.text = nil;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   UITextField *phoneTextField = ((UITextField *)[_bgView viewWithTag:EMAIL_PHONE_NUMBER_TAG]);
     MMIEmailPrompt *emailPromptView=(MMIEmailPrompt *)[_bgView viewWithTag:EMAIL_PROMOT_TAG];
    if (textField==phoneTextField) {
        
        if ([string isEqualToString:@"@"]) {
             NSMutableString *str=[NSMutableString stringWithFormat:@"%@@",phoneTextField.text];
            [emailPromptView reinitDataArray:str];
            [emailPromptView.tableView reloadData];
            [emailPromptView setHidden:NO];
            
        }
    }
    return YES;
    
    
}


#pragma mark-MMIEmailPromptDelegate
-(void)sendSelectCellStr:(NSString *)str{
   UITextField *phoneTextField = ((UITextField *)[_bgView viewWithTag:EMAIL_PHONE_NUMBER_TAG]);
   // NSMutableString *mutabMailTextStr=[NSMutableString stringWithString:phoneTextField.text];
   // [mutabMailTextStr appendString:str];
   phoneTextField.text=str;
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
