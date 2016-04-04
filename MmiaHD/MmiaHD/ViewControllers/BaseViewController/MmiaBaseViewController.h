//
//  MmiaBaseViewController.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-3-27.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdditionHeader.h"
#import "AppDelegate.h"

@interface MmiaBaseViewController : UIViewController

@property (nonatomic, getter=isPortrait) BOOL portrait;

- (void)addSearchButtonWithTarget:(id)target;
- (void)addLeftButtonItemsWithTarget:(id)target
                           selector1:(SEL)selector1
                           selector2:(SEL)selector2
                           selector3:(SEL)selector3;
- (NSString *)didSeletedPopoverItem:(NSNotification *)notification;
- (void)createNotifications;
- (void)destroyNotifications;
- (void)layoutSubviews;

@end
