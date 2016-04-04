//
//  ViewController.m
//  POP
//
//  Created by twksky on 15/5/7.
//  Copyright (c) 2015年 twksky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    BOOL isAnimated;
}
@property (strong, nonatomic) UIImageView *springView1;
@property (strong, nonatomic) UIImageView *springView2;
@property (strong, nonatomic) UIImageView *springView3;
@property (nonatomic, strong) UIButton *btn;
@property (strong, nonatomic) JTSlideShadowAnimation *shadowAnimation;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *errorLabel;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    isAnimated = YES;
    [_shadowAnimation start];
    _errorLabel.alpha = 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView1];
    [self createView2];
    [self createBtn];
    [self addActivityIndicatorView];
    [self createErrorLabel];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeSize:) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changePosition:) userInfo:nil repeats:YES];
    
    
    //添加手势
    UITapGestureRecognizer *gestureForSpring1 = [[UITapGestureRecognizer alloc] init];
    [gestureForSpring1 addTarget:self action:@selector(changeSize:)];
    [_springView1 addGestureRecognizer:gestureForSpring1];
    UITapGestureRecognizer *gestureForSpring2 = [[UITapGestureRecognizer alloc] init];
    [gestureForSpring2 addTarget:self action:@selector(changePosition:)];
    [_springView2 addGestureRecognizer:gestureForSpring2];
    // Do any additional setup after loading the view, typically from a nib.
}

//三个view
-(void)createView1{
    _springView1 = [[UIImageView alloc]init];
    _springView1.image = [UIImage imageNamed:@"iOS框架图.jpg"];
    _springView1.frame = CGRectMake(50, 150, 100, 100);
    _springView1.center = self.view.center;
    [self.view addSubview:_springView1];
    _springView1.userInteractionEnabled = YES;
}
-(void)createView2{
    _springView2 = [[UIImageView alloc]init];
    _springView2.image = [UIImage imageNamed:@"iOS框架图.jpg"];
    _springView2.frame = CGRectMake(20, 150, self.view.frame.size.width-40, 100);
    _springView2.center = CGPointMake(self.view.frame.size.width/2, 0);
    [self.view addSubview:_springView2];
    _springView2.userInteractionEnabled = YES;
}

-(void)createBtn{
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"酷炫的闪烁效果，哈哈哈哈" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _btn.frame = CGRectMake(20, CGRectGetHeight(self.view.frame)-80, CGRectGetWidth(self.view.frame)-40, 80);
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    _shadowAnimation = [JTSlideShadowAnimation new];
    _shadowAnimation.animatedView = _btn;
    _shadowAnimation.shadowWidth = 40.;
    _shadowAnimation.duration = 1;
    
}

-(void)createErrorLabel{

    self.errorLabel = [UILabel new];
    self.errorLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18];
    self.errorLabel.textColor = [UIColor redColor];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.text = @"登陆不成功，给你一个提示";
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:self.errorLabel belowSubview:self.activityIndicatorView];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.btn
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual toItem:self.btn
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1
                              constant:0]];
    
    self.errorLabel.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.f);
    
}

-(void)btnClick:(UIButton *)btn{
    if (isAnimated) {
        [_shadowAnimation stop];
        isAnimated = NO;
//        [self.activityIndicatorView startAnimating];
        [self hideLabel];
    }else{
        [_shadowAnimation start];
        isAnimated = YES;
//        [self.activityIndicatorView stopAnimating];
        [self shakeButton];
        [self showLabel];
    }
}


- (void)showLabel
{
    self.errorLabel.layer.opacity = 1.0;
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 30;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
    
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.btn.layer.position.y - self.btn.intrinsicContentSize.height);
    layerPositionAnimation.springBounciness = 12;
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
    NSLog(@"%@",NSStringFromCGRect(_errorLabel.frame));
}

- (void)hideLabel
{
    NSLog(@"%@",NSStringFromCGRect(_errorLabel.frame));
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.btn.layer.position.y);
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
//    self.errorLabel.alpha = 0;
}



- (void)addActivityIndicatorView
{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
//    self.navigationItem.rightBarButtonItem = item;
    self.activityIndicatorView.center = CGPointMake(CGRectGetMidX(_btn.frame), CGRectGetMidY(_btn.frame)-40);
    [self.view addSubview:self.activityIndicatorView];
}

- (void)shakeButton
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @1000;
    positionAnimation.springBounciness = 20;
//    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
//        self.button.userInteractionEnabled = YES;
//    }];
    [self.btn.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)changeSize:(UITapGestureRecognizer*)tap{
    //用POPSpringAnimation 让viewBlue实现弹性放大缩小的效果
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    
    CGRect rect = _springView1.frame;
    if (rect.size.width==100) {
        springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(300, 300)];
    }
    else{
        springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(100, 100)];
    }
    
    
    //弹性值
    springAnimation.springBounciness = 20.0;
    //弹性速度
    springAnimation.springSpeed = 20.0;
    
    [_springView1.layer pop_addAnimation:springAnimation forKey:@"changesize"];
    
}

- (void)changePosition:(UITapGestureRecognizer*)tap{
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    
    CGPoint point = _springView2.center;
    
    if (point.y==240) {
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 0)];
    }
    else{
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 240)];
    }
    
    //弹性值
    springAnimation.springBounciness = 20.0;
    //弹性速度
    springAnimation.springSpeed = 20.0;
    
    [_springView2 pop_addAnimation:springAnimation forKey:@"changeposition"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
