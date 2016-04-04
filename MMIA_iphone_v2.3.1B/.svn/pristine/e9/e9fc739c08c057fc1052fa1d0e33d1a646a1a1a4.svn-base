//
//  MMIAFeedBackViewController.m
//  MMIA
//
//  Created by Vivian's Office MAC on 14-5-8.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIAFeedBackViewController.h"
#import "MMiaCommonUtil.h"
#import "MMIaTextViewUtil.h"
#import "MMIToast.h"


#define FEED_BACK_CONTENT_TAG 10

#define LINK_METHOD_TAG 11

@interface MMIAFeedBackViewController (){
     UIView *_bgView;
}

@end

@implementation MMIAFeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
 @descripation  加载导航视图
 */
- (void)loadNavView
{
    [self setTitleString:@"意见反馈"];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
    [self addRightBtnWithTarget:self selector:@selector(btnClick:)];
    UIButton *rightButton=(UIButton *)[self.view viewWithTag:1002];
    [rightButton setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    UIImage *rightButtonImage=[UIImage imageNamed:@"login_16.png"];
    rightButton.frame=CGRectMake(App_Frame_Width-rightButtonImage.size.width-10, (44-rightButtonImage.size.height)/2 + VIEW_OFFSET, rightButtonImage.size.width, rightButtonImage.size.height);
    //rightButton.frame.size=CGSizeMake(CGRectGetWidth(rightButton.frame), CGRectGetHeight(rightButton.frame));
    rightButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_16.png"]];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
}
/*
 @param   nil
 @descripation 加载主视图上的子视图
 */

- (void)loadBgView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, Main_Screen_Height-20-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    
    [MMiaCommonUtil initializeMMIaTextViewWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 150) tag:FEED_BACK_CONTENT_TAG andTextPlaceholder:@"请尽量详细的描述反馈。" andText:nil andSuperView:_bgView];
    
    [MMiaCommonUtil initializeMMIaTextViewWithFrame:CGRectMake(10, 170, SCREEN_WIDTH-20, 30) tag:LINK_METHOD_TAG andTextPlaceholder:@"请填写QQ或手机号,方便我们联系你。" andText:nil andSuperView:_bgView];
    MMIaTextViewUtil *textView=(MMIaTextViewUtil *)[_bgView viewWithTag:FEED_BACK_CONTENT_TAG];
    textView.delegate=self;
    MMIaTextViewUtil *textView1=(MMIaTextViewUtil *)[_bgView viewWithTag:LINK_METHOD_TAG];
    textView1.delegate=self;
    
    
    
}





/*
 @param   nil
 @descripation  按钮点击事件
 */
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == 1001)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag==1002)
    {
        [self resignAllResponder];
      MMIaTextViewUtil *textView=(MMIaTextViewUtil *)[_bgView viewWithTag:FEED_BACK_CONTENT_TAG];
         MMIaTextViewUtil *textView1=(MMIaTextViewUtil *)[_bgView viewWithTag:LINK_METHOD_TAG];
        UMFeedback *umFeedback = [UMFeedback sharedInstance];
        [umFeedback setAppkey:UMENG_APPKEY delegate:self];
        NSMutableDictionary *infoDict=[[NSMutableDictionary alloc]init];
        
        if (textView.text.length==0)
        {
            [self show_check_phone_info:@"请填写你的意见" image:nil];
            return;
        }
        [infoDict setObject:textView.text forKey:@"content"];
        if (textView1.text.length==0) {
            [infoDict setObject:[NSNull null] forKey:@"contact"];
        }else
        {
            NSDictionary *contact = [NSDictionary dictionaryWithObject:textView1.text forKey:@"email"];
           // [dictionary setObject:contact forKey:@"contact"];
          [infoDict setObject:contact forKey:@"contact"];
        }
        
        [umFeedback post:infoDict];
    }
}
#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}
#pragma mark -UMFeedBackCelegate
- (void)postFinishedWithError:(NSError *)error
{
    if (error==nil) {
        [self show_check_phone_info:@"保存成功" image:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
        [self show_check_phone_info:@"保存失败" image:nil];
   
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)resignAllResponder
{
    MMIaTextViewUtil *textView=(MMIaTextViewUtil *)[_bgView viewWithTag:FEED_BACK_CONTENT_TAG];
    MMIaTextViewUtil *textView1=(MMIaTextViewUtil *)[_bgView viewWithTag:LINK_METHOD_TAG];
    [textView resignFirstResponder];
    [textView1 resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self resignAllResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    MMIaTextViewUtil *view=(MMIaTextViewUtil *)textView;
    view.placeholderLabel.alpha=0;
    
    if (textView.tag==LINK_METHOD_TAG)
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
    MMIaTextViewUtil *textView0=(MMIaTextViewUtil *)[_bgView viewWithTag:FEED_BACK_CONTENT_TAG];
    if (textView0.text.length>=200 && ![text isEqualToString:@""]) {
        return NO;
    }
    if (textView.tag==LINK_METHOD_TAG)
    {
        CGRect orgRect=textView.frame;
        CGSize  size = [textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT)lineBreakMode:MMIALineBreakModeWordWrap];
        orgRect.size.height=size.height+20;//获取自适应文本内容高度
        textView.frame=orgRect;//重设UITextView的frame
    }
    return YES;
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
