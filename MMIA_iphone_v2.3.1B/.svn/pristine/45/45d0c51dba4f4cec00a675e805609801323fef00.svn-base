//
//  MMIToast.m
//  MMIA
//
//  Created by Free on 14-6-15.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMIToast.h"

#pragma mark - MMiaLoadingView

@implementation MMiaLoadingView

- (id)initWithView:(UIView*)view
{
    self = [self initWithFrame:CGRectMake( 0, (CGRectGetHeight(view.bounds) - 25)/2, CGRectGetWidth(view.bounds), 25 )];
    if (self)
    {
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( CGRectGetWidth(self.bounds)/3, CGRectGetHeight(self.bounds) / 2 + 10, 20, 20)];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:activity];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(activity.frame)-10, activity.frame.origin.y, CGRectGetWidth(self.bounds) / 2, 20)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"正在加载...";
        [self addSubview:lbl];
        
        [activity startAnimating];
        
        /*
        // 留着加载动画用
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"加载动画.gif" ofType:nil];
        SCGIFImageView* gifImageView = [[SCGIFImageView alloc] initWithGIFFile:filePath];
        gifImageView.frame = CGRectMake(0, 0, gifImageView.image.size.width/2, gifImageView.image.size.height/2);
        gifImageView.center = self.center;
        [self addSubview:gifImageView];
         */
    }
    return self;
}

- (id)initWithView:(UIView*)view center:(CGPoint)centerPoint
{
    self = [self initWithFrame:CGRectMake( centerPoint.x, centerPoint.y, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds)/3 )];
    if (self)
    {
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( CGRectGetWidth(self.bounds)/3, CGRectGetHeight(self.bounds) / 2 + 10, 20, 20)];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:activity];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(activity.frame)-10, activity.frame.origin.y, CGRectGetWidth(self.bounds) / 2, 20)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"正在加载...";
        [self addSubview:lbl];
        
        [activity startAnimating];
    }
    return self;
}

- (void)show:(BOOL)animated
{
}

- (void)hide:(BOOL)animated
{
    [self removeFromSuperview];
}

+ (id)showLoadingForView:(UIView*)view
{
    MMiaLoadingView* hud = [[MMiaLoadingView alloc] initWithView:view];
    [view addSubview:hud];
    return hud;
}

+ (id)showLoadingForView:(UIView*)view center:(CGPoint)centerPoint
{
    MMiaLoadingView* hud = [[MMiaLoadingView alloc] initWithView:view center:centerPoint];
    [view addSubview:hud];
    return hud;
}

+ (void)hideLoadingForView:(UIView*)view
{
    for (UIView* subView in [view subviews])
    {
        if ([subView isKindOfClass:[MMiaLoadingView class]])
        {
            [subView removeFromSuperview];
            return;
        }
    }
}

@end

#pragma mark - MMIAutoAlertView

static const CGFloat AlertViewWidth = 170.0;
static const CGFloat AlertViewContentMargin = 9;
static const CGFloat AlertViewVerticalElementSpace = 10;

@implementation MMIAutoAlertView

+ (instancetype)showWithText:(NSString *)text
                   topOffset:(CGFloat)topOffset
                bottomOffset:(CGFloat)bottomOffset
                       image:(NSString *)imageStr
{
    return [[self class] showWithText:text topOffset:topOffset bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION image:imageStr];
}

+ (instancetype)showWithText:(NSString *)text
                   topOffset:(CGFloat)topOffset
                bottomOffset:(CGFloat)bottomOffset
                    duration:(CGFloat)duration
                       image:(NSString *)imageStr
{
    MMIAutoAlertView *toast = [[MMIAutoAlertView alloc] initWithText:text
                                           topOffset:topOffset
                                        bottomOffset:bottomOffset
                                            duration:duration
                                               image:imageStr] ;
    [toast show];
    
    return toast;
}

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows)
    {
        if (window.windowLevel == windowLevel)
        {
            return window;
        }
    }
    return nil;
}

- (id)initWithText:(NSString *)text
         topOffset:(CGFloat)topOffset
      bottomOffset:(CGFloat)bottomOffset
          duration:(CGFloat)duration
             image:(NSString *)imageStr
{
    self = [super init];
    if( self )
    {
        self.alertWindow = [self windowWithLevel:UIWindowLevelAlert];
        
        if( !self.alertWindow )
        {
            self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.alertWindow.windowLevel = UIWindowLevelAlert;
            self.alertWindow.backgroundColor = [UIColor clearColor];
        }
        [self.alertWindow addSubview:self];
        
        self.duration = duration;
        
        self.frame = CGRectMake(0, kStatusBarHeight + topOffset, Main_Screen_Width, Main_Screen_Height - kStatusBarHeight - topOffset - bottomOffset);

//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        self.backgroundColor = [UIColor clearColor];
        
        self.alertView = [[UIView alloc] init];
//        self.alertView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
        self.alertView.backgroundColor = [UIColor colorWithRed:0xE8/255.0 green:0xE6/255.0 blue:0xE6/255.0 alpha:1.0];//[UIColor colorWithRed:0xCE/255.0 green:0x21/255.0 blue:0x2A/255.0 alpha:1.0]; 红色
        self.alertView.layer.cornerRadius = 8.0;
        self.alertView.layer.opacity = .95;
        self.alertView.clipsToBounds = YES;
        [self addSubview:self.alertView];
        
        CGFloat messageLabelX = AlertViewContentMargin;
        
        if( imageStr )
        {
            self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
            
            self.imageView.frame = CGRectMake(AlertViewContentMargin, AlertViewVerticalElementSpace, self.imageView.frame.size.width, self.imageView.frame.size.height);
            self.imageView.center = CGPointMake(AlertViewContentMargin + self.imageView.frame.size.width / 2, AlertViewVerticalElementSpace + self.imageView.frame.size.height / 2);
            
            [self.alertView addSubview:self.imageView];
            
            messageLabelX += self.imageView.frame.size.width + AlertViewContentMargin;
        }

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageLabelX, AlertViewVerticalElementSpace, AlertViewWidth - messageLabelX - AlertViewContentMargin, 44)];
        self.titleLabel.text = text;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.frame = [self adjustLabelFrameHeight:self.titleLabel];
        [self.alertView addSubview:self.titleLabel];
        
        CGFloat totalHeight = self.titleLabel.frame.size.height + AlertViewVerticalElementSpace * 2;
        self.alertView.bounds = CGRectMake(0, 0, AlertViewWidth, 150);
        self.alertView.frame = CGRectMake(self.alertView.frame.origin.x,
                                          self.alertView.frame.origin.y,
                                          AlertViewWidth,
                                          totalHeight);
        self.alertView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    
    return self;
}

