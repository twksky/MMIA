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
/**
 *  计算自适应label的高度 
 * font:字体大小  size:将要放到的size，宽/高为MAXFloat labelString:label.text
 */
+ (CGSize)getTextSizeWithSystemFont:(UIFont *)font ConstrainedToSize:(CGSize)size string:(NSString *)labelString;

@end
