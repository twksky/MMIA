//
//  MMiaDetailImgeViewController.m
//  MMIA
//
//  Created by lixiao on 14-7-4.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaDetailImgeViewController.h"

#define LEFT_BBI_TAG  10

@interface MMiaDetailImgeViewController ()

@end

@implementation MMiaDetailImgeViewController

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
#pragma marks -loadUI
-(void)loadNavView
{
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
    /*
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
    self.leftBarButton.frame = CGRectMake(0, VIEW_OFFSET, 44, 44);
    [self.leftBarButton setImage:[UIImage imageNamed:@"login_02"] forState:UIControlStateNormal];
    [self.leftBarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.hidden=YES;
     */
    
     
    
}
- (void)loadBgView
{
    
    
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, App_Frame_Height-TABLE_BAR_HEIGHT-44)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    UIImage *image=[UIImage imageNamed:@"4.jpg"];
    CGFloat rate;
    if (image.size.width!=0) {
         rate=320/image.size.width;
    }
    
    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, image.size.height*rate)];
    _bigImageView.image=image;
    _bigImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_bigImageView addGestureRecognizer:tap];
    [_bgView addSubview:_bigImageView];
    
    
    
}



#pragma mark - bttonClick
-(void)btnClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    //CGRect frame=_bigImageView.frame;
    BOOL hidden=self.navigationView.hidden;
    self.navigationView.hidden=!hidden;
    if (hidden) {
       
    }
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
