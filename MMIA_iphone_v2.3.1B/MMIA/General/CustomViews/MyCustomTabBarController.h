//
//  MyCustomTabBarController.h
//  MMIA
//
//  Created by yhx on 14-7-2.
//
//

#import <UIKit/UIKit.h>
#import "MyCustomTabBarMainVIew.h"

@interface MyCustomTabBarController : UITabBarController <UINavigationControllerDelegate,MyCustomTabBarMainVIewDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    UIImageView* _tabBarBg;
    NSMutableArray* _btnArr;
}

- (void)hideOrNotCustomTabBar:(BOOL)hidden;
- (void)switchToFirst;
- (void)switchToLast;
- (void)logonSuccess;
- (void)registerSuccess;
- (void)closWindow;
  
@end
