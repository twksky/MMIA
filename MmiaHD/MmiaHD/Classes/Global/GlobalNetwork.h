//
//  GlobalNetwork.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

#define CHANNEL_ID @"mmia.appstore"


@interface MMiaNetworkEngine : MKNetworkEngine

typedef void (^JsonObjectResponseBlock)(NSDictionary* response);
typedef void (^ErrorBlock)(NSString* error);

// 发起网络请求公共入口
- (void)startAsyncRequestWithUrl:(NSString*)url param:(id)param requestMethod:(NSString*)method completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock;

@end
