//
//  MMiaDataSetViewController.h
//  MMIA
//
//  Created by lixiao on 14-6-19.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//个人资料设置


#import "MMiaBaseViewController.h"
#import "LoginInfoItem.h"

@interface MMiaDataSetViewController : MMiaBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
   
}
-(id)initWithLoginItem:(LoginInfoItem *)item;
@end
