//
//  MmiaSettingViewController.m
//  MmiaHD
//
//  Created by lixiao on 15/3/31.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaSettingViewController.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>

#define WIDTH               (self.isPortrait?768.0:1024.0)
#define HEIGHT              (self.isPortrait?1024.0:768.0)

typedef enum {
    man,
    woman
}MmiaSex;

@interface MmiaSettingViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate>
{
    LoginInfoItem  *_item;
    NSArray *_sexArray;
    id _target;
    SEL LogOutSuccessAction;
    BOOL isPortrait;
    BOOL _isUp;
    BOOL              _isPopover;
//    NSInteger gender;
}
@property (nonatomic, retain) UIPopoverController       *poc;
@property (nonatomic, retain) UIPopoverPresentationController *popOverC;
@property (nonatomic, retain) UIImagePickerController   *cameraPicker;
@property (nonatomic, retain) UIImagePickerController   *photoPicker;
@property (nonatomic, retain) UIButton                  *pickPbtton;

@end

@implementation MmiaSettingViewController




- (id)initWithLoginItem:(LoginInfoItem *)item
{
    self = [super init];
    if (self)
    {
        _item = item;
    }
    return self;
}
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

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    int gender;
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (self.sex.text) {
        if ([self.sex.text  isEqual: @"男"]) {
            gender = man;
        }else if ([self.sex.text  isEqual: @"女"] ){
            gender = woman;
        }
    }
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userid",userTicket,@"ticket",self.nikeName.text,@"nickname",[NSNumber numberWithInt:gender],@"gender",self.signature.text,@"description", nil];
    MmiaProcessView *processView=[[MmiaProcessView alloc]initWithMessage:@"资料修改中,请稍后...." top:Main_Screen_Height-60];
    processView.tag=PROCESS_VIEW_TAG;
    [processView showInRootView:self.view];
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_MODIFY_PERSONAL_INFO_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *response) {
        if ([response[@"result"]intValue]==0) {
            _item.nikeName = self.nikeName.text;
            _item.sex = gender;
            _item.signature = self.signature.text;
            
            
            
            // 发送通知，通知刷新 lx change
            //[DefaultNotificationCenter postNotificationName:PersonalInfo_Notification_Key object:self];
            [DefaultNotificationCenter postNotificationName:PersonalInfo_Notification_Key object:nil userInfo:[NSDictionary dictionaryWithObject:_item forKey:@"loginItem"]];
            
            [self show_check_phone_info:@"资料设置成功" image:nil];

        }else{
            [self show_check_phone_info:response[@"message"] image:nil];
        }
        [processView dismiss];

    } errorHandler:^(NSError *error) {
        if ([app.mmiaNetworkEngine isReachable]==NO)
        {
            [self show_check_phone_info:@"没有网络连接" image:nil];
        }else
        {
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
            
        }
        [processView dismiss];
    }];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"%lf",self.contentView.frame.size.height);
    [self createUI];


    
    // Do any additional setup after loading the view.
}

-(void)setTarget:(id)tar withLogOutSuccessAction:(SEL)action
{
   
}

-(void)createUI{
    NSArray *sexArr = @[@"男",@"女"];
    _sexArray = @[sexArr];
//    _backgroudView = [[UIView alloc]initWithFrame:self.contentView.bounds];
    _backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    _backgroudView.backgroundColor = ColorWithHexRGB(0xf9f9f7);
    [self.contentView addSubview:_backgroudView];
    NSArray *nameArr = @[@"昵称",@"性别",@"个人介绍"];
    NSArray *bntTitleArray = @[@"修改密码",@"意见反馈",@"清除缓存",@"退出登录"];
    
    //头像
    
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(768/2-Setting_ImageView_D/2-85, Setting_Top_gap-5, Setting_ImageView_D-15, Setting_ImageView_D-15)];
    _headImageView.backgroundColor = [UIColor clearColor];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *concernTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_headImageView addGestureRecognizer:concernTap];
