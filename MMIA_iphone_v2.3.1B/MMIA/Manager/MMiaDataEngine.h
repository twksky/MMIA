//
//  MMiaDataEngine.h
//  MMIA
//
//  Created by zixun on 6/8/14.
//  Copyright (c) 2014 com.zixun. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface MMiaDataEngine : MKNetworkEngine

typedef void (^JsonObjectResponseBlock)(NSDictionary* response);
typedef void (^ErrorBlock)(NSString* error);

// 发起网络请求公共入口
- (void)startAsyncRequestWithUrl:(NSString*)url param:(id)param requestMethod:(NSString*)method completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock;
@end
