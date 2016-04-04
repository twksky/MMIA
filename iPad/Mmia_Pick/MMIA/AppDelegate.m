//
//  AppDelegate.m
//  MMIA
//
//  Created by lixiao on 15/5/13.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalConfig.h"
#import "MmiaMainViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaSearchViewController.h"
#import "MmiaDetailsCollectionViewController.h"
#import "MmiaDetailsLayout.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
   // [WXApi registerApp:@"wx5a053bb69b4cfe38" withDescription:@"Mmia"];

    if (iOS7Later)
    {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    //MmiaMainViewController* mainViewController = [[MmiaMainViewController alloc]initWithNibName:@"MmiaMainViewController" bundle:nil];
#if 1
    
//*******************测试详情界面
//    MmiaDetailsViewController *VC = [[MmiaDetailsViewController alloc]init];
//    self.window.rootViewController = VC;
//********************
    MmiaDetailsLayout *layout = [[MmiaDetailsLayout alloc]init];
    MmiaDetailsCollectionViewController *CVC = [[MmiaDetailsCollectionViewController alloc]initWithCollectionViewLayout:layout];
    self.window.rootViewController = CVC;
    
//    MmiaMainViewController *mainVC = [[MmiaMainViewController alloc]initWithNibName:@"MmiaMainViewController" bundle:nil];
//   self.window.rootViewController = [GlobalConfig createNavWithRootVC:mainVC];

#else
    
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    smallLayout.footerReferenceSize = CGSizeMake(200, 400);

    MmiaMainViewController* mainViewController = [[MmiaMainViewController alloc] initWithCollectionViewLayout:smallLayout];
//    MmiaMainViewController* mainViewController = [[MmiaMainViewController alloc] init];
    self.window.rootViewController = [GlobalConfig createNavWithRootVC:mainViewController];

#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
