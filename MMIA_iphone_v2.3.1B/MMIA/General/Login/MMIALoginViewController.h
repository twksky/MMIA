//
//  MMIALoginViewController.h
//  MMIAAdIphone
//
//  Created by Vivian's Office MAC on 14-2-12.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMiaBaseViewController.h"
#import "MMIEmailPrompt.h"


//@interface MMIALoginViewController : MMIARootViewController<UITextFieldDelegate,UMSocialUIDelegate>
@interface MMIALoginViewController : MMiaBaseViewController<UITextFieldDelegate,MMIEmailPromptDelegate>
{
}
@property (nonatomic, copy  ) NSString *loginUrl;
@property (nonatomic, assign) BOOL backToRootViewController;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *expirein;

- (void)addLoadingView;
- (void)setTarget:(id)tar withSuccessAction:(SEL)action withRegisterAction:(SEL)action1;

@end
