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


#define LEFT_BBI_TAG 1
#define RIGHT_BBI_TAG 2

#define FEED_BACK_CONTENT_TAG 10

#define LINK_METHOD_TAG 11

@interface MMIAFeedBackViewController ()

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
/*
 @param   nil
 @descripation  返回到上一级页面
 */
- (void)goBack
{
    
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index==0) {
        return;
    }
    [self.navigationController  popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1] animated:YES];
    
}
/*
 @param   nil
 @descripation  按钮点击事件
 */
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == LEFT_BBI_TAG) {
        [self goBack];
    }
    if (btn.tag==RIGHT_BBI_TAG) {
        
        
          }
}
/*
 @param   nil
 @descripation 加载主视图上的子视图
 */

- (void)loadBgView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, App_Frame_Height-20-TABLE_BAR_HEIGHT-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    
    [MMiaCommonUtil initializeMMIaTextViewWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 150) tag:FEED_BACK_CONTENT_TAG andTextPlaceholder:@"请尽量详细的描述反馈" andText:nil andSuperView:_bgView];
    
    [MMiaCommonUtil initializeMMIaTextViewWithFrame:CGRectMake(10, 170, SCREEN_WIDTH-20, 30) tag:LINK_METHOD_TAG andTextPlaceholder:@"请填写QQ或手机号,方便我们联系你" andText:nil andSuperView:_bgView];
    MMIaTextViewUtil *textView=(MMIaTextViewUtil *)[_bgView viewWithTag:FEED_BACK_CONTENT_TAG];
    textView.delegate=self;
    MMIaTextViewUtil *textView1=(MMIaTextViewUtil *)[_bgView viewWithTag:LINK_METHOD_TAG];
    textView1.delegate=self;
    
   
       
}


/*
 @param   nil
 @descripation  加载导航视图
 */
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
    
    self.rightBarButton.tag = RIGHT_BBI_TAG;
    [self.rightBarButton setTitle:@"确定" forState:UIControlStateNormal];
    self.rightBarButton.titleLabel.textColor=[UIColor redColor];
    [self.rightBarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftBarButton.tag = LEFT_BBI_TAG;
    self.leftBarButton.frame = CGRectMake(0, VIEW_OFFSET, 60, 44);
    [self.leftBarButton setImage:[UIImage imageNamed:@"login_02"] forState:UIControlStateNormal];
    [self.leftBarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = @"意见反馈";
    self.titleLabel.textColor = UIColorFromRGB(0xCE212A);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavView];
    [self loadBgView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    MMIaTextViewUtil *textView=(MMIaTextViewUtil *)[_bgView viewWithTag:FEED_BACK_CONTENT_TAG];
    MMIaTextViewUtil *textView1=(MMIaTextViewUtil *)[_bgView viewWithTag:LINK_METHOD_TAG];
    [textView resignFirstResponder];
    [textView1 resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    MMIaTextViewUtil *view=(MMIaTextViewUtil *)textView;
    view.placeholderLabel.alpha=0;
    
   
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    MMIaTextViewUtil *textView0=(MMIaTextViewUtil *)[_bgView viewWithTag:FEED_BACK_CONTENT_TAG];
    if (textView0.text.length>=200 && ![text isEqualToString:@""]) {
        return NO;
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
