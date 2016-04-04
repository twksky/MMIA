//
//  GlobalFunction.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalFunction : NSObject

void MyNSLog(NSString* log, ...);

+ (UIView *)selectedViewForTableViewCell:(UITableViewCell *)cell;
+ (NSString *)directoryPathWithFileName:(NSString *)fileName;
+ (CGFloat)getTextHeightWithFontOfSize:(CGFloat)fontSize string:(NSString *)labelString;

//lx add
+ (CGFloat)getTextHeightWithSystemFont:(UIFont *)font ConstrainedToSize:(CGSize)size string:(NSString *)labelString;
+ (CGFloat)getTextWidthWithSystemFont:(UIFont *)font ConstrainedToSize:(CGSize)size string:(NSString *)labelString;

@end
