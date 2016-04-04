//
//  AppDelegate.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-2.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHeader.h"
#import "MagazineItem.h"
#import "UIImageView+WebCache.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
//#import "WBEngine.h"
//#import "WBSendView.h"
//#import "WBLogInAlertView.h"
//#import "WBSDKTimelineViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (nonatomic, strong) UIWindow*          window;
@property (nonatomic, strong) MMiaNetworkEngine* mmiaNetworkEngine;
@property (nonatomic, strong) NSMutableArray*    categoryArray;
@property (nonatomic, strong) NSMutableArray*    searchHotArray;

+ (AppDelegate *)sharedAppDelegate;
- (void)getCategroyDataForRequest;
- (void)getSearchHotDataForRequest;

@end

