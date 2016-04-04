//
//  MmiaFeedBackViewController.m
//  MmiaHD
//
//  Created by twksky on 15/4/7.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaFeedBackViewController.h"
#import "UMFeedback.h"

@interface MmiaFeedBackViewController ()<UITextViewDelegate,UMFeedbackDataDelegate>

@end

@implementation MmiaFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    UIView *backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    backgroudView.backgroundColor = ColorWithHexRGB(0xf9f9f7);
    [self.contentView addSubview:backgroudView];
    
    for (NSInteger i = 0; i<3; i++) {
       
        
        if (i == 0) {
            [MmiaCommonUtil initializeMMIaTextViewWithFrame:CGRectMake(((backgroudView.frame.size.width-170)-Setting_Weight)/2,Setting_Top_gap+Setting_ImageView_D+Setting_Min_gap+(Setting_Height+2)*i, Setting_Weight , Setting_Height*2+2) tag:Setting_Tag + i andTextPlaceholder:@"请尽量详细的描述反馈。" andText:nil andSuperView:backgroudView];
            self.feedBackContent = (MmiaTextViewUtil *)[backgroudView viewWithTag:Setting_Tag + i];
        }
        if (i == 1) {
            [MmiaCommonUtil initializeMMIaTextViewWithFrame:CGRectMake(((backgroudView.frame.size.width-170)-Setting_Weight)/2,Setting_Top_gap+Setting_ImageView_D+Setting_Min_gap+(Setting_Height+2)*(i+1), Setting_Weight , Setting_Height) tag:Setting_Tag + i andTextPlaceholder:@"请填写QQ或手机号,方便我们联系你。" andText:nil andSuperView:backgroudView];
            self.linkMethod = (MmiaTextViewUtil *)[backgroudView viewWithTag:Setting_Tag + i];
        }
        if (i == 2) {
            UIView *background = [[UIView alloc]initWithFrame:CGRectMake(((backgroudView.frame.size.width-170)-Setting_Weight)/2,Setting_Top_gap+Setting_ImageView_D+Setting_Min_gap+(Setting_Height+2)*(i+1), Setting_Weight , Setting_Height)];
            background.userInteractionEnabled = YES;
            background.backgroundColor= [UIColor whiteColor];
            [self.contentView addSubview:background];
            
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                button.tag = Setting_Tag +i;
                button.frame = CGRectMake(26,5,380,36);
                [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                button.backgroundColor = ColorWithHexRGB(0xF21E3B);
                [button setTitle:@"提交" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                [background addSubview:button];
            }
        }
}

-(void)btnClick:(UIButton *)btn{
    [self resignAllResponder];
    UMFeedback *umFeedback = [UMFeedback sharedInstance];
    [umFeedback setAppkey:UMENG_APPKEY delegate:self];
    NSMutableDictionary *infoDict=[[NSMutableDictionary alloc]init];
    if (self.feedBackContent.text.length==0)
    {
        [self show_check_phone_info:@"请填写你的意见" image:nil];
        return;
    }
    if (self.linkMethod.text.length == 0) {
        [self show_check_phone_info:@"请留下您的联系方式，方便我们联系您" image:nil];
        return;
    }
    [infoDict setObject:self.feedBackContent.text forKey:@"content"];
    if (self.linkMethod.text.length==0) {
        [infoDict setObject:[NSNull null] forKey:@"contact"];
    }else
    {
        NSDictionary *contact = [NSDictionary dictionaryWithObject:self.linkMethod.text forKey:@"email"];
        // [dictionary setObject:contact forKey:@"contact"];
        [infoDict setObject:contact forKey:@"contact"];
    }
    
    [umFeedback post:infoDict];
}


#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{

    [MmiaToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}
#pragma mark -UMFeedBackCelegate
- (void)postFinishedWithError:(NSError *)error
{

    if (error==nil) {
        [self show_check_phone_info:@"保存成功" image:nil];
        [super dismissStackViewController:nil];
        
    }else
    {
        [self show_check_phone_info:@"保存失败" image:nil];
        
    }
}

-(void)resignAllResponder
{
    [self.feedBackContent resignFirstResponder];
    [self.linkMethod resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self resignAllResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    MmiaTextViewUtil *view=(MmiaTextViewUtil *)textView;
    view.placeholderLabel.alpha=0;
    
    if (textView == self.linkMethod)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, -60, self.view.frame.size.width, self.view.frame.size.height)];
            
        }];
        
    }
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
    }];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if (self.feedBackContent.text.length>=200 && ![text isEqualToString:@""]) {
        return NO;
    }
    if (textView == self.linkMethod)
    {
        //？？？
        CGRect orgRect=textView.frame;
        CGSize  size = [textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(0, MAXFLOAT)lineBreakMode:MMIALineBreakModeWordWrap];
        orgRect.size.height=size.height+20;//获取自适应文本内容高度
        textView.frame=orgRect;//重设UITextView的frame
    }
    return YES;
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
