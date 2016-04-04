//
//  NSString+CalculateDate.m
//  MmiaHD
//
//  Created by lixiao on 15/3/26.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "NSString+CalculateDate.h"

@implementation NSString (CalculateDate)

//计算间隔
+ (NSString *)distanceNowTime:(NSTimeInterval)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //  [formatter setDateStyle:NSDateFormatterMediumStyle];
    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *compareDate = [NSDate dateWithTimeIntervalSince1970:timeStr];
//    NSString *confromTimespStr = [formatter stringFromDate:compareDate];
//    NSLog(@"confromTimespStr =  %@",confromTimespStr);
    
    NSTimeInterval timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}


@end
