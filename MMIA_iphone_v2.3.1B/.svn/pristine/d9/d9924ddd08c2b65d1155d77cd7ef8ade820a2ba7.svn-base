//
//  FuncMacro.h
//  MMia
//

//  Copyright (c) 2014年 Wuzixun. All rights reserved.
//

#ifndef MMia_FuncMacro_h
#define MMia_FuncMacro_h

#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPAD ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPad" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

// RGB颜色转换（16进制->10进制）
//#define ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
//green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 \
//alpha:1.0]


#define  INFOR_DICTIONARY               [[NSUserDefaults standardUserDefaults] objectForKey:@"privateInfor"]

#define LOGIN_STATUS                    INFOR_DICTIONARY==nil?LOGIN_OUT:LOGIN_IN

//判断用户登陆的宏
#define LOGIN_IN                        @"Login in"
#define LOGIN_OUT                       @"Login out"
#define LOGIN_STATUS                    INFOR_DICTIONARY==nil?LOGIN_OUT:LOGIN_IN


#define  LOGIN_TYPE 100
#define  LOGIN_OUT_TYPE 101


#pragma  mark - regist
#define  ENTERPRISE_REGIST_TYPE 200
#define  USER_REGIST_TYPE 300
#define  REGIST_CHECK_TYPE 400


#define  DOWNLOAD_IMAGES_LIST_TYPE 600

#define  IMAGE_COMMENT_TYPE  601
#define  SEND_IMAGE_COMMENT_TYPE  602


#define  PRIVATE_INFOR_TYPE  700

#define PRESON_USER   @"PersonUser"
#define ENTERPRISE_USER  @"EnterPriseUser"



#define UIColorFromRGB(rgb)  [UIColor colorWithRed:(CGFloat)((rgb>>16)/255.0f) \
green:(CGFloat)(((rgb&0x00FF00)>>8)/255.0f)\
blue:(CGFloat)((rgb&0xFF)/255.0f) \
alpha:1.0]

#endif
