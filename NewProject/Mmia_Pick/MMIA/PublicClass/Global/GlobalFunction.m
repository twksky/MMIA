//
//  GlobalFunction.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "GlobalFunction.h"
#import "UtilityFunction.h"
#import "GlobalKey.h"
#import "GlobalDef.h"
#import "AdditionHeader.h"

@implementation GlobalFunction

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

+ (UIView *)selectedViewForTableViewCell:(UITableViewCell *)cell
{
    UIView* view = [[UIView alloc] initWithFrame:cell.frame];
    view.backgroundColor = ColorWithHexRGB(0xebebeb);
    
    return view;
}

+ (NSString *)directoryPathWithFileName:(NSString *)fileName
{
    NSString* filePath = [[UtilityFunction documentsPath] stringByAppendingPathComponent:MmiaFileKey];
    NSString* directoryPath = [[UtilityFunction directoryPath:filePath] stringByAppendingPathComponent:fileName];
    
    return directoryPath;
}


+ (CGSize)getTextSizeWithSystemFont:(UIFont *)font ConstrainedToSize:(CGSize)size string:(NSString *)labelString
{
    CGSize fitSize = CGSizeMake(0, 0);
    if( labelString.length > 0 )
    {
        if (iOS7Later)
        {
            fitSize = [labelString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        }else
        {
            fitSize = [labelString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        }
        
    }
    return fitSize;
}


@end
