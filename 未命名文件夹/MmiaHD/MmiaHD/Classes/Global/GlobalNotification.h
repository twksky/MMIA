//
//  GlobalNotification.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Support_Notification_Key           @"ChangeSupportNumber"
#define PopoverController_Notification_Key @"DidSelectedPopoverItem"

#define PersonHomeOffset_Notification_Key  @"CollectionViewOffsetY"
#define OtherHomeOffset_Notification_Key   @"OtherCollectionViewOffsetY"
#define PersonHome_ChangeHeadImage_Notification_Key @"changeHeadImage"

//通知需要传参数的key
#define PersonHome_OffsetYInfoKey          @"homeOffetYInfoKey" //个人主页偏移

//通知
#define BackToMainView_Notification_Key    @"BackToMainView"
#define PersonalInfo_Notification_Key      @"RefreshPersonalInfo"
#define DetailGoodsLike_Notification_Name   @"likeName"


@interface GlobalNotification : NSObject

@end
