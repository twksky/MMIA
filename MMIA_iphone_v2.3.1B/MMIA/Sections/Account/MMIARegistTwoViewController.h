//
//  MMIARegistTwoViewController.h
//  MMIAAdIphone
//
//  Created by Vivian's Office MAC on 14-2-12.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMiaBaseViewController.h"
#import "MMIEmailPrompt.h"
#import "MMiaNetworkManager.h"

typedef enum{
    UserTypePhone,
    UserTypeMail,
    
}UserType;



@interface MMIARegistTwoViewController : MMiaBaseViewController<UITextFieldDelegate,UIAlertViewDelegate,MMIEmailPromptDelegate>{
    int timeCount;
    NSTimer *_timer;
    UIButton *messageBtn;
    NSTimer *_webTimer;
   
}

@property (nonatomic,copy) NSString *navTitle;
@property(nonatomic,assign)UserType type;


@end
