//
//  GlobalNetwork.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "GlobalNetwork.h"
#import "AdditionHeader.h"

@implementation MMiaNetworkEngine

- (void)startAsyncRequestWithUrl:(NSString*)url param:(id)param requestMethod:(NSString*)method completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock
{
    NSMutableDictionary *_param = [self getMMiaApiCommonReqParam];
    
    if( param )
    {
        if( [param isDictionary] )
        {
            [_param addEntriesFromDictionary:param];
        }
    }
   // NSLog( @"dictParam = %@", _param );
    
    MKNetworkOperation *op = [self operationWithPath:url params:_param httpMethod:method];
    op.shouldNotCacheResponse = YES;
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            
            handleDataBlock(jsonObject);
        }];
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

- (void)cancelAllOperations
{
    [super cancelAllOperations];
    
}

- (NSMutableDictionary *) getMMiaApiCommonReqParam
{
    static NSMutableDictionary *param = nil;
    @try {
        if( !param )
        {
            param = [ [NSMutableDictionary  alloc] init];
            NSString* guid = [UtilityFunction createUUID];
            if( !guid )
            {
                guid = @"create_guid_failed";
            }
            NSString* model = appModel;
            if( !model )
            {
                model = @"unknown";
            }
            NSString* sysVer = NSStringFloat(iOSVersion);
            if( !sysVer )
            {
                sysVer = @"unknown";
            }
            NSString* sysName = iOSName;
            if( !sysName )
            {
                sysName = @"unknown";
            }
            // APP当前版本号
            NSString* versionStr = aPPVersion;
            
            [param setObject:[NSNumber numberWithInt:1] forKey:@"apiVersion"];
            [param setObject:versionStr forKey:@"clientVersion"];
            [param setObject:sysName forKey:@"clientType"];
            [param setObject:guid forKey:@"guid"];
            [param setObject:sysVer forKey:@"osVersion"];
            [param setObject:CHANNEL_ID forKey:@"channel"];
            [param setObject:model forKey:@"deviceType"];
        }
    }
    @catch (NSException *exception)
    {
    }
    return [[NSMutableDictionary alloc] initWithDictionary:param];
}

@end