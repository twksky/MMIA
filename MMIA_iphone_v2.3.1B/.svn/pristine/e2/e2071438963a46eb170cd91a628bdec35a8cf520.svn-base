//
//  MMiaDataEngine.m
//  MMIA
//
//  Created by zixun on 6/8/14.
//  Copyright (c) 2014 com.zixun. All rights reserved.
//



#import "MMiaDataEngine.h"
#import "../Utils/MMiaDeviceUtil.h"


//Sample request
static NSString  *get_waterfull_lists_url =@"getWaterFullImageList/";

static NSString  *test_login_url =@"login/";
//找回密码
static NSString  *test_get_password_url =@"resetPasswd/";
//找回密码，设置新密码
static NSString  *test_set_newPassWord_url=@"resetPasswd/";



@implementation MMiaDataEngine
//Sample request

-(void) getWaterFullList:(int) start size:(int)size completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock {
    
    NSString *startStr= [NSString stringWithFormat:@"%d",start];
    NSString *sizeStr= [NSString stringWithFormat:@"%d",size];
    
    NSString   *url = [NSString stringWithFormat:get_waterfull_lists_url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            startStr, @"start",
                            sizeStr, @"size",
                            nil];
    
    MKNetworkOperation *op = [self operationWithPath:url params:params httpMethod:@"GET"];
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



-(void) testSendLoginRequest:(NSString*) name password:(NSString*)password  completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock{
    
    
    NSString   *url = [NSString stringWithFormat:test_login_url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name, @"loginName",
                            password, @"password",
                            nil];
    
    MKNetworkOperation *op = [self operationWithPath:url params:params httpMethod:@"POST"];
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

-(void)testSendMailOrPhoneID:(NSString *)mailid URL:(NSString *)url completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:url params:nil httpMethod:@"POST"];
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
//找回密码获取验证码
-(void)testGetPassWordRequest:(NSString *)name retrive:(int)type  completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock{
    NSString *url=[NSString stringWithFormat:test_get_password_url];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:name,@"loginName",type,@"retriveType", nil];
    MKNetworkOperation *op=[self operationWithPath:url params:params httpMethod:@"POST"];
    
    op.shouldNotCacheResponse=YES;
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
        
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject){
            handleDataBlock(jsonObject);
        }];
        
    }errorHandler:^(MKNetworkOperation *errorOp,NSError *error){
        errorBlock(error);
    }];
    [self enqueueOperation:op];
    
}
//找回密码，设置新密码
-(void)testGetPassWordAndSetNewPassWordUser:(NSString *)name newPassWord:(NSString *)passWord retriveType:(int)type completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock{
    NSString *url=[NSString stringWithFormat:test_set_newPassWord_url];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:name,@"loginName",passWord,@"new_password",type,@"retriveType",nil];
    MKNetworkOperation *op=[self operationWithPath:url params:params httpMethod:@"POST"];
    op.shouldNotCacheResponse=YES;
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
        
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject){
            handleDataBlock(jsonObject);
        }];
        
    }errorHandler:^(MKNetworkOperation *errorOp,NSError *error){
        errorBlock(error);
    }];
    [self enqueueOperation:op];
    
    
}
//获取用户的杂志
-(void)testSendGetUserMagazineUrl:(NSString *) url UserId:(NSString *)userId start:(int) start size:(int)size completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock{
    
    
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userid",start,@"start",size,@"size", nil];
    
    MKNetworkOperation *op = [self operationWithPath:url params:params httpMethod:@"GET"];
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
//获取用户个人资料
-(void)testGetPersonnalDataUrl:(NSString *)url UserId:(NSString *)userId completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userid", nil];
    
    MKNetworkOperation *op = [self operationWithPath:url params:params httpMethod:@"POST"];
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

// yhx add
//add special params for refanqie api calls
- (NSMutableDictionary *) getMMiaApiCommonReqParam
{
    static NSMutableDictionary *param = nil;
    @try {
        if( !param )
        {
            param = [ [NSMutableDictionary  alloc] init];
            NSString* guid = [MMiaDeviceUtil getUUID];
            if( !guid )
            {
                guid = @"create_guid_failed";
            }
            NSString* model = [MMiaDeviceUtil getDeviceModel];
            if( !model )
            {
                model = @"unknown";
            }
            NSString* sysVer = [MMiaDeviceUtil getDeviceSysVer];
            if( !sysVer )
            {
                sysVer = @"unknown";
            }
            NSString* sysName = [MMiaDeviceUtil getDeviceSysName];
            if( !sysName )
            {
                sysName = @"unknown";
            }
            // APP当前版本号
            NSString* versionStr = [MMiaDeviceUtil getCurVersionStr];
            
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

- (void)startAsyncRequestWithUrl:(NSString*)url param:(id)param requestMethod:(NSString*)method completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(MKNKErrorBlock) errorBlock
{
    NSMutableDictionary *_param = [self getMMiaApiCommonReqParam];

    if( param )
    {
        if( [param isKindOfClass:[NSDictionary class]] )
        {
            [_param addEntriesFromDictionary:param];
        }
        else
        {
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

// super cancelAllOperations
- (void)cancelAllOperations
{
    [super cancelAllOperations];
    
}

@end
