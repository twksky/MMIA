//
//  GlobalNetwork.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "GlobalNetwork.h"
#import "AdditionHeader.h"


//#ifdef DEBUG
//
NSString *const MmiaHostURL = @"http://218.245.5.171:8011";
//NSString *const MmiaHostURL = @"http://192.0.0.250:8081/Mmia";
//
NSString *const Mmia_SearchByKeyWord = @"/search/getSearchByKeyword";
NSString *const Mmia_SearchBrandByKeyWord = @"/search/getSearchBrandByKeyword";
NSString *const Mmia_ProductListByBrandId = @"/product/getProductListByBrandId/";
NSString *const Mmia_ProductListByCategoryId = @"/product/getProductListByCategoryId/";

NSString *const MmiaHomePageURL = @"/home/getHomeRecommendation/";
NSString *const MmiaCategoryURL = @"/category/getFirstLevelCategory/";

NSString *const MmiaProductDetailURL = @"/product/getProductDetail/";
NSString *const MmiaHomeRecommendListURL = @"/home/getHomeRecommendList/";
//
//#else

//NSString *const MmiaHostURL = @"http://api.mmia.com";
//NSString *const Mmia_SearchByKeyWord = @"/search/getSearchByKeyword";
//NSString *const Mmia_SearchBrandByKeyWord = @"/search/getSearchBrandByKeyword";
//NSString *const Mmia_ProductListByBrandId = @"/product/getProductListByBrandId/";
//NSString *const Mmia_ProductListByCategoryId = @"/product/getProductListByCategoryId/";
//NSString *const MmiaHomeRecommendListURL = @"/home/getHomeRecommendList/";

//#endif



@implementation MMiaNetworkEngine

+ (MMiaNetworkEngine *)sharedInstance
{
    static MMiaNetworkEngine *_netWorkEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netWorkEngine = [[MMiaNetworkEngine alloc]init];
    });
    return _netWorkEngine;    
}

- (void)startPostAsyncRequestWithUrl:(NSString*)url param:(id)param completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(ErrorBlock) errorBlock
{
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableDictionary *_param = [self getMMiaApiCommonReqParam];
    
        if( param )
        {
            if( [param isDictionary] )
            {
                [_param addEntriesFromDictionary:param];
            }
        }
    
    NSMutableString *httpURL = [MmiaHostURL mutableCopy];
    [httpURL appendString:url];
    
    [manager POST:httpURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject){
        
            NSString *responseStr = operation.responseString;
            NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding ];
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        handleDataBlock(operation, responseDic);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        errorBlock(operation,error);
    }];
}

- (void)startGetAsyncRequestWithUrl:(NSString*)url param:(id)param completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(ErrorBlock) errorBlock
{
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *_param = [self getMMiaApiCommonReqParam];
    
    if( param )
    {
        if( [param isDictionary] )
        {
            [_param addEntriesFromDictionary:param];
        }
    }
    
    NSMutableString *httpURL = [MmiaHostURL mutableCopy];
    [httpURL appendString:url];
    
    [manager GET:httpURL parameters:_param success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSString *responseStr = operation.responseString;
        NSData *data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        handleDataBlock(operation, responseDic);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        errorBlock(operation,error);
    }];
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