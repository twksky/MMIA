//
//  MMIAEditionInforViewController.m
//  MMIA
//
//  Created by Vivian's Office MAC on 14-5-8.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIAEditionInforViewController.h"

#define LEFT_BBI_TAG 1
@interface MMIAEditionInforViewController ()

@end

@implementation MMIAEditionInforViewController
{
    UIView *_bgView;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabController hideOrNotCustomTabBar:YES];
    
}
-(void)viewDidAppear:(BOOL)animated
{
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
    if (btn.tag == 1001) {
        [self goBack];
    }
}
/*
 @param   nil
 @descripation 加载主视图上的子视图
 */
- (void)loadBgView
{
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_OFFSET+44, SCREEN_WIDTH, SCREEN_HEIGHT-VIEW_OFFSET-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    UIView *view=[[UIView alloc]init];
    view.clipsToBounds=YES;
    view.layer.cornerRadius=2.0;
    
    view.frame=CGRectMake(10, 10, Main_Screen_Width-20, 150);
    view.backgroundColor=[UIColor colorWithRed:(CGFloat)((0xCE212A>>16)/255.0f) \
                                         green:(CGFloat)(((0xCE212A&0x00FF00)>>8)/255.0f)\
                                          blue:(CGFloat)((0xCE212A&0xFF)/255.0f) \
                                         alpha:1.0];
    UIImage *image=[UIImage imageNamed:@"company_logo.png"];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((view.frame.size.width-image.size.width)/2, 20, image.size.width, image.size.height)];
    imageView.backgroundColor=[UIColor clearColor];
    imageView.image=image;
    [view addSubview:imageView];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x-5, imageView.frame.origin.y+image.size.height+5, imageView.frame.size.width+10, 20)];
    label1.text=@"广而告之广告天下";
    label1.textAlignment=NSTextAlignmentCenter;
    label1.font=[UIFont systemFontOfSize:14];
    label1.textColor=[UIColor whiteColor];
    label1.backgroundColor=[UIColor clearColor];
    [view addSubview:label1];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x-5, label1.frame.origin.y+label1.frame.size.height+5, imageView.frame.size.width+10, 50)];
    label2.text=[NSString stringWithFormat:@"%@ \r\n %@",@"当前版本",@"2.3.0"];
    label2.textAlignment=NSTextAlignmentCenter;
    
    label2.numberOfLines=0;
    label2.font=[UIFont systemFontOfSize:15];
    label2.textColor=[UIColor whiteColor];
    label2.backgroundColor=[UIColor clearColor];
    [view addSubview:label2];
    
    [_bgView addSubview:view];
    
    UILabel *lastLabel=[[UILabel alloc]init];
    lastLabel.backgroundColor=[UIColor clearColor];
    lastLabel.frame=CGRectMake(0, _bgView.frame.size.height-120, App_Frame_Width, 100);
    lastLabel.text=@"广而告之网络传媒有限公司 版权所有 \r\n Copyrirht © 2014 MMIA.com \r\n All Rights Reserved";
    lastLabel.numberOfLines=0;
    lastLabel.font=[UIFont systemFontOfSize:15];
    lastLabel.textColor=UIColorFromRGB(0x848484);
    lastLabel.textAlignment=NSTextAlignmentCenter;
   
    [_bgView addSubview:lastLabel];
    [self.view addSubview:_bgView];
    
}
/*
 @param   nil
 @descripation  加载导航视图
 */
- (void)loadNavView
{
    [self setTitleString:@"版本信息"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
   // [self setTitle:@"版本信息"];
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
    
    
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
