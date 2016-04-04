//
//  MMIALoginViewController.h
//  MMIAAdIphone
//
//  Created by Vivian's Office MAC on 14-2-12.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

//#import "MMIARootViewController.h"
//#import "UMSocial.h"
#import "MMiaBaseViewController.h"
#import "MMIEmailPrompt.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/sdkdef.h>

#import "WeiboApi.h"



typedef enum{
    ThirdLoginTypeQQ,
    ThirdLoginTypeSinaWeiBo,
    ThirdLoginTypeTecentWeiBo,
    
}ThirdLoginType;



//@interface MMIALoginViewController : MMIARootViewController<UITextFieldDelegate,UMSocialUIDelegate>
@interface MMIALoginViewController : MMiaBaseViewController<UITextFieldDelegate,MMIEmailPromptDelegate,TencentSessionDelegate,WBHttpRequestDelegate,WeiboAuthDelegate,WeiboRequestDelegate>


{
    UIView *_bgView;
    UITextField *_userNameTextField;
    UITextField *_passWordTextField;
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_permissions;
    WeiboApi                    *wbapi;
    NSTimer *_timer;

    
}
@property (nonatomic,copy) NSString *loginUrl;
@property (nonatomic, assign) BOOL backToRootViewController;
@property(nonatomic,assign)ThirdLoginType type;
@property(nonatomic,retain)NSString *access_token;
@property(nonatomic,retain)NSString *expirein;
//腾讯微博
@property(nonatomic,retain)WeiboApi *wbapi;

- (void)addLoadingView;

@end
