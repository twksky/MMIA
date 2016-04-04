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
#import "MmiaCategoryViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaSearchViewController.h"
#import "MmiaDetailsCollectionViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "BrandEntrancePageViewController.h"
#import "MmiaProductDetailViewController.h"
#import "WeiboSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    if (iOS7Later)
    {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaMainViewController* mainViewController = [[MmiaMainViewController alloc] initWithCollectionViewLayout:smallLayout];
    self.window.rootViewController = [GlobalConfig createNavWithRootVC:mainViewController];
   
    // add another UIWindow
    self.backWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CHTCollectionViewWaterfallLayout* categoryLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    MmiaCategoryViewController* categoryViewController = [[MmiaCategoryViewController alloc] initWithCollectionViewLayout:categoryLayout];
     self.backWindow.windowLevel = UIWindowLevelNormal - 1;
    self.backWindow.rootViewController = [GlobalConfig createNavWithRootVC:categoryViewController];
    [self.backWindow makeKeyAndVisible];
    
    return YES;
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:nil];
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
