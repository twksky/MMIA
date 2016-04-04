//
//  BaseViewController.m
//  MMIA
//
//  Created by zixun on 6/10/14.
//  Copyright (c) 2014 com.zixun. All rights reserved.
//

#import "MMiaBaseViewController.h"

@interface MMiaBaseViewController ()

@end

@implementation MMiaBaseViewController

@synthesize leftBarButton = _leftBarButton;
@synthesize rightBarButton = _rightBarButton;
@synthesize titleLabel = _titleLabel;
@synthesize navigationImageView = _navigationImageView;
@synthesize navigationView = _navigationView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadNavigationView
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width , 44+VIEW_OFFSET)];
    _navigationView.backgroundColor = [UIColor clearColor];
    
    _navigationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width , 44+VIEW_OFFSET)];
    // _navigationView.image = [UIImage imageWithName:@"all_33"];
    _navigationImageView.image = [UIImage imageNamed:@"me_bg_top"];
    _navigationImageView.clipsToBounds = YES;
    _navigationImageView.contentMode = UIViewContentModeScaleToFill;
    _navigationImageView.backgroundColor = [UIColor whiteColor];
    
    [_navigationView addSubview:_navigationImageView];
    
    //titlelabel
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, VIEW_OFFSET, 200, _navigationView.frame.size.height-VIEW_OFFSET)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [_navigationView addSubview:_titleLabel];
    
    //左边的按钮
    _leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBarButton.frame = CGRectMake(10, VIEW_OFFSET, 55, _navigationView.frame.size.height-VIEW_OFFSET);
    //    _leftBarButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _leftBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_navigationView addSubview:_leftBarButton];
    
    //右边的按钮
    _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBarButton.frame = CGRectMake(App_Frame_Width -65, VIEW_OFFSET, 55, _navigationView.frame.size.height-VIEW_OFFSET);
    //    _rightBarButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_navigationView addSubview:_rightBarButton];
    
    
    [self.view addSubview:_navigationView];
    self.view.backgroundColor = BACK_GROUND_COLOR;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;

    [self loadNavigationView];
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
