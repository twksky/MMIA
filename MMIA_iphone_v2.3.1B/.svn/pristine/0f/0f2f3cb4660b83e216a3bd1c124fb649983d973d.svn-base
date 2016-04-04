//
//  MMiaSetAccountViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-16.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaSetAccountViewController.h"
#import "MMiaChangePassWordViewController.h"
#import "MMIJudgeTypeUtil.h"

@interface MMiaSetAccountViewController (){
    UIView *_bgView;
}

@end

@implementation MMiaSetAccountViewController

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
    // Do any additional setup after loading the view.
    [self loadNavView];
    [self loadBgView];
}
#pragma mark - LoadUI

- (void)loadNavView
{
    [self setTitleString:@"账号设置"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
}
-(void)loadBgView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, SCREEN_WIDTH, Main_Screen_Height-20-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    
    UILabel *emailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    //emailLabel.text=@"邮箱";
    emailLabel.font=[UIFont systemFontOfSize:15];
     emailLabel.backgroundColor=[UIColor clearColor];
    [_bgView addSubview:emailLabel];
   
    UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(10, 32, App_Frame_Width-20, 42)];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
   // contentLable.text=[defaults objectForKey:USER_EMAIL];
    contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"personal_12.png"]];
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 11, CGRectGetWidth(contentView.frame)-20, 20)];
    contentLabel.text=[defaults objectForKey:USER_EMAIL];
    if ([MMIJudgeTypeUtil isEmailNumber:[defaults objectForKey:USER_EMAIL]])
    {
        emailLabel.text=@"邮箱";
    }else
    {
         emailLabel.text=@"手机";
    }
    contentLabel.textColor=[UIColor lightGrayColor];
     contentLabel.font=[UIFont systemFontOfSize:15];
    [contentView addSubview:contentLabel];
    [_bgView addSubview:contentView];
    
    
    UILabel *passLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,82, 100, 20)];
    passLabel.backgroundColor=[UIColor clearColor];
    passLabel.text=@"密码";
      passLabel.font=[UIFont systemFontOfSize:15];
    [_bgView addSubview:passLabel];
    
    UIView *passContentView=[[UIView alloc]initWithFrame:CGRectMake(10, 104, App_Frame_Width-20, 42)];
    passContentView.userInteractionEnabled=YES;
     passContentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"personal_12.png"]];
    UILabel *passContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 11, CGRectGetWidth(contentView.frame)-20, 20)];
      passContentLabel.backgroundColor=[UIColor clearColor];
      passContentLabel.text=@"修改密码";
     passContentLabel.font=[UIFont systemFontOfSize:15];
    [passContentView addSubview:passContentLabel];
    [_bgView addSubview:passContentView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [passContentView addGestureRecognizer:tap];
    
}
#pragma mark -btnClick
-(void)btnClick:(UIButton *)button
{
    if (button.tag==1001)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    MMiaChangePassWordViewController *changeVC=[[MMiaChangePassWordViewController alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
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
