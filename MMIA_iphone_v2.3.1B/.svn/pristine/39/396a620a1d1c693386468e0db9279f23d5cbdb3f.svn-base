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

//@synthesize navigationView = _navigationView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    //    [self loadNavigationView];
   // [self initNavigationView];
    // lx change
    [self initNewNavigationView];
}
/*
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
    _navigationImageView.backgroundColor = [UIColor grayColor];
    
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
 */

// add by yhx
- (void)initNavigationView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    UIView* toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width , VIEW_OFFSET)];
    toolBarView.backgroundColor = [UIColor colorWithRed:(CGFloat)((0xF4F5F7>>16)/255.0f) \
                                                  green:(CGFloat)(((0xF4F5F7&0x00FF00)>>8)/255.0f)\
                                                   blue:(CGFloat)((0xF4F5F7&0xFF)/255.0f) \
                                                  alpha:1.0];
    toolBarView.tag = 1000;
    [self.view addSubview:toolBarView];
    
    if( !_navigationView )
    {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(toolBarView.bounds), App_Frame_Width , kNavigationBarHeight)];
        _navigationView.backgroundColor = [UIColor colorWithRed:(CGFloat)((0xF4F5F7>>16)/255.0f) \
                                                          green:(CGFloat)(((0xF4F5F7&0x00FF00)>>8)/255.0f)\
                                                           blue:(CGFloat)((0xF4F5F7&0xFF)/255.0f) \
                                                          alpha:1.0];
    }
    
    [self.view addSubview:_navigationView];
    
}

- (void)setTitleString:(NSString*)title
{
    if( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, VIEW_OFFSET, 160, kNavigationBarHeight)];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor colorWithRed:(CGFloat)((0xCE212A>>16)/255.0f) \
                                               green:(CGFloat)(((0xCE212A&0x00FF00)>>8)/255.0f)\
                                                blue:(CGFloat)((0xCE212A&0xFF)/255.0f) \
                                               alpha:1.0]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.navigationView addSubview:_titleLabel];
    }
    _titleLabel.text = title;
}

- (void)addBackBtnWithTarget:(id)target selector:(SEL)selector
{
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, VIEW_OFFSET, 44, kNavigationBarHeight);
    backBtn.showsTouchWhenHighlighted = YES;
    backBtn.tag = 1001;
    [backBtn setImage:[UIImage imageNamed:@"login_02"] forState:UIControlStateNormal];
    [backBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationView addSubview:backBtn];
}

- (void)addRightBtnWithTarget:(id)target selector:(SEL)selector
{
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(App_Frame_Width - 44, VIEW_OFFSET, 44, kNavigationBarHeight);
    rightBtn.showsTouchWhenHighlighted = YES;
    rightBtn.tag = 1002;
    [rightBtn setImage:[UIImage imageNamed:@"login_01"] forState:UIControlStateNormal];
    [rightBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationView addSubview:rightBtn];
}

- (void)removeBackBtn
{
    [[self.navigationView viewWithTag:1001] removeFromSuperview];
}

- (void)removeRightkBtn
{
    [[self.navigationView viewWithTag:1002] removeFromSuperview];
}


//change lx

-(void)initNewNavigationView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    if (!_navigationView)
    {
        _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, VIEW_OFFSET + kNavigationBarHeight)];
        _navigationView.backgroundColor = [UIColor colorWithRed:(CGFloat)((0xF4F5F7>>16)/255.0f) \
                                                          green:(CGFloat)(((0xF4F5F7&0x00FF00)>>8)/255.0f)\
                                                           blue:(CGFloat)((0xF4F5F7&0xFF)/255.0f) \
                                                          alpha:1.0];
        
    }
    [self.view addSubview:_navigationView];

}

-(void)setNaviBarViewBackgroundColor:(UIColor *)backColor
{
    _navigationView.backgroundColor = backColor;
}

-(void)addNewBackBtnWithTarget:(id)target selector:(SEL)selector
{
    UIImage *leftImage = [UIImage imageNamed:@"commoditypage_backbutton.png"];
    UIButton *leftButton =[[UIButton alloc]initWithFrame:CGRectMake(0, (kNavigationBarHeight - leftImage.size.height)/2 + VIEW_OFFSET, leftImage.size.width+20, leftImage.size.height)];
    leftButton.tag = 1003;
    [leftButton setImage:leftImage forState:UIControlStateNormal];
    [leftButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:leftButton];
    
}

-(void)addNewRightBtnWithImage:(UIImage *)rigthImage Target:(id)target selector:(SEL)selector
{
    UIButton *rightButton =[[UIButton alloc]initWithFrame:CGRectMake(App_Frame_Width-rigthImage.size.width-20, (kNavigationBarHeight -rigthImage.size.height)/2 + VIEW_OFFSET, rigthImage.size.width+20, rigthImage.size.height)];
    rightButton.tag = 1004;
    [rightButton setImage:rigthImage forState:UIControlStateNormal];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:rightButton];
}

- (void)hideNavigationBar
{
   [self.navigationView removeFromSuperview];
}

- (void)hideToolBarView
{
    if( [self.view viewWithTag:1000] )
    {
        [[self.view viewWithTag:1000] removeFromSuperview];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
