//
//  MMIAPassSucViewController.m
//  MMIA
//
//  Created by lixiao on 14-6-25.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMIAPassSucViewController.h"

#import "MMiaCommonUtil.h"
#import "MMIALoginViewController.h"


@interface MMIAPassSucViewController ()

#define LEFT_BBI_TAG 101
#define NEXT_STEP_BTN_TAG 102

@end

@implementation MMIAPassSucViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)btnClick:(UIButton *)btn{
    if (btn.tag==LEFT_BBI_TAG) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag==NEXT_STEP_BTN_TAG) {
        MMIALoginViewController *lvc=[[MMIALoginViewController alloc]init];
        [self.navigationController pushViewController:lvc animated:YES];
    }
}

-(void)loadNavView{
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
    self.leftBarButton.frame = CGRectMake(0, VIEW_OFFSET, 60, 44);
    [self.leftBarButton setImage:[UIImage imageNamed:@"login_02"] forState:UIControlStateNormal];
    [self.leftBarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = @"修改成功";
    self.titleLabel.textColor = UIColorFromRGB(0xCE212A);
    
    
}
-(void)loadbgView{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, App_Frame_Height-20-TABLE_BAR_HEIGHT-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.center=CGPointMake(App_Frame_Width/2, 20);
    imageView.image=[UIImage imageNamed:@"personal_10.png"];
    
    [_bgView addSubview:imageView];
    
    [MMiaCommonUtil initializeLabelWithFrame:CGRectMake(0, 40, App_Frame_Width, 20) text:@"恭喜你！密码修改成功，请牢记你的新密码哦" textFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter andSuperView:_bgView andTag:0];
    
    UIButton *btn = [MMiaCommonUtil initializeButtonWithFrame:CGRectMake(10, 70, _bgView.frame.size.width-20, 44) title:@"立即登录" titleFont:[UIFont systemFontOfSize:15] titleColor:nil backgroundImageNamed:@"login_04@2x" image:nil andSuperView:_bgView andBtnTag:NEXT_STEP_BTN_TAG];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNavView];
    [self loadbgView];
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
