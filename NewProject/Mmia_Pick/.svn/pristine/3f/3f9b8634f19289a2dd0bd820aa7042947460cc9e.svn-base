//
//  UtilityFunction.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "UtilityFunction.h"
#import "UtilityMacro.h"

@implementation UtilityFunction

+ (NSString *)documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)cachesPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)applicationSupportPath
{
    return [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)directoryPath:(NSString*)path
{
    NSFileManager* fileManager = DefaultFileManager;
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma mark UUID

+ (NSString *)createUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString* uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    
    //把时间戳的36进制反向编码与机型等信息放到GUID中
    long long int timestamp = (long long int)[[NSDate date]timeIntervalSince1970];
    NSMutableString* timeInfo = [self base36EncodeReverse:timestamp];
    
    NSString* deviceInfo = appModel;
    deviceInfo = [deviceInfo uppercaseString];
    NSMutableString* MMiaGUID = [[NSMutableString alloc] init];
    deviceInfo = [deviceInfo stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString* deviceType = @"X";
    if( [deviceInfo hasPrefix:@"IPAD"] )
    {
        deviceType = @"D";
        deviceInfo = [deviceInfo stringByReplacingOccurrencesOfString:@"IPAD" withString:@""];
    }
    else if( [deviceInfo hasPrefix:@"IPHONE"] )
    {
        deviceType = @"E";
        deviceInfo = [deviceInfo stringByReplacingOccurrencesOfString:@"IPHONE" withString:@""];
    }
    else if( [deviceType hasPrefix:@"IPOD"] )
    {
        deviceType = @"H";
        deviceInfo = [deviceInfo stringByReplacingOccurrencesOfString:@"IPOD" withString:@""];
    }
    
    NSString* deviceVer = @"00";
    if( ![deviceType isEqual:@"X"] )
    {
        deviceVer = [NSString stringWithFormat:@"%02X",deviceInfo.intValue];
    }
    
    //前6位是36进制的反向时间戳
    [MMiaGUID appendString:timeInfo];
    //后2位是16进制的Model版本
    [MMiaGUID appendString:deviceVer];
    [MMiaGUID appendString:@"-"];
    //后1位是设备类型
    [MMiaGUID appendString:deviceType];
    //后面是生成的GUID
    [MMiaGUID appendString:[uuid substringFromIndex:10]];
    
    uuid = MMiaGUID;
    
    return uuid;
}

+ (NSString *)createNoDashUUID
{
    return [[self createUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+ (NSString *)createNoDashUUIDLowercase:(BOOL)lowercase;
{
    NSString* uuid = [self createNoDashUUID];
    if (lowercase)
        [uuid lowercaseString];
    return uuid;
}

+ (NSMutableString *)base36EncodeReverse:(long long int)num
{
    NSString *alphabet = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *str = [[NSMutableString alloc] init];
    while (num > 0)
    {
        [str appendString:[alphabet substringWithRange:NSMakeRange(num % 36, 1 )]];
        num /= 36;
    }
    
    return  str;
}

@end
