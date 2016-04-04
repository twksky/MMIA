//
//  MmiaCommonUtil.h
//  MmiaHD
//
//  Created by twksky on 15/4/10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MmiaTextViewUtil.h"

@interface MmiaCommonUtil : NSObject<UITextViewDelegate>

+ (CGFloat)getTextHeightWithFontOfSize:(CGFloat)fontSize string:(NSString *)labelString;

+ (UIColor *)UIColorFromRGB:(int)rgbValue;


+ (UIButton *)initializeButtonWithFrame:(CGRect)rect title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)titleColor  backgroundImageNamed:(NSString *)bgImage image:(NSString *)image andSuperView:(UIView *)superView andBtnTag:(NSInteger)tag;

+ (UIButton *)initializeButtonWithFrame:(CGRect)rect title:(NSString *)title titleFont:(UIFont *)font selectImageNamed:(NSString *)selectImage nomalImage:(NSString *)nomalImage andSelected:(BOOL)selected andSuperView:(UIView *)superView andBtnTag:(NSInteger)tag ;


+ (UIButton *)initializeButtonWithFrame:(CGRect)rect title:(NSString *)title titleFont:(UIFont *)font imageNamed:(NSString *)imagesNamed andSuperView:(UIView *)superView andBtnTag:(NSInteger)tag;


+ (void)initializeImageViewWithFrame:(CGRect)rect imageNamed:(NSString *)imagesNamed andSuperView:(UIView *)superView andTag:(NSInteger)tag ;

+ (void)initializeTextFieldWithFrame:(CGRect)rect andTag:(NSInteger)tag andPlaceholder:(NSString *)placeholder andSecureTextEntry:(BOOL)secureTextEntry andSuperView:(UIView *)superView ;

//+ (void)initializeTextFieldWithFrame:(CGRect)rect andTag:(NSInteger)tag andPlaceholder:(NSString *)placeholder andSecureTextEntry:(BOOL)secureTextEntry andSuperView:(UIView *)superView;

+  (UILabel *)initializeLabelWithFrame:(CGRect)rect text:(NSString *)text textFont:(UIFont *)font  textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment andbgColor:(UIColor *)bgColor   andSuperView:(UIView *)superView andTag:(NSInteger)tag;

+ (void)initializeLabelWithFrame:(CGRect)rect text:(NSString *)text textFont:(UIFont *)font  textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment andSuperView:(UIView *)superView andTag:(NSInteger)tag;

+ (void)initializeMMIaTextViewWithFrame:(CGRect)rect  tag:(NSInteger)tag andTextPlaceholder:(NSString *)placeholder andText:(NSString *)text andSuperView:(UIView *)superView;


@end
