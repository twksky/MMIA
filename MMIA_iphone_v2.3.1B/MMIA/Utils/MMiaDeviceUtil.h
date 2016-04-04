//
//  MMiaDeviceUtil.h


#import <Foundation/Foundation.h>

@interface MMiaDeviceUtil : NSObject

+ (NSString *)getUUID;
+ (NSString *)getDeviceModel;
+ (NSString *)getDeviceSysName;
+ (NSString *)getDeviceSysVer;
+ (NSString *)getCurVersionStr;
+ (NSString *)getCurVersionNum;
@end
