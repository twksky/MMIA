//
//  AppDelegate.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-2.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "AppDelegate.h"
#import "MmiaMainViewController.h"
#import "UtilityFunction.h"
#import "MmiaLoginMacro.h"
#import "MobClick.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self initEngine];
    
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    
    MmiaMainViewController* mainViewController = [[MmiaMainViewController alloc] init];
    self.window.rootViewController = [GlobalConfig createNavWithRootVC:mainViewController];
    
    _categoryArray = [NSMutableArray array];
    _searchHotArray = [NSMutableArray array];
    
    [self getCategroyDataForRequest];
    [self getSearchHotDataForRequest];
    
    //新浪微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:Mmia_SINALogin_APPKEY];
    
    return YES;
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)initEngine
{
   #ifdef DEBUG

   // self.mmiaNetworkEngine = [[MMiaNetworkEngine alloc]initWithHostName:@"192.0.0.250"];
    self.mmiaNetworkEngine = [[MMiaNetworkEngine alloc]initWithHostName:@"api.mmia.com"];
  #else
    
     self.mmiaNetworkEngine = [[MMiaNetworkEngine alloc]initWithHostName:@"api.mmia.com"];
    
   #endif
}

#pragma mark *分类接口

- (void)getCategroyDataForRequest
{
    [self.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_CATEGROY_URL param:nil requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *dataDict)
     {
         if( [dataDict[@"result"] intValue] == 0 )
         {
             for( NSDictionary* dict in dataDict[@"data"] )
             {
                 MagazineItem* categroyItem = [[MagazineItem alloc] init];
                 categroyItem.titleText = dict[@"name"];

                 NSMutableArray* subCategoryArr = [[NSMutableArray alloc] initWithCapacity:[dict[@"subCategroy"] count]];
                 for( NSDictionary* subDict in dict[@"subCategroy"] )
                 {
                     MagazineItem* subCategroyItem = [[MagazineItem alloc] init];
                     subCategroyItem.titleText = subDict[@"name"];
                     
                     NSMutableArray* magazineArray = [[NSMutableArray alloc] initWithCapacity:[subDict[@"subCategroy"] count]];
                     for( NSDictionary* magazineDict in subDict[@"subCategroy"] )
                     {
                         MagazineItem* magazineItem = [[MagazineItem alloc] init];
                         magazineItem.aId = [magazineDict[@"id"] integerValue];
                         magazineItem.titleText = magazineDict[@"name"];
                         magazineItem.pictureImageUrl = magazineDict[@"imgUrl"];
                         
                         [magazineArray addObject:magazineItem];
                     }
                     subCategroyItem.subMagezineArray = magazineArray;
                     [subCategoryArr addObject:subCategroyItem];
                 }
                 categroyItem.subMagezineArray = subCategoryArr;
                 [self.categoryArray addObject:categroyItem];
             }
             // 写文件
             NSString* categoryPath = [GlobalFunction directoryPathWithFileName:CATEGROY_KEY];
             NSArray* categoryArr = [NSKeyedUnarchiver unarchiveObjectWithFile:categoryPath];
             
             if( ![categoryArr isEqualToArray:self.categoryArray] )
             {
                 [NSKeyedArchiver archiveRootObject:self.categoryArray toFile:categoryPath];
             }
         }
         else
         {
         }
         
     }errorHandler:^(NSError *error){
     }];
}

#pragma mark *搜索热门推荐接口

- (void)getSearchHotDataForRequest
{
    [self.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_SEARCHHOT_URL param:nil requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *dataDict)
     {
         if( [dataDict[@"result"] intValue] == 0 )
         {
             for( NSDictionary* dict in dataDict[@"data"] )
             {
                 MagazineItem* hotItem = [[MagazineItem alloc] init];
                 hotItem.aId = [dict[@"id"] integerValue];
                 hotItem.titleText = dict[@"name"];
                 hotItem.pictureImageUrl = dict[@"imgUrl"];
                 [self.searchHotArray addObject:hotItem];
             }
             // 写文件
             NSString* hotPath = [GlobalFunction directoryPathWithFileName:SEARCH_HOT_KEY];
             NSArray* hotArr = [NSKeyedUnarchiver unarchiveObjectWithFile:hotPath];
             
             if( ![hotArr isEqualToArray:self.searchHotArray] )
             {
                 [NSKeyedArchiver archiveRootObject:self.searchHotArray toFile:hotPath];
             }
         }
         else
         {
         }
         
     }errorHandler:^(NSError *error){
     }];
}

//QQ互联三方登录重写
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"%@",url);
    return [TencentOAuth HandleOpenURL:url]||[WeiboSDK handleOpenURL:url delegate:self];
//    return [WeiboSDK handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url]||[WeiboSDK handleOpenURL:url delegate:self];
//    return [WeiboSDK handleOpenURL:url delegate:self];
}


#pragma mark -sina登录

//sina登录回调函数，登录成功实现的方法

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    NSLog(@"%@",response.userInfo);
    NSString *sinaAccessToken = [NSString stringWithFormat:@"%@",[response.userInfo objectForKey:@"access_token"]];
//    NSDate *qqExpireinDate = _tencentOAuth.expirationDate;
//    NSTimeInterval qqExpirein = [qqExpireinDate timeIntervalSinceNow];
    NSString *sinaExpireinStr = [NSString stringWithFormat:@"%@",[response.userInfo objectForKey:@"expires_in"]];
    NSDictionary *infoDict=[[NSDictionary alloc]initWithObjectsAndKeys:sinaAccessToken,@"accessToken",sinaExpireinStr,@"expirein", nil];
    
    [_mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_SINALogin_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
//        [processView dismiss];
//         登录成功
        if ([jsonObject[@"result"]intValue]==0)
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:jsonObject[@"id"] forKey:USER_ID];
            [defaults setObject:jsonObject[@"ticket"] forKey:USER_TICKET];
            [defaults setBool:YES forKey:USER_IS_LOGIN];
            [defaults setObject:jsonObject[@"userType"] forKey:@"userType"];
            
            [defaults synchronize];
////            if( [_target respondsToSelector:logonSuccessAction] )
////            {
////                [_target performSelector:logonSuccessAction];
////            }
           [DefaultNotificationCenter postNotificationName:@"logonSuccessAction" object:self];
        }
    }errorHandler:^(NSError *error) {
    }];

}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
