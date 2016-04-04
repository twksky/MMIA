//
//  NBSAppAgent.h
//
//  Created by yang kai on 14-3-12.
//  Copyright (c) 2014年 NBS. All rights reserved.
//


#import "NBSGCDOverrider.h"

@interface NBSAppAgent : NSObject<NSURLConnectionDataDelegate>

+(void)startWithAppID:(NSString*)appId;
+(void)startWithAppID:(NSString*)appId rateOfLaunch:(double) rate;
+(void)startWithAppID:(NSString*)appId location:(BOOL)locationAllowed;
+(void)startWithAppID:(NSString*)appId location:(BOOL)locationAllowed rateOfLaunch:(double) rate;
+(void) setCrashCollectFlg:(BOOL) isCollectCrashInfo;
//
+(void)setIgnoreBlock:(BOOL (^)(NSURLRequest* request)) block;
+(void)setNBSSDKLogFlg:(BOOL)isON;
@end


/*
 Example 1:最简单的
 [NBSAppAgent startWithAppID:@"xxxxxxx"];

 Example 2:指定采样率 50%
 [NBSAppAgent startWithAppID:@"xxxxxxx" rateOfLaunch:0.5f];
 
 Example 3:要求采集位置信息
 [NBSAppAgent startWithAppID:@"xxxxxxx" location:YES];
 
 Example 4:忽略包含127.0.0.1的url
 [NBSAppAgent startWithAppID:@"xxxxxxx"];
 [NBSAppAgent setIgnoreBlock:^BOOL(NSURLRequest* request)
 {
 return [request.URL.absoluteString rangeOfString:@"127.0.0.1"].location!=NSNotFound;//忽略包含127.0.0.1的url
 }
 ];
*/
