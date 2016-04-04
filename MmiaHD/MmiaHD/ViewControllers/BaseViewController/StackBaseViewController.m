//
//  StackBaseViewController.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-4.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "StackBaseViewController.h"
#import "AdditionHeader.h"
#import "GlobalDef.h"
#import "GlobalFunction.h"
#import "MmiaLoginViewController.h"

static const NSInteger SideOffset_Portrait_Width = 168.0f; //80.0f;
static const NSInteger SideOffset_Landscap_Width = 424.0f; //250.0f;

@interface StackBaseViewController ()

// 根据屏幕方向设置当前self.view.frame
- (CGRect)ViewRectFromInterfaceOrientation;
- (void)layoutSubviews;
// 滑动使当前页面消失
- (void)dismissStackViewController:(id)sender;
// contentView向左/右拉伸
- (void)contentViewDidTransformForStretch;
// contentView向左/右缩小到初始位置
- (void)contentViewDidTransformForSmaller;

@end

@implementation StackBaseViewController

#pragma mark - Initialization

- (id)init
{
    if( self = [super init] )
    {
        _sideAnimationDuration = 0.4f;
        _sideOffset = SideOffset_Portrait_Width;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorClear;

    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
     _contentView.backgroundColor = ColorWithHexRGB(0xf1f1f1);
    
    _anotherView = [[UIView alloc] initWithFrame:self.view.bounds];
     _anotherView.backgroundColor = ColorWithHexRGBA(0x000000, 0.8);
    _anotherView.userInteractionEnabled = YES;
    
    // 添加手势
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismissStackViewController:)];
    if( _direction == StackViewControllerDirectionRight )
    {
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
    }
    else if( _direction == StackViewControllerDirectionLeft )
    {
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    }

    _portrait = UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
    if( !_portrait )
        
    {
        // 横屏
        _sideOffset = SideOffset_Landscap_Width;
    }
    
    [self.view addSubview:_anotherView];
    [self.view addSubview:_contentView];
    [self.view addGestureRecognizer:swipe];
    
    _backButton = [[UIButton alloc]init];
    [_backButton setBackgroundColor:ColorWithHexRGB(0x2c2c33)];
    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    [_backButton.titleLabel setFont:UIFontSystem(17)];
    [_backButton setTitleColor:ColorWithHexRGB(0xffffff) forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(dismissStackViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.anotherView addSubview:_backButton];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    
    [UIView animateWithDuration:self.sideAnimationDuration animations:^{
        self.view.left = 0.0f;
        
    } completion:^(BOOL finished) {
        [self didMoveToParentViewController:parent];
        
    }];
    
    // 父页面宽度动态拉伸
    if( [parent isKindOfClass:[StackBaseViewController class]] )
    {
        // 改变contentView的透明度
//        [(StackBaseViewController *)parent contentView].alpha = 0.2;
        [(StackBaseViewController *)parent contentViewDidTransformForStretch];
    }
}

#pragma mark - Private

