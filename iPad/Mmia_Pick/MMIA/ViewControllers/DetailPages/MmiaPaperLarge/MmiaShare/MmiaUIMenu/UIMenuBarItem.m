//
//  UIMenuItem.m
//  TesdXcodeUserGuideDemo
//
//  Created by twk on 15-5-19.
//  Copyright (c) 2015年 tanwenkai. All rights reserved.
//

#import "UIMenuBarItem.h"
#import <QuartzCore/QuartzCore.h>

@interface UIMenuBarItem ()

- (void)setup;
- (void)layOutSubviews;

@end

@implementation UIMenuBarItem

@synthesize image = _image;
@synthesize action = _action;
@synthesize containView = _containView;
@synthesize sizeValue = _sizeValue;

- (id)initWithTitle:(NSString *)title
             target:(id)target
              image:(UIImage *)image
             action:(SEL)action tag:(NSInteger)tag
{
    if(self = [super init]){
        
        _image = [[UIImage imageWithCGImage:image.CGImage] retain];
        _action = action;
        _target = [target retain];
        _containView = [UIButton buttonWithType:UIButtonTypeCustom];
        _containView.frame = CGRectZero;
        [_containView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        _containView.tag = tag;
        _containView.backgroundColor = [UIColor brownColor];
        _sizeValue = ([UIScreen mainScreen].bounds.size.width - 40.0f)/4.0f;
        
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    
    [self layOutSubviews];
    
}





- (void)layOutSubviews
{
    _containView.frame = CGRectMake(0, 0, _sizeValue, _sizeValue);
    //_containView.layer.borderWidth = 1.0f;
    //_containView.layer.borderColor = [[UIColor orangeColor] CGColor];
    _imageView.center = CGPointMake(_containView.center.x,
                                    _containView.center.y-10.f);
    
    
}



@end