- (CGRect)adjustLabelFrameHeight:(UILabel *)label
{
    CGSize size = [label.text sizeWithFont:label.font
                         constrainedToSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                             lineBreakMode:NSLineBreakByWordWrapping];
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, size.height);
}

- (void)show
{
    [self.alertWindow makeKeyAndVisible];
    [self showAnimation];
    [self performSelector:@selector(dismissToast) withObject:nil afterDelay:self.duration];
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
    
    [self.alertView.layer addAnimation:animation forKey:@"showAlert"];
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
    
    [self.alertView.layer addAnimation:animation forKey:@"dismissAlert"];
}

- (void)dismissToast
{
    [self dismissAnimation];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.alertWindow setHidden:YES];
        [self.alertView removeFromSuperview];
        [self.alertWindow removeFromSuperview];
        self.alertWindow = nil;
    }];
}

@end
// yhx end

#pragma mark - MMIToast

@implementation MMIToast

+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_  image:(NSString *)imageStr_{
     //[MMIToast showWithText:text_  topOffset:topOffset_ duration:DEFAULT_DISPLAY_DURATION ];
    [MMIToast showWithText:text_ topOffset:topOffset_ duration:DEFAULT_DISPLAY_DURATION image:imageStr_];
}

+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_
            duration:(CGFloat)duration_ image:(NSString *)imageStr_{
    
    MMIToast *toast = [[MMIToast alloc] initWithText:text_  image:imageStr_] ;
    [toast setDuration:duration_];
    [toast showFromTopOffset:topOffset_];
}

- (void)showFromTopOffset:(CGFloat)top_{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    /*
     _contentView.center=CGPointMake(window.center.x, top_+_contentView.frame.size.height/2);

     */
        _contentView.center=CGPointMake(window.center.x, top_-_contentView.frame.size.height/2);
    [window addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
    
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = window.center;
    [window  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}

- (void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    _contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)setDuration:(CGFloat) duration_{
    _duration = duration_;
}

- (id)initWithText:(NSString *)text_  image:(NSString *)imageStr_{
    if (self=[super init]) {
        _text=[text_ copy];
        UIFont *font=[UIFont boldSystemFontOfSize:14];
        
        CGSize textSize = [_text sizeWithFont:font
                            constrainedToSize:CGSizeMake(280, MAXFLOAT)
                                lineBreakMode:NSLineBreakByWordWrapping];
        UIImageView *imageView=[[UIImageView alloc]init];
        if (imageStr_) {
            imageView.frame=CGRectMake(5, 10, 20, 20);
            imageView.image=[UIImage imageNamed:imageStr_];
        }else{
            imageView.frame=CGRectMake(5, 10, 0, 0);
            
        }
       // UIImage *image=[UIImage imageNamed:imageStr_];
        //imageView.frame=CGRectMake(5, 5, image.size.width, image.size.height);
        
        //imageView.image=image;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width, 10, textSize.width + 12, 20)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = _text;
        textLabel.numberOfLines = 0;
        if ([[_text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
        {
            textLabel.frame = CGRectMake(5, 5, 0, 0);
        }
        
        _contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width+10+imageView.frame.size.width, 40)];
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.layer.borderWidth = 1.0f;
        _contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        _contentView.backgroundColor = [UIColor colorWithRed:0.2f
                                                       green:0.2f
                                                        blue:0.2f
                                                       alpha:0.75f];\
        [_contentView addSubview:imageView];
        
        [_contentView addSubview:textLabel];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_contentView addTarget:self
                         action:@selector(toastTaped:)
               forControlEvents:UIControlEventTouchDown];
        _contentView.alpha = 0.0f;
        
        _duration = DEFAULT_DISPLAY_DURATION;
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:[UIDevice currentDevice]];
         */
        
    }
    return self;
}

- (void)deviceOrientationDidChanged:(NSNotification *)notify_{
    [self hideAnimation];
}

- (void)toastTaped:(UIButton *)sender_{
    [self hideAnimation];
    
}

- (void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    _contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)dismissToast{
    [_contentView removeFromSuperview];
}

@end