- (void)contentViewDidTransformForStretch
{
    CGRect frame = self.originViewFrame;
    CGFloat contentOffset = self.sideOffset;
    if( !self.portrait )
    {
        contentOffset = SideOffset_Portrait_Width;
    }
    
    switch( self.direction )
    {
        case StackViewControllerDirectionRight:
        {
            frame.origin.x -= contentOffset;
        }
            break;
            
        case StackViewControllerDirectionLeft:
            frame.origin.x += contentOffset;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:self.sideAnimationDuration animations:^{
        self.contentView.frame = frame;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)contentViewDidTransformForSmaller
{
    if( [NSStringFromCGRect(self.originViewFrame) isEqualToString:NSStringFromCGRect(self.contentView.frame)] )
        return;
    
    [UIView animateWithDuration:self.sideAnimationDuration animations:^{
        self.contentView.frame = self.originViewFrame;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissStackViewController:(id)sender
{
    [self willMoveToParentViewController:nil];
    
    UIView* parentView = self.parentViewController.view;
    CGFloat originX = 0.0f;
    switch( self.direction )
    {
        case StackViewControllerDirectionRight:
            originX += parentView.width;
            break;
            
        case StackViewControllerDirectionLeft:
            originX -= parentView.width;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:self.sideAnimationDuration animations:^{
        self.view.frame = CGRectMake(originX, 0, parentView.width, parentView.height);
        
    } completion:^(BOOL finished) {
        // 父页面宽度动态收缩
        if( [self.parentViewController isKindOfClass:[StackBaseViewController class]] )
        {
            [(StackBaseViewController *)self.parentViewController contentViewDidTransformForSmaller];
            // 恢复contentView的透明度
            [(StackBaseViewController *)self.parentViewController contentView].alpha = 1.0;
        }
        else
        {
            // TODO:半透明背景
        }

        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        
    }];
}

- (CGRect)ViewRectFromInterfaceOrientation
{
    CGRect selfViewframe = self.view.bounds;
    if( self.portrait )
    {
        // 竖屏
        selfViewframe.size.width = App_Portrait_Frame_Width;
        selfViewframe.size.height = App_Portrait_Frame_Height;
    }
    else
    {
        // 横屏
        selfViewframe.size.width = App_Landscape_Frame_Width;
        selfViewframe.size.height = App_Landscape_Frame_Height;
    }
    
    return selfViewframe;
}

- (void)layoutSubviews
{
    CGRect selfViewframe = [self ViewRectFromInterfaceOrientation];
    
    self.contentView.width = selfViewframe.size.width - self.sideOffset;
    self.contentView.height = selfViewframe.size.height;
    
    self.anotherView.width = self.sideOffset;
    self.anotherView.height = self.contentView.height;
    
    // ViewController从右边弹出
    if( self.direction == StackViewControllerDirectionRight )
    {
        self.contentView.left = self.sideOffset;
    }
    // ViewController从左边弹出
    else if( self.direction == StackViewControllerDirectionLeft )
    {
        self.anotherView.left = self.contentView.right;
    }
    self.originViewFrame = self.contentView.frame;
    
    //lx add
    self.backButton.frame = CGRectMake(0, self.anotherView.height - 44, self.anotherView.width, 44);
    
//    MyNSLog( @"baseView.F = %@", NSStringFromCGRect(self.view.frame) );
//    MyNSLog( @"content.F = %@", NSStringFromCGRect(self.contentView.frame) );
//    MyNSLog( @"anotherView.F = %@", NSStringFromCGRect(self.anotherView.frame) );
}


#pragma mark - Public
- (void)insertIntoLoginVC
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //    if( [defaults objectForKey:USER_IS_LOGIN] )
    if ([defaults boolForKey:USER_IS_LOGIN])
    {
    }
    else
    {
        MmiaLoginViewController *login = [[MmiaLoginViewController alloc]init];
        login.view.frame = self.view.bounds;
        [login setTarget:self withSuccessAction:@selector(loginSuccess) withRegisterAction:@selector(registerSuccess)];
        login.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:login animated:YES completion:nil];
    }
}

- (void)registerSuccess
{
     [self dismissViewControllerAnimated:NO completion:nil];
     [self loginSuccess];
}

- (void)loginSuccess
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark * Overwritten setter

- (void)setSideOffset:(CGFloat)sideOffset
{
    if( _sideOffset != sideOffset )
    {
        _sideOffset = sideOffset;
        
        [self layoutSubviews];
    }
}

#pragma mark - UIViewControllerRotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    MyNSLog( @"baseStacklVC rotate" );
    
    self.portrait = UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
    if( self.portrait )
    {
        // 竖屏
        self.sideOffset = SideOffset_Portrait_Width;
    }
    else
    {
        // 横屏
        self.sideOffset = SideOffset_Landscap_Width;
    }
    
    if( [self.parentViewController isKindOfClass:[StackBaseViewController class]] )
    {
        [(StackBaseViewController *)self.parentViewController contentViewDidTransformForStretch];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
