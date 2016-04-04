//
//  MmiaSettingViewController.m
//  MmiaHD
//
//  Created by lixiao on 15/3/31.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaSettingViewController.h"

#define Setting_Tag 1

#define Setting_Top_gap 50
#define Setting_ImageView_D 124
#define Setting_Min_gap 14
#define Setting_Bottom_gap 50
#define Setting_Weight 450
#define Setting_Height 46
#define Setting_Label_LeftGap 26

#define Setting_FontSize 12

typedef enum {
    man,
    woman
}MmiaSex;

@interface MmiaSettingViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    LoginInfoItem  *_item;
    NSArray *_sexArray;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];

    
    // Do any additional setup after loading the view.
}

-(void)createUI{
    NSArray *sexArr = @[@"男",@"女"];
    _sexArray = @[sexArr];
    _backgroudView = [[UIView alloc]initWithFrame:self.contentView.bounds];
    _backgroudView.backgroundColor = ColorWithHexRGB(0xf9f9f7);
    [self.contentView addSubview:_backgroudView];
    NSArray *nameArr = @[@"昵称",@"性别",@"个人介绍"];
    
    //昵称UI，性别，个人介绍
    for (NSInteger i = 0; i<3; i++) {
    UILabel *Background = [[UILabel alloc]initWithFrame:CGRectMake(((_backgroudView.frame.size.width-170)-Setting_Weight)/2,Setting_Top_gap+Setting_ImageView_D+Setting_Min_gap+(Setting_Height+2)*i, Setting_Weight , Setting_Height)];
//    nikeNameBackground.layer.borderColor = [[UIColor grayColor] CGColor];
//    nikeNameBackground.layer.borderWidth = 2;
    Background.userInteractionEnabled = YES;
//    nikeNameBackground.backgroundColor= [UIColor redColor];
    [_backgroudView addSubview:Background];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, Background.frame.size.width-120*2, Setting_Height)];
    textField.tag = Setting_Tag + i;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
    textField.backgroundColor = [UIColor clearColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;//UITextFieldViewModeAlways;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textColor =  ColorWithHexRGB(0xffffff);
    textField.font = [UIFont systemFontOfSize:12];
    [Background addSubview:textField];
        if (i == 1) {
            UIPickerView *sexPickview = [[UIPickerView alloc]init];
            textField.inputView = sexPickview;
            sexPickview.delegate = self;
            sexPickview.dataSource = self;
        }
    UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(Setting_Label_LeftGap, 0, 120, 46)];
    NameLabel.backgroundColor = [UIColor clearColor];
    NameLabel.text = nameArr[i];
    NameLabel.font = [UIFont systemFontOfSize:Setting_FontSize];
    NameLabel.textAlignment = NSTextAlignmentLeft;
    [Background addSubview:NameLabel];
    }
    
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
    sexTextField.text = [NSString stringWithFormat:@"%@",_sexArray[component][row]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)resignAllResponder
{
    UITextField *nikeNameTextField = ((UITextField *)[self.view viewWithTag:Setting_Tag]);
    UITextField *sexTextField = ((UITextField *)[self.view viewWithTag:Setting_Tag+1]);
    UITextField *introductionTextField = ((UITextField *)[self.view viewWithTag:Setting_Tag+2]);
    [nikeNameTextField resignFirstResponder];
    [sexTextField resignFirstResponder];
    [introductionTextField resignFirstResponder];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField *nikeNameTextField = ((UITextField *)[self.view viewWithTag:Setting_Tag]);
    UITextField *sexTextField = ((UITextField *)[self.view viewWithTag:Setting_Tag+1]);
    UITextField *introductionTextField = ((UITextField *)[self.view viewWithTag:Setting_Tag+2]);
    [nikeNameTextField resignFirstResponder];
    [sexTextField resignFirstResponder];
    [introductionTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
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
