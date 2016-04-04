//
//  MMIAVeritifyViewController.m
//  MMIA
//
//  Created by Vivian's Office MAC on 14-5-30.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIAVeritifyViewController.h"
#import "MMIASetNewPassWordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MMiaCommonUtil.h"
#import "MMIJudgeTypeUtil.h"

#import "MMIToast.h"


#define RIGHT_BBI_TAG 1
#define LEFT_BBI_TAG 2

#define VERITIFY_CODE_TEXTVIEW_TAG 10
#define SEND_VERITIFY_CODE_TAG 20

@interface MMIAVeritifyViewController ()

@end

@implementation MMIAVeritifyViewController
{
    UIView *_bgView;
    UILabel *_inforLabel;

}
@synthesize veritifyType = _veritifyType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
#pragma mark-timer

-(void)changeButtonTitle{
   
    [DEFAULTS setBool:YES forKey:@"BtnEnabled"];
    
    
    _timerCount=60;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimerShowInVerBtn) userInfo:nil repeats:YES];
}

-(void)setTimerShowInVerBtn{
   UIButton *btn = (UIButton *)[self.view viewWithTag:SEND_VERITIFY_CODE_TAG];
    
    _timerCount--;
    if (_timerCount==-1) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer=nil;
        }
        [DEFAULTS setBool:NO forKey:@"BtnEnabled"];
        
        [btn setTitle:@"重新发送" forState:UIControlStateNormal];
        return;
    }
    [btn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timerCount] forState:UIControlStateNormal];
}



- (void)countForResendNews
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       __block int i=60;
        while (i>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *btn = (UIButton *)[self.view viewWithTag:SEND_VERITIFY_CODE_TAG];
                [btn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",i--] forState:UIControlStateNormal];
                if (i==0) {
                    [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                }
            });
            sleep(1);
        }
    });
    
}
/*
 @param   nil
 @descripation  按钮点击事件
 */
- (void)btnClick:(UIButton *)btn
{
    if (LEFT_BBI_TAG == btn.tag ) {
        [self backToForwardVC];
    }else if (RIGHT_BBI_TAG == btn.tag){
        UITextField *textField = ((UITextField *)[_bgView viewWithTag:VERITIFY_CODE_TEXTVIEW_TAG]);
        if (textField.text.length==0) {
            [self show_check_phone_info:@"验证码输入为空"];
            return;
        }
        //无法判断验证码是否有无
        /**************************/
        MMIASetNewPassWordViewController *svc = [[MMIASetNewPassWordViewController alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }else if(SEND_VERITIFY_CODE_TAG == btn.tag){
        if ([btn.titleLabel.text isEqualToString:@"重新发送"]==YES){
            [self changeButtonTitle];
            [self sendRequest];
        }
        
        //[self countForResendNews];
        
    }
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
    [MMiaCommonUtil initializeTextFieldWithFrame:CGRectMake(20, (frame.size.height-30)/2.0f, frame.size.width-20, 30) andTag:textFieldTag andPlaceholder:titleName  andSecureTextEntry:NO andSuperView:view];
    
    [_bgView addSubview:view];
}


#pragma mark -setRequest
-(void)sendRequest{
    int type=0;
    
    if ([MMIJudgeTypeUtil isPhoneNumber:self.phoneOrEmailText]) {
        type=0;
    }
    if ([MMIJudgeTypeUtil isEmailNumber:self.phoneOrEmailText]) {
        type=1;
    }
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.mmiaDataEngine testGetPassWordRequest:self.phoneOrEmailText retrive:type completionHandler:^(NSDictionary *jsonObject){
        //发送成功
        if ([jsonObject[@"result"] intValue]==0) {
            [self show_check_phone_info:@"验证码已发送"];
            
            
                    }
        
    }errorHandler:^(NSError *error){
        NSLog(@"找回密码error");
    }];
    
    
    
    
    
    
}

#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:kTipsTopOffset image:nil];

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
    
    
    self.leftBarButton.tag = LEFT_BBI_TAG;
    self.leftBarButton.frame = CGRectMake(0, VIEW_OFFSET, 55, self.navigationView.frame.size.height-VIEW_OFFSET);
    [self.leftBarButton setImage:[UIImage imageNamed:@"login_02@2x"] forState:UIControlStateNormal];
    [self.leftBarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.rightBarButton.tag = RIGHT_BBI_TAG;
    self.rightBarButton.frame = CGRectMake(self.navigationView.frame.size.width-20-44,self.navigationView.frame.size.height-33, 44, 22);
    [self.rightBarButton setImage:[UIImage imageNamed:@"login_08@2x"] forState:UIControlStateNormal];
    [self.rightBarButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [MMiaCommonUtil initializeLabelWithFrame:self.rightBarButton.bounds text:@"确定" textFont:[UIFont systemFontOfSize:12] textColor:[UIColor whiteColor] textAlignment:MMIATextAlignmentCenter andbgColor:[UIColor clearColor] andSuperView:self.rightBarButton andTag:0];
    [self.rightBarButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.rightBarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    self.titleLabel.text = self.veritifyType==MMIAVeritifyTypePhoneNumber?@"手机号验证":@"邮箱验证";
    
    self.titleLabel.textColor = UIColorFromRGB(0xCE212A);
    
}
/*
 @param   nil
 @descripation  加载主视图
 */
- (void)loadBgView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, SCREEN_WIDTH, SCREEN_HEIGHT-20-TABLE_BAR_HEIGHT-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    
    _inforLabel = [MMiaCommonUtil initializeLabelWithFrame:CGRectMake(10, 10, _bgView.frame.size.width-20, 40) text:nil textFont:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] textAlignment:MMIATextAlignmentLeft andbgColor:[UIColor clearColor] andSuperView:_bgView andTag:0];
    if (MMIAVeritifyTypePhoneNumber==self.veritifyType) {
       // _inforLabel.text = @"短信验证码已经发送到:\n13988888888";
        
        _inforLabel.text=[NSString stringWithFormat:@"短信验证码已经发送到:\n%@",self.phoneOrEmailText];
    }else{
        //_inforLabel.text = @"邮箱验证码已经发送到:\nyangshuai@hotmail.com";
        _inforLabel.text=[NSString stringWithFormat:@"邮箱验证码已经发送到:\n%@",self.phoneOrEmailText];
    }
    
    
    //116 174
    [self initEditUIWithTitleName:@"验证码" andEditTextImage:nil andTextFieldTag:VERITIFY_CODE_TEXTVIEW_TAG andFrame:CGRectMake(10, 10+40, 116, 44)];
    
    
     UIButton *btn = [MMiaCommonUtil initializeButtonWithFrame:CGRectMake(136, 10+40, 174, 44) title:@"重新发送" titleFont:nil imageNamed:@"login_05@2x" andSuperView:_bgView andBtnTag:SEND_VERITIFY_CODE_TAG];

     [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavView];
    [self loadBgView];
    // Do any additional setup after loading the view.
}

/*
 @param   nil
 @descripation  取消textField的第一相应
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITextField *textField = ((UITextField *)[_bgView viewWithTag:VERITIFY_CODE_TEXTVIEW_TAG]);
    [textField resignFirstResponder];
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
