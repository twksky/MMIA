//
//  UIMenuItem.h
//  TesdXcodeUserGuideDemo
//
//  Created by twk on 15-5-19.
//  Copyright (c) 2015年 tanwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>

// UIBarButtonItem
// UITabBarItem

static CGFloat const Gap = 16.0f;
static CGFloat const OriginX = 16.0f;
static CGFloat const OriginY = 15.0f;

@interface UIMenuBarItem : NSObject
{
    UIImage     *_image;
    id           _target;
    SEL          _action;
    UIButton   *_containView;
    UIImageView *_imageView;
    CGFloat     _sizeValue;
    
}

@property (nonatomic) SEL action;
@property (nonatomic, retain, readonly) UIImage *image;
@property (nonatomic, retain) UIControl *containView;
@property (nonatomic, readonly) CGFloat sizeValue;

- (id)initWithTitle:(NSString *)title
             target:(id)target
              image:(UIImage *)image
             action:(SEL)action tag:(NSInteger)tag;

@end
