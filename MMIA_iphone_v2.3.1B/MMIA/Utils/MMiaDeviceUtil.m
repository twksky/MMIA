//
//  MMiaDeviceUtil.m


#import "MMiaDeviceUtil.h"
#import <sys/utsname.h>
#import "SSKeychain.h"

static NSString* sDeviceUUID = nil;
static NSString* sDeviceSysVer = nil;
static NSString* sDeviceModel = nil;
static NSString* sCurVersionStr = nil;
static NSString* sCurVersionNum = nil;
static NSString* sDeviceSysName =  nil;

@implementation MMiaDeviceUtil

+ (NSMutableString *)base36EncodeReverse:(long long int)num
{
    NSString *alphabet = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *str = [[NSMutableString alloc] init];
    while (num > 0) {
        [str appendString:[alphabet substringWithRange:NSMakeRange(num % 36, 1 )]];
        num /= 36;
    }
    
    return  str;
}

+(long long int)base32Decode:(NSString*)string
{
    long long int num = 0;
    NSString * alphabet = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    for (int i = 0, len = [string length]; i < len; i++)
    {
        NSRange range = [alphabet rangeOfString:[string substringWithRange:NSMakeRange(i,1)]];
        num = num * 36 + range.location;
    }
    
    return num;
}

+ (NSString *)getUUID
{
    if (sDeviceUUID) {
        return sDeviceUUID;
    }
    
    NSString *sKeyServiceName = @"com.refanqie.refanqie";
    NSString *sKeyAccountName = @"device_uuid";
    
    sDeviceUUID = [SSKeychain passwordForService:sKeyServiceName account:sKeyAccountName];
    if (!sDeviceUUID || [sDeviceUUID isEqualToString:@""])
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef strUUID = CFUUIDCreateString(NULL, uuidRef);
        sDeviceUUID = [NSString stringWithFormat:@"%@",strUUID];
        CFRelease(strUUID);
        CFRelease(uuidRef);
        
        //把时间戳的36进制反向编码与机型等信息放到GUID中
        long long int timestamp = (long long int)[[NSDate date]timeIntervalSince1970];
        NSMutableString* timeInfo = [self base36EncodeReverse:timestamp];
        
        NSString* deviceInfo = [self getDeviceModel];
        deviceInfo = [deviceInfo uppercaseString];
        NSMutableString* MMiaGUID = [[NSMutableString alloc] init];
        deviceInfo = [deviceInfo stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString* deviceType = @"X";
        if ([deviceInfo hasPrefix:@"IPAD"]) {
            deviceType = @"D";
            deviceInfo = [deviceInfo stringByReplacingOccurrencesOfString:@"IPAD" withString:@""];
        }else if([deviceInfo hasPrefix:@"IPHONE"]){
            deviceType = @"E";
            deviceInfo = [deviceInfo stringByReplacingOccurrencesOfString:@"IPHONE" withString:@""];
        }else if([deviceType hasPrefix:@"IPOD"]){
            deviceType = @"H";
            deviceInfo = [deviceInfo stringByReplacingOccurrencesOfString:@"IPOD" withString:@""];
        }
        
        NSString* deviceVer = @"00";
        if (![deviceType isEqual:@"X"]) {
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
        [MMiaGUID appendString:[sDeviceUUID substringFromIndex:10]];
        
        sDeviceUUID = MMiaGUID;
        
        [SSKeychain setPassword:sDeviceUUID forService:sKeyServiceName account:sKeyAccountName];
    }
    
    return sDeviceUUID;
}

+ (NSString *)getDeviceSysName
{
    if (sDeviceSysName) {
        return sDeviceSysName;
    }
    
    sDeviceSysName = [[UIDevice currentDevice] systemName];
    return sDeviceSysName;
}

+ (NSString *)getDeviceSysVer
{
    if (sDeviceSysVer) {
        return sDeviceSysVer;
    }
    
    sDeviceSysVer = [[UIDevice currentDevice] systemVersion];
    return sDeviceSysVer;
}

+ (NSString *)getDeviceModel
{
    if (sDeviceModel) {
        return sDeviceModel;
    }
    
    struct utsname systemInfo;
    uname(&systemInfo);
    sDeviceModel = [NSString stringWithCString:systemInfo.machine
                                      encoding:NSUTF8StringEncoding];
    return sDeviceModel;
}

+ (NSString *)getCurVersionStr
{
    if (sCurVersionStr) {
        return sCurVersionStr;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    sCurVersionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return sCurVersionStr;
}

+ (NSString *)getCurVersionNum
{
    if (sCurVersionNum) {
        return sCurVersionNum;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    sCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    return sCurVersionNum;
}

@end
