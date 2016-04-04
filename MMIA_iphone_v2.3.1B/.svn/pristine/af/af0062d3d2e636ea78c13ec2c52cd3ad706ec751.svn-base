//
//  MyCustomTabBarMainVIew.m
//  MMIA
//
//  Created by lixiao on 14-9-25.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MyCustomTabBarMainVIew.h"

@implementation MyCustomTabBarMainVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//+ (void)showInLoseScopeHeight:(CGFloat)height
//{
//    MyCustomTabBarMainVIew *mainView=[[MyCustomTabBarMainVIew alloc]initWithLoseScopeHeight:height];
//    [mainView show];
//}

- (id)initWithLoseScopeHeight:(CGFloat)height
{
    self = [super init];
    if( self )
    {
        self.alertWindow1 = [self windowWithLevel:UIWindowLevelAlert+1];
        
        if( !self.alertWindow1 )
        {
            self.alertWindow1 = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, CGRectGetHeight([UIScreen mainScreen].bounds))];
            self.alertWindow1.windowLevel = UIWindowLevelAlert+1;
            self.alertWindow1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        }
        [self.alertWindow1 addSubview:self];
        self.frame=CGRectMake(0, CGRectGetHeight(self.alertWindow1.frame)-150-height, App_Frame_Width, 150+height);
        self.backgroundColor=[UIColor clearColor];
       /*
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, App_Frame_Width,20)];
        titleLabel.backgroundColor=[UIColor clearColor];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:13]];
        titleLabel.textAlignment=MMIATextAlignmentCenter;
        [titleLabel setText:@"分享信息"];
        [self addSubview:titleLabel];
        */
        //photos.png
        
        UIImage *camerImage=[UIImage imageNamed:@"camera.png"];
        UIImageView *camerImageView=[[UIImageView alloc]initWithImage:camerImage];
        camerImageView.userInteractionEnabled=YES;
        camerImageView.tag=1;
        UITapGestureRecognizer *camerTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [camerImageView addGestureRecognizer:camerTap];
        
     camerImageView.center=CGPointMake(50+camerImage.size.width/2,CGRectGetHeight(self.frame)/3);
     [self addSubview:camerImageView];
        
        UILabel *camerLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(camerImageView.frame), CGRectGetMaxY(camerImageView.frame)+5, CGRectGetWidth(camerImageView.frame),20)];
        camerLabel.backgroundColor=[UIColor clearColor];
        [camerLabel setTextColor:[UIColor whiteColor]];
        [camerLabel setFont:[UIFont systemFontOfSize:13]];
        camerLabel.textAlignment=MMIATextAlignmentCenter;
        [camerLabel setText:@"相机"];
        [self addSubview:camerLabel];
        
         UIImage *photoImage=[UIImage imageNamed:@"photos.png"];
        UIImageView *photosImageView=[[UIImageView alloc]initWithImage:photoImage];
        photosImageView.userInteractionEnabled=YES;
        photosImageView.tag=2;
        UITapGestureRecognizer *photosTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [photosImageView addGestureRecognizer:photosTap];
        
      photosImageView.center=CGPointMake( App_Frame_Width-50-photoImage.size.width/2, CGRectGetHeight(self.frame)/3);
    [self addSubview:photosImageView];
        
        UILabel *photoLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(photosImageView.frame), CGRectGetMaxY(photosImageView.frame)+5, CGRectGetWidth(photosImageView.frame),20)];
        photoLabel.backgroundColor=[UIColor clearColor];
        [photoLabel setTextColor:[UIColor whiteColor]];
        [photoLabel setFont:[UIFont systemFontOfSize:13]];
        photoLabel.textAlignment=MMIATextAlignmentCenter;
        [photoLabel setText:@"相册"];
        [self addSubview:photoLabel];
        
        //添加关闭window按钮
        UIImage *img = [UIImage imageNamed:@"center_select.png"];
        UIButton *closeWindowBut = [[UIButton alloc] initWithFrame:CGRectMake((self.window.bounds.size.width - img.size.width)/2, (self.bounds.size.height - height) + (height - img.size.width)/2, img.size.width, img.size.height)];
        [closeWindowBut setImage:img forState:UIControlStateNormal];
        [closeWindowBut addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeWindowBut];
       
    }
    
    return self;
}
- (void)closeWindow{
    self.window.hidden = YES;
}

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
   
    for (UIWindow *window in windows)
    {
       
        if (window.windowLevel+1 == windowLevel)
        {
            return window;
        }
    }
    return nil;
}
- (void)show
{
    
    [self.alertWindow1 makeKeyAndVisible];
    [self showAnimation];
//    [self performSelector:@selector(dismissToast) withObject:nil afterDelay:self.duration];
}
- (void)showAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [self.layer addAnimation:animation forKey:@"showAlert"];
}
- (void)dismissTabBarMainView
{
    //[self dismissAnimation];
     self.alpha = 0;
    //[self.alertWindow1 resignKeyWindow];
    [self.alertWindow1 setHidden:YES];
  [self.alertWindow1 removeFromSuperview];
   self.alertWindow1 = nil;
//    [UIView animateWithDuration:0 animations:^{
//        self.alpha = 0;
//        
//    } completion:^(BOOL finished) {
//        [self.alertWindow setHidden:YES];
//        [self.alertWindow removeFromSuperview];
//        self.alertWindow = nil;
//    }];
}


- (void)dismissAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],//0.95, 0.95
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)]];//0.8, 0.8
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    
    [self.layer addAnimation:animation forKey:@"dismissAlert"];
}

-(void)tapClick:(UITapGestureRecognizer *)tap
{
    self.alertWindow1.hidden=YES;
    
    UIImageView *imageView=(UIImageView *)tap.view;
   
    [self.delegate tapCenterButtonImageView:imageView inView:self];
     
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
