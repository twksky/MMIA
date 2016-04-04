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
#import "MmiaDetailsLayout.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "BrandDetailSingelPageViewController.h"
#import "BrandDetailSingelPageLayout.h"
#import "SingelDetailSingelPageViewController.h"
#import "SingelDetailSingelPageLayout.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    if (iOS7Later)
    {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
#if 1
    //整个上下左右都可以滑动的列表形式的详情页
    MmiaDetailsLayout *layout = [[MmiaDetailsLayout alloc]init];
    MmiaDetailsCollectionViewController *CVC = [[MmiaDetailsCollectionViewController alloc]initWithCollectionViewLayout:layout];
    self.window.rootViewController = CVC;
#elif 0
    //单个品牌详情页
    BrandDetailSingelPageLayout *layout = [[BrandDetailSingelPageLayout alloc]init];
    BrandDetailSingelPageViewController *CVCSingelPage = [[BrandDetailSingelPageViewController alloc]initWithCollectionViewLayout:layout];
    self.window.rootViewController = CVCSingelPage;
#elif 0
    //单个单品详情页
    SingelDetailSingelPageLayout *layout = [[SingelDetailSingelPageLayout alloc]init];
    SingelDetailSingelPageViewController *CVCSingelPage = [[SingelDetailSingelPageViewController alloc]initWithCollectionViewLayout:layout];
    self.window.rootViewController = CVCSingelPage;
#else
    
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

#endif
    
    return YES;
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
