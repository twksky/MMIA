//
//  MMIProcessView.m
//  MMIA
//
//  Created by Free on 14-6-16.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMIProcessView.h"
#import <QuartzCore/QuartzCore.h>
#import "FrameMacro.h"

#define circleLineWidth  4.0f


@interface AnimationView : UIView

@end

@implementation AnimationView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGFloat colorAlpha=0.0f;
    CGContextRef context=UIGraphicsGetCurrentContext();
    for (int i=0; i<200; i++) {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1.0f alpha:colorAlpha].CGColor);
        CGContextSetLineWidth(context, circleLineWidth);
        CGContextAddArc(context, self.frame.size.width/2.0f, self.frame.size.height/2.0f, self.frame.size.width/2.0f-circleLineWidth/2.0, i*(2*M_PI/200), (i+1)*(2*M_PI/200), 0);
        CGContextStrokePath(context);
        colorAlpha += 1.0f/10;


    }
    
}

@end

@implementation MMIProcessView{
    AnimationView *_animationView;
    NSString *_message;
    UILabel *_textLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithMessage:(NSString *)message top:(NSInteger)height{
    if (self=[super init]) {
        _message=message;
        _height=height;
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    self.frame = CGRectMake(0, 0, App_Frame_Width, Main_Screen_Height);
    self.backgroundColor=[UIColor clearColor];
  //  _textLabel.frame=CGRectMake(40, 40, self.bounds.size.width, self.bounds.size.height);
    _textLabel=[[UILabel alloc]init];
    _textLabel.backgroundColor=[UIColor clearColor];
    _textLabel.textAlignment=NSTextAlignmentLeft;
    _textLabel.font=[UIFont systemFontOfSize:16];
    _textLabel.textColor=[UIColor whiteColor];
    _textLabel.text=_message;
    _textLabel.numberOfLines=0;
    CGFloat textWidth = [_message sizeWithFont:_textLabel.font
                        constrainedToSize:CGSizeMake(MAXFLOAT,40 )
                            lineBreakMode:NSLineBreakByWordWrapping].width;
    _textLabel.frame=CGRectMake(50, 0, textWidth, 40);
   
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50+textWidth+10, 40)];
    
    
   _bgView.layer.cornerRadius = 5.0f;
    _bgView.layer.borderWidth = 1.0f;
    _bgView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
   _bgView.backgroundColor = [UIColor colorWithRed:0.2f
                                                   green:0.2f
                                                    blue:0.2f
                                                   alpha:0.75f];\
  
    //_bgView.center=self.center;
 _bgView.center=CGPointMake(self.center.x,_height-40);
    
   // _textLabel=[[UILabel alloc]initWithFrame:_bgView.bounds];
   
    [_bgView addSubview:_textLabel];
    
    _animationView=[[AnimationView alloc]initWithFrame:CGRectMake(10,5 , 30, 30)];
    _animationView.backgroundColor=[UIColor clearColor];
    [_bgView addSubview:_animationView];
    [self addSubview:_bgView];
    
    
}

-(void)showInRootView:(UIView *)rootView{
    /*
    self.frame=CGRectMake((rootView.frame.size.width-200)/2.0f, 150, 200, 40);
     _textLabel.frame = self.bounds;
    _textLabel.frame=CGRectMake(80, 0, self.bounds.size.width, self.bounds.size.height);
     _animationView.frame = CGRectMake((self.frame.size.width/2.0f-40)/2.0f, (self.frame.size.height-40)/2.0f, 40, 40);
     */
    [self animationImageViewStartAniamtion];
   
   [rootView addSubview:self];
    
    
}
- (void)animationImageViewStartAniamtion
{
    if (!_animationView) {
        return;
    }
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;
    
    //Do a series of 5 quarter turns for a total of a 1.25 turns
    //(2PI is a full turn, so pi/2 is a quarter turn)
    [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
    rotate.repeatCount =  1e100;
    
    rotate.duration = 0.25;
    //            rotate.beginTime = start;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [_animationView.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

- (void)animationImageViewStopAniamtion
{
    [_animationView.layer removeAllAnimations];
}
-(void)dismiss{
  
    [self removeFromSuperview];
    [self animationImageViewStopAniamtion];
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
