//
//  MMiaCommonUtil.m
//  NewMMia
//
//  Created by zixun on 5/27/14.
//  Copyright (c) 2014 com.zixun. All rights reserved.
//

#import "MMiaCommonUtil.h"

void MyNSLog(NSString* log, ...)
{
#if DEBUG
    va_list args;
    va_start(args, log);
    
    NSLogv(log, args);
    
    va_end(args);
#else
#endif
}

@implementation MMiaCommonUtil

+ (CGFloat)getTextHeightWithFontOfSize:(CGFloat)fontSize string:(NSString *)labelString
{
    CGSize size = CGSizeMake(0, 0);
    if( labelString.length > 0 )
    {
        size = [labelString sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(Homepage_Cell_Image_Width - 12, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return size.height;
}

+ UIColorFromRGB:(int)rgbValue{
    
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:1.0];

}


//button
+ (UIButton *)initializeButtonWithFrame:(CGRect)rect title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)titleColor  backgroundImageNamed:(NSString *)bgImage image:(NSString *)image andSuperView:(UIView *)superView andBtnTag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    if (title!=nil){
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = font;
        if (titleColor) {
            [button setTitleColor:titleColor forState:UIControlStateNormal];
        }
        //添加logo视图   //all_29   256x64
    }
    if (image!=nil) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (bgImage != nil) {
        [button setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    }
    button.backgroundColor = [UIColor clearColor];
    button.tag = tag;
    [superView addSubview:button];
    //    NSLog(@"-------%p---%@",button,button);
    return button;
    
}



+ (UIButton *)initializeButtonWithFrame:(CGRect)rect title:(NSString *)title titleFont:(UIFont *)font selectImageNamed:(NSString *)selectImage nomalImage:(NSString *)nomalImage andSelected:(BOOL)selected andSuperView:(UIView *)superView andBtnTag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    if (title!=nil){
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = font;
        //添加logo视图   //all_29   256x64
    }
    if (nomalImage!=nil) {
        [button setBackgroundImage:[UIImage imageNamed:nomalImage] forState:UIControlStateNormal];
    }
    if (selectImage != nil) {
        [button setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    }if (selected == YES) {
        button.selected = YES;
    }
    button.backgroundColor = [UIColor clearColor];
    button.tag = tag;
    [superView addSubview:button];
    //    NSLog(@"-------%p---%@",button,button);
    return button;
    
}


+ (UIButton *)initializeButtonWithFrame:(CGRect)rect title:(NSString *)title titleFont:(UIFont *)font imageNamed:(NSString *)imagesNamed andSuperView:(UIView *)superView andBtnTag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    if (title!=nil){
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = font;
        //添加logo视图   //all_29   256x64
    }
    button.backgroundColor = [UIColor clearColor];
    button.tag = tag;
    if (imagesNamed!=nil) {
        [button setBackgroundImage:[UIImage imageNamed:imagesNamed] forState:UIControlStateNormal];
    }
    
    [superView addSubview:button];
    return button;
}


+ (void)initializeImageViewWithFrame:(CGRect)rect imageNamed:(NSString *)imagesNamed andSuperView:(UIView *)superView andTag:(NSInteger)tag
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:rect];
    if (imagesNamed) {
        imageView.image=[UIImage imageNamed:imagesNamed];
    }
    imageView.userInteractionEnabled = YES;
    if (tag!=0) {
        imageView.tag = tag;
    }
    imageView.clipsToBounds = YES;
    //    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor clearColor];
    [superView addSubview:imageView];
    //    NSLog(@"-------%p---%@",imageView,imageView);
    
}


+ (void)initializeTextFieldWithFrame:(CGRect)rect andTag:(NSInteger)tag andPlaceholder:(NSString *)placeholder andSecureTextEntry:(BOOL)secureTextEntry textFont:(UIFont *)textFont andSuperView:(UIView *)superView
{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate =self;
    if (tag!=0) {
        textField.tag = tag;
    }
    if (placeholder!=nil) {
        textField.placeholder = placeholder;
    }
    
    if (secureTextEntry) {
        textField.secureTextEntry = secureTextEntry;
    }
    
    if (textFont) {
        textField.font = textFont;
    }
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [superView addSubview:textField];
    //    NSLog(@"-------%p---%@",textField,textField);
    
    
}


+ (void)initializeTextFieldWithFrame:(CGRect)rect andTag:(NSInteger)tag andPlaceholder:(NSString *)placeholder andSecureTextEntry:(BOOL)secureTextEntry andSuperView:(UIView *)superView
{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.backgroundColor = [UIColor clearColor];
    textField.font=[UIFont systemFontOfSize:16];
    if (tag!=0) {
        textField.tag = tag;
    }
    if (placeholder!=nil) {
        textField.placeholder = placeholder;
    }
    if (secureTextEntry) {
        textField.secureTextEntry = secureTextEntry;
    }
    
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [superView addSubview:textField];
}


//无边角label
+ (void)initializeLabelWithFrame:(CGRect)rect text:(NSString *)text textFont:(UIFont *)font  textColor:(UIColor *)textColor textAlignment:(MMIATextAlignment)textAlignment andSuperView:(UIView *)superView andTag:(NSInteger)tag
{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    if (text!=nil) {
        label.text = text;
    }
    if (font!=nil) {
        label.font = font;
    }
   // label.numberOfLines = 0;
    //    NSTextAlignment
    
    label.textAlignment = textAlignment;
    //label.backgroundColor=[UIColor redColor];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor;
    if (tag!=0) {
        label.tag = tag;
    }

    [superView addSubview:label];
    //    NSLog(@"-------%p---%@",label,label);
    
}


//设置边角的label
+ (UILabel *)initializeLabelWithFrame:(CGRect)rect text:(NSString *)text textFont:(UIFont *)font  textColor:(UIColor *)textColor textAlignment:(MMIATextAlignment)textAlignment andbgColor:(UIColor *)bgColor   andSuperView:(UIView *)superView andTag:(NSInteger)tag
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    if (text!=nil) {
        label.text = text;
    }
    if (font!=nil) {
        label.font = font;
    }
    label.numberOfLines = 0;
    label.textAlignment = textAlignment;
    label.backgroundColor = [UIColor clearColor];
    if (textColor) {
        label.textColor = textColor;
    }
    if (bgColor) {
        label.backgroundColor = bgColor;
    }
    if (tag!=0) {
        label.tag = tag;
    }
    [superView addSubview:label];
    
    return label;
}
+ (void)initializeMMIaTextViewWithFrame:(CGRect)rect  tag:(NSInteger)tag andTextPlaceholder:(NSString *)placeholder andText:(NSString *)text andSuperView:(UIView *)superView
{
    MMIaTextViewUtil *textView = [[MMIaTextViewUtil alloc]initWithFrame:rect];
   
    if (tag != 0) {
        textView.tag = tag;
    }
    if (text!=nil) {
        textView.text = text;
    }
    if (placeholder !=nil) {
        textView.placeholder = placeholder;
    }
     
    [superView addSubview:textView];
     
}






@end
