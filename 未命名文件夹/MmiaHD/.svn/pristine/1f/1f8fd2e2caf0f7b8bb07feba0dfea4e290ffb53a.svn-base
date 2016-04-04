//
//  MmiaChangePasswordViewController.m
//  MmiaHD
//
//  Created by twksky on 15/4/8.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaChangePasswordViewController.h"

@interface MmiaChangePasswordViewController ()<UITextFieldDelegate>
{
    BOOL isPortrait;
    BOOL _isUp;
}
@end

@implementation MmiaChangePasswordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
    {
        isPortrait = YES;
    }else
        isPortrait = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
    
}

-(void)createUI{
    UIView *backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    backgroudView.backgroundColor = ColorWithHexRGB(0xf9f9f7);
    [self.contentView addSubview:backgroudView];
    
    NSArray *nameArr = @[@"旧密码",@"新密码",@"确认密码"];
    //
    for (NSInteger i = 0; i<4; i++) {
        UIView *background = [[UIView alloc]initWithFrame:CGRectMake(((backgroudView.frame.size.width-170)-Setting_Weight)/2,Setting_Top_gap+Setting_ImageView_D+Setting_Min_gap+(Setting_Height+2)*i, Setting_Weight , Setting_Height)];
        background.userInteractionEnabled = YES;
        background.backgroundColor= [UIColor whiteColor];
        [self.contentView addSubview:background];
        if (i<3) {
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, background.frame.size.width-120*2, Setting_Height)];
            textField.tag = Setting_Tag + i;
            textField.delegate = self;
            textField.returnKeyType = UIReturnKeyNext;
            //    textField.backgroundColor = [UIColor clearColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;//UITextFieldViewModeAlways;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.textColor =  ColorWithHexRGB(0x404040);
            textField.font = [UIFont systemFontOfSize:12];
            textField.secureTextEntry = YES;
            [background addSubview:textField];
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(Setting_Label_LeftGap, 0, 120, 46)];
            nameLabel.text = nameArr[i];
            nameLabel.font = [UIFont systemFontOfSize:Setting_FontSize];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [background addSubview:nameLabel];
            if (i == 0 ) {
                UITextField *textField = (UITextField *)[self.view viewWithTag:Setting_Tag +i];
                self.oldPassWord = textField;
                self.oldPassWord.placeholder = @"旧密码";
            }
            if (i == 1 ) {
                UITextField *textField = (UITextField *)[self.view viewWithTag:Setting_Tag +i];
                self.passWord = textField;
                self.passWord.placeholder = @"密码:6位位密码";
            }
            if (i == 2 ) {
                UITextField *textField = (UITextField *)[self.view viewWithTag:Setting_Tag +i];
                self.verifyPassWord = textField;
                self.verifyPassWord.placeholder = @"确认密码";
        }
        }
        if (i == 3) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.tag = Setting_Tag +i;
            button.frame = CGRectMake(26,5,380,36);
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = ColorWithHexRGB(0xF21E3B);
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [background addSubview:button];
        }
    }
}

-(void)btnClick:(UIButton *)btn{
    NSLog(@"确认修改密码");
    if ([self isCanChange]){
        [self resiginAllResponder];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *userTicket=[defaults objectForKey:USER_TICKET];
        if (!userTicket)
        {
            userTicket=@"";
        }
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:userTicket,@"ticket",[self.oldPassWord.text md5],@"oldpassword",[self.passWord.text md5],@"newpassword", nil];
        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_CHANGE_PASSWORD_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *response) {
            if ([[dict objectForKey:@"result"]intValue]==0) {
                [self show_check_phone_info:@"修改密码成功,请重新登录" image:nil];
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [ defaults setBool:NO forKey:USER_IS_LOGIN];
                [defaults setObject:@"" forKey:USER_ID];
                [defaults setObject:@"" forKey:USER_TICKET];
                [defaults synchronize];
                [DefaultNotificationCenter postNotificationName:BackToMainView_Notification_Key object:self];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改成功，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }else
            {
                [self show_check_phone_info:dict[@"message"] image:nil];
                
            }
        } errorHandler:^(NSError *error) {
            if ([app.mmiaNetworkEngine isReachable]==NO)
            {
                [self show_check_phone_info:@"没有网络连接" image:nil];
            }else
            {
                [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
                
            }
            
        }];
        
        
    }
}

#pragma mark -一些判断操作
-(BOOL)isCanChange
{
    if (self.oldPassWord.text.length==0)
    {
        [self show_check_phone_info:@"请输入旧密码" image:nil];
        return NO;
    }
    if (self.passWord.text.length==0)
    {
        [self show_check_phone_info:@"请输入新密码" image:nil];
        return NO;
    }
    if (self.verifyPassWord.text.length==0)
    {
        [self show_check_phone_info:@"请输入确认密码" image:nil];
        return NO;
        
    }
    if (self.passWord.text.length!=6)
    {
        [self show_check_phone_info:@"密码为6-20个字母、数字" image:nil];
        return NO;
    }
    if ([self.passWord.text isEqualToString:self.verifyPassWord.text]==NO)
    {
        [self show_check_phone_info:@"新密码和确认密码不一样" image:nil];
        return NO;
    }
    return YES;
}

#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MmiaToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}


#pragma mark -textField

- (void)resignAllResponder
{
    [self.oldPassWord resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.verifyPassWord resignFirstResponder];
//    if (_isUp)
//    {
//        [self restoreLocation];
//    }
}

//-(void)restoreLocation
//{
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        _isUp=NO;
//    }];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllResponder];
}

-(void)resiginAllResponder
{
    [self.oldPassWord resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.verifyPassWord resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        if (self.passWord.text.length>=6 && ![string isEqualToString:@""])
        {
            return NO;
        }
        
    return YES;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (isPortrait == NO) {
        if ( _isUp==NO )
        {
            [UIView animateWithDuration:0.2 animations:^{
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, -120, self.view.frame.size.width, self.view.frame.size.height)];
                _isUp=YES;
            }];
        }
    }
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (_isUp) {
//        [self restoreLocation];
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    if (_isUp)
//    {
//        [self restoreLocation];
//    }
    return YES;
}

#pragma mark -Rotate
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        // 竖屏
        isPortrait = YES;
    }
    else
    {
        // 横屏
        isPortrait = NO;
        
    }
    
}


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