//    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_item.headImageUrl] placeholderImage:[UIImage imageNamed:@"personalcenter_DefaultPersonPic.png"]];
    _headImageView.image = _item.headImage;
     _headImageView.layer.cornerRadius = (CGRectGetHeight(_headImageView.frame))/2.0 ;
    [self.contentView addSubview:_headImageView];
    
    //上传头像
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 15)];
    label.center = CGPointMake(CGRectGetMidX(_headImageView.frame), CGRectGetMaxY(_headImageView.frame)+14);
    label.text = @"上传头像";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:label];
    
    //昵称UI，性别，个人介绍
    for (NSInteger i = 0; i<7; i++) {
    UIView *background = [[UIView alloc]initWithFrame:CGRectMake(((_backgroudView.frame.size.width-170)-Setting_Weight)/2,Setting_Top_gap+Setting_ImageView_D+Setting_Min_gap+(Setting_Height+2)*i, Setting_Weight , Setting_Height)];
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
            [background addSubview:textField];
            if (i == 1) {
                UIPickerView *sexPickview = [[UIPickerView alloc]init];
                textField.inputView = sexPickview;
                textField.clearButtonMode = UITextFieldViewModeNever;
                sexPickview.delegate = self;
                sexPickview.dataSource = self;
            }
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(Setting_Label_LeftGap, 0, 120, 46)];
            nameLabel.text = nameArr[i];
            nameLabel.font = [UIFont systemFontOfSize:Setting_FontSize];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [background addSubview:nameLabel];
        }else{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.tag = Setting_Tag +i;
            button.frame = CGRectMake(26,5,380,36);
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:bntTitleArray[i-3] forState:UIControlStateNormal];
            
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
            button.titleLabel.font = [UIFont systemFontOfSize:Setting_FontSize];
            [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            if(i == 6){
                button.backgroundColor = ColorWithHexRGB(0xF21E3B);
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
            }
            [background addSubview:button];
        }
        if (i == 0 ) {
            UITextField *textField = (UITextField *)[self.view viewWithTag:Setting_Tag +i];
            self.nikeName = textField;
            if (_item.nikeName) {
                self.nikeName.text = _item.nikeName;
            }
        }
        if (i == 1 ) {
            UITextField *textField = (UITextField *)[self.view viewWithTag:Setting_Tag +i];
            self.sex = textField;
            if (_item.sex == 0) {
                self.sex.text = sexArr[0];
            }else if (_item.sex == 1)
                self.sex.text = sexArr[1];
        }
        if (i == 2 ) {
            UITextField *textField = (UITextField *)[self.view viewWithTag:Setting_Tag +i];
            self.signature = textField;
            if (_item.signature) {
                self.signature.text = _item.signature;
            }
        }
    
    }
}

//修改密码，意见反馈，清除缓存点击事件


-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 4) {
        NSLog(@"修改密码");
        MmiaChangePasswordViewController *changePasswordView = [[MmiaChangePasswordViewController alloc]init];
        self.rightStackViewController = changePasswordView;
    }
    if (btn.tag == 5) {
        NSLog(@"意见反馈");
        MmiaFeedBackViewController *feedBackView = [[MmiaFeedBackViewController alloc]init];
        self.rightStackViewController = feedBackView;
    }
    if (btn.tag == 6) {
        NSLog(@"清除缓存");
        [self show_check_phone_info:@"清楚缓存成功" image:nil];
        return;
    }
    if (btn.tag == 7) {
        NSLog(@"退出登录");
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"确定退出广而告之?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil, nil];
        alvertView.tag=EXIT_ALERTVIEW_TAG;
        [alvertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==EXIT_ALERTVIEW_TAG)
    {
        if (buttonIndex == 1)
        {
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:@"" forKey:USER_ID];
            [defaults setObject:@"" forKey:USER_TICKET];
            [defaults setBool:NO forKey:USER_IS_LOGIN];
            [defaults setObject:@"" forKey:@"userType"];
            [defaults synchronize];
            [DefaultNotificationCenter postNotificationName:BackToMainView_Notification_Key object:self];
        }
    }
}

//图片头像点击事件
-(void)tapClick{
    self.cameraPicker = [[UIImagePickerController alloc]init];
    self.cameraPicker.delegate = self;
    self.cameraPicker.allowsEditing = YES;
    
    self.pickPbtton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 102 , HEIGHT - 200, 102, 68)];
//    self.pickPbtton.backgroundColor = [UIColor redColor];
    [self.pickPbtton addTarget:self action:@selector(bttonClick:) forControlEvents:UIControlEventTouchUpInside];
     [self.pickPbtton setTitle:@"图库" forState:UIControlStateNormal];
    
    self.cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraPicker.cameraOverlayView = self.pickPbtton;
    
    if (iOS8Later)
    {
        self.cameraPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:self.cameraPicker animated:YES completion:^{
            [self doPickerVCFinishShow];
        }];
        
    }else
    {
        self.cameraPicker.view.top += HEIGHT;
        self.cameraPicker.view.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
        [self.navigationController.view addSubview:self.cameraPicker.view];
        [UIView animateWithDuration:0.2 animations:^{
            self.cameraPicker.view.top = 0;
        }completion:^(BOOL finfished){
            if (finfished)
            {
                [self doPickerVCFinishShow];
            }
        }];
        [self.navigationController addChildViewController:self.cameraPicker];
        [UIView commitAnimations];
    }


}

