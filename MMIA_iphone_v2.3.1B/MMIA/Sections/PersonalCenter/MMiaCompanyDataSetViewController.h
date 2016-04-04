//
//  MMiaCompanyDataSetViewController.h
//  MMIA
//
//  Created by lixiao on 14-9-9.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaBaseViewController.h"
#import "MMiaCompanyTypeView.h"
#import "LoginInfoItem.h"

@interface MMiaCompanyDataSetViewController : MMiaBaseViewController<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, MMiaCompanyTypeViewDelegate,UIAlertViewDelegate>

-(id)initWithLoginItem:(LoginInfoItem *)item;
@property(nonatomic,assign)BOOL isOthers;
@end
