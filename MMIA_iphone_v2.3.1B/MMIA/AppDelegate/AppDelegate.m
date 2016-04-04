//
//  AppDelegate.m
//  MMIA
//
//  Created by zixun on 5/29/14.
//  Copyright (c) 2014 com.zixun. All rights reserved.
//

#import "AppDelegate.h"
#import <libNBSAppAgent/NBSAppAgent.h>
#import "MMiaDataEngine.h"
#import "MMIALoginViewController.h"
#import "FrameMacro.h"
#import "APService.h"
#import "MobClick.h"
#import "GuideView.h"
#import "MMiaDataSetViewController.h"
#import "MMiaCompanyDataSetViewController.h"
#import "MMIAPersonalHomePageViewController.h"
#import "MMiaCreateMagazineViewController.h"
#import "MMiaQueryViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (iOS7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    //听云
  [NBSAppAgent startWithAppID:@"a387974621024cbdb87925181d8d8a85"];
  [NBSAppAgent setCrashCollectFlg:NO];
    
    //友盟版本更新
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //[MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:version];
    
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
      [self.window makeKeyAndVisible];
    
    [self initEngine];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:USER_FIRST_TIME_LOGIN]==NO) {
        _tabController = [[MyCustomTabBarController alloc] init];
        self.window.rootViewController=_tabController;
        GuideView *view=[[GuideView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, Main_Screen_Height)];
        [_tabController.view addSubview:view];
    }else{
        // test TabBar
        _tabController = [[MyCustomTabBarController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:_tabController];
    }
    
    [APService
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert) categories:nil];
    
    
    [APService setupWithOption:launchOptions];
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    application.applicationIconBadgeNumber = 0;
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    [APService handleRemoteNotification:userInfo];
    //    NSDictionary *apsDict=[userInfo objectForKey:@"aps"];
    //    NSString *alert=[apsDict objectForKey:@"alert"];
    //
    //    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"新消息" message:alert delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    //    [self.window addSubview:alertview];
    //    [alertview show];
    
    // NSLog(@"userInfo=%@",userInfo);
    
}

//#ifdef __IPHONE_7_0
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    [APService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNoData);
//    
//    NSDictionary *apsDict=[userInfo objectForKey:@"aps"];
//    NSString *alert=[apsDict objectForKey:@"alert"];
//    // NSLog(@"alert=%@",alert);
//    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"新消息" message:alert delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//    [self.window addSubview:alertview];
//    [alertview show];
//}
//#endif
//



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) initEngine
{
#ifdef TEST
 // self.mmiaDataEngine = [[MMiaDataEngine alloc] initWithHostName:@"192.0.0.250"];
    
  self.mmiaDataEngine=[[MMiaDataEngine alloc]initWithHostName:@"api.mmia.com"];
#else
    self.mmiaDataEngine = [[MMiaDataEngine alloc] initWithHostName:@"api.mmia.com"];
#endif
    [self.mmiaDataEngine useCache];
    
    [UIImageView setDefaultEngine:self.mmiaDataEngine];
    
    
}

@end