- (void)bttonClick:(id)sender
{
    self.photoPicker = [[UIImagePickerController alloc]init];
    self.photoPicker.delegate = self;
    self.photoPicker.allowsEditing = YES;
    self.photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _isPopover = YES;
    if (iOS8Later) {
        
        self.photoPicker.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popPc = self.photoPicker.popoverPresentationController;
        popPc.sourceView = [(UIView *)sender superview];
        CGRect rect = [(UIView *)sender frame];
        rect = CGRectMake(rect.origin.x, rect.origin.y-10, rect.size.width, rect.size.height);
        popPc.sourceRect = rect;
        popPc.permittedArrowDirections = UIPopoverArrowDirectionRight;
        self.popOverC = popPc;
        
        [self.cameraPicker presentViewController:self.photoPicker animated:YES completion:nil];
        
    }else
    {
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:self.photoPicker];
        self.poc = popoverController;
        popoverController.delegate = self;
        CGRect rect = [(UIView *)sender frame];
        rect = CGRectMake(rect.origin.x, rect.origin.y-15, rect.size.width, rect.size.height);
        [popoverController presentPopoverFromRect:rect inView:[(UIView *)sender superview] permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}

//pickerVC 显示后方法

- (void)doPickerVCFinishShow
{
    BOOL isCameraValid = YES;
    
    if (iOS7Later)
    {
        AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorStatus != AVAuthorizationStatusAuthorized)
        {
            isCameraValid = NO;
        }
    }
    
    if (isCameraValid == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请在iPhone的“设置-隐私-相机”选项中，允许广而告之访问你的相机。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self sendImageRequestWithImage:image];
    
    [self dismissPickVCWithImagePickerController:self.photoPicker];
    [self dismissPickVCWithImagePickerController:self.cameraPicker];
    _isPopover =  NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    _isPopover = NO;
    [self dismissPickVCWithImagePickerController:self.cameraPicker];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setRightBarButtonItem:nil animated:NO];
}

//pickvc 收起的动画效果
- (void)dismissPickVCWithImagePickerController:(UIImagePickerController *)picker
{
    if ([picker respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        
        [self removeFromSuperViewWithPickerController:picker];
        
    }else if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        
        [self removeFromSuperViewWithPickerController:picker];
    }
}

- (void)removeFromSuperViewWithPickerController:(UIImagePickerController *)picker
{
    if (iOS8Later)
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [self.poc dismissPopoverAnimated:NO];
        [UIView animateWithDuration:0.2 animations:^{
            picker.view.top += HEIGHT;
        }completion:^(BOOL finished){
            if (finished)
            {
                [picker willMoveToParentViewController:nil];
                [picker removeFromParentViewController];
                [picker.view removeFromSuperview];
                picker.view = nil;
            }
        }];
    }
}

//图片修改网络请求
- (void)sendImageRequestWithImage:(UIImage *)image
{
    UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
    NSData *data = UIImageJPEGRepresentation(newImage, 0.8);
    NSInteger userId = [[StandardUserDefaults objectForKey:USER_ID]integerValue];
    NSString *userTicket = [StandardUserDefaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
    NSString *pictureDataString = [data base64Encoding];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:userId],@"userid",userTicket,@"ticket",pictureDataString,@"imageStream", nil];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_UploadHeaderPic_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]integerValue] == 0)
        {
            self.headImageView.image = newImage;
            //lx add
            _item.headImage = newImage;
            
            [MmiaToast showWithText:@"修改头像成功" topOffset:Main_Screen_Height - 20 image:nil];
        }else
        {
            [MmiaToast showWithText:@"修改头像失败" topOffset:Main_Screen_Height - 20 image:nil];
        }
        
    }errorHandler:^(NSError *error){
        [MmiaToast showWithText:@"修改头像失败" topOffset:Main_Screen_Height - 20 image:nil];
    }];
}

//剪裁图片
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}





#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MmiaToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}


#pragma mark -pickerView
//picker中组的个数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//每一部分的行数
//section == componect
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

//自定义每行显示的view
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _sexArray[component][row];
}

//当选中某一行时，执行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UITextField *sexTextField = (UITextField *)[self.view viewWithTag:2];
    sexTextField.text = _sexArray[component][row];
//    sexTextField.text = [NSString stringWithFormat:@"%@",_sexArray[component][row]];
    sexTextField.text = _sexArray[component][row];
//    [sexTextField reloadInputViews];
}


#pragma mark -textField

- (void)resignAllResponder
{
    [self.nikeName resignFirstResponder];
    [self.sex resignFirstResponder];
    [self.signature resignFirstResponder];
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
    [self resignAllResponder];
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
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (_isUp)
    {
        [self restoreLocation];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.signature == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 138) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:138];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    if (self.nikeName == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 20) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"昵称不能超过20个字符" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
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
    self.pickPbtton.frame = CGRectMake(WIDTH - 102, HEIGHT - 200, 102, 68);
    if (_isPopover == NO)
    {
        return;
    }
    if (iOS8Later)
    {
        self.popOverC.sourceView = self.pickPbtton.superview;
        CGRect rect = self.pickPbtton.frame;
        rect = CGRectMake(rect.origin.x, rect.origin.y-10, rect.size.width, rect.size.height);
        self.popOverC.sourceRect = rect;
        self.popOverC.permittedArrowDirections = UIPopoverArrowDirectionRight;
    }else
    {
        CGRect rect = [(UIView *)self.pickPbtton frame];
        rect = CGRectMake(rect.origin.x, rect.origin.y-15, rect.size.width, rect.size.height);
        [self.poc presentPopoverFromRect:rect inView:[(UIView *)self.pickPbtton superview] permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
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
