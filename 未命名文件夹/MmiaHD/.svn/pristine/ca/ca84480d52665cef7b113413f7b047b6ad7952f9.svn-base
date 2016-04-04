//
//  MmiaLoginViewController.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-11.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackBaseViewController.h"
#import "MmiaEmailPrompt.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
//#import "WBEngine.h"
//#import "WBSendView.h"
//#import "WBLogInAlertView.h"
//#import "WeiboViewController.h"


@interface MmiaLoginViewController : UIViewController<UITextFieldDelegate,MmiaEmailPromptDelegate,TencentSessionDelegate,TencentWebViewDelegate, UIAlertViewDelegate,WeiboSDKDelegate>
{
    NSMutableArray* _permissions;
    //新浪微博
//    WBEngine *weiBoEngine;
    
//    WBSDKTimelineViewController *timeLineViewController;
//    UIActivityIndicatorView *indicatorView;
    
    UIButton *logInBtnOAuth;
    UIButton *logInBtnXAuth;
}
@property (nonatomic, copy  ) NSString *loginUrl;
@property (nonatomic, assign) BOOL backToRootViewController;
@property (nonatomic, strong) NSString *access_token;
@property (strong, nonatomic)TencentOAuth *tencentOAuth;
@property (strong , nonatomic) UIView * loginView;

//sina微博
//@property (nonatomic, strong) WBEngine *weiBoEngine;
//@property (nonatomic, strong) WBSDKTimelineViewController *timeLineViewController;



- (void)addLoadingView;
- (void)setTarget:(id)tar withSuccessAction:(SEL)action withRegisterAction:(SEL)action1;

@end
