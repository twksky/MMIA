//
//  GlobalNetwork.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define CHANNEL_ID @"mmia.appstore"


@interface MMiaNetworkEngine : AFHTTPSessionManager

typedef void (^JsonObjectResponseBlock)(AFHTTPRequestOperation *operation, NSDictionary* responseDict);
typedef void (^ErrorBlock)(AFHTTPRequestOperation *operation, NSError* error);


//初始化
+ (MMiaNetworkEngine *)sharedInstance;

// 发起post类型网络请求公共入口
- (void)startPostAsyncRequestWithUrl:(NSString*)url param:(id)param completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(ErrorBlock) errorBlock;

// 发起get类型网络请求公共入口
- (void)startGetAsyncRequestWithUrl:(NSString*)url param:(id)param completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(ErrorBlock) errorBlock;

@end
