//
//  MMIASetNewPassWordViewController.h
//  MMIA
//
//  Created by Vivian's Office MAC on 14-5-30.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMiaBaseViewController.h"

typedef NS_ENUM(NSInteger, MMIUserType) {
    MMIUserTypePhoneNumber,
     MMIUserTypeEmail
};

@interface MMIASetNewPassWordViewController : MMiaBaseViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,retain)NSString *phoneOrEmailText;
@property(nonatomic,assign)MMIUserType veritifyType;


@end
