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

@interface UIMenuBarItem : NSObject
{
    NSString    *_title;
    UIImage     *_image;
    id           _target;
    SEL          _action;
    UIControl   *_containView;
    UIImageView *_imageView;
    UILabel     *_titleLabel;
    CGFloat     _sizeValue;
    
}

@property (nonatomic) SEL action;
@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) UIImage *image;
@property (nonatomic, retain) UIControl *containView;
@property (nonatomic, readonly) CGFloat sizeValue;

- (id)initWithTitle:(NSString *)title
             target:(id)target
              image:(UIImage *)image
             action:(SEL)action tag:(NSInteger)tag;

@end
