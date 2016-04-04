//
//  UtilityMacro.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-2.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#ifndef MmiaHD_UtilityMacro_h
#define MmiaHD_UtilityMacro_h

// 系统
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS7Later  (iOSVersion >= 7.0)
#define iOS8Later  (iOSVersion >= 8.0)
#define iOSName    [[UIDevice currentDevice] systemName]

// app
#define appModel    [[UIDevice currentDevice] model]
#define aPPVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]
#define appBundleIdentifier [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey]
#define CHANNEL_ID   @"mmia.appstore"

// app尺寸
#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width  [[UIScreen mainScreen] bounds].size.width
#define App_Frame_Height   [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width    [[UIScreen mainScreen] applicationFrame].size.width
#define VIEW_OFFSET             ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0f?20.0f:0.0f)

// 系统控件
#define kStatusBarHeight        (20.f)
#define kNavigationBarHeight    (44.f)

// 颜色
#define ColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ColorWithRGB(r,g,b) ColorWithRGBA(r,g,b,1)
#define ColorWithHexRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#define ColorWithHexRGB(rgbValue) ColorWithHexRGBA(rgbValue,1.0)
#define UIColorWhite [UIColor whiteColor]
#define UIColorClear [UIColor clearColor]

// 字体
#define UIFontSystem(x)     [UIFont systemFontOfSize:x]
#define UIFontBoldSystem(x) [UIFont boldSystemFontOfSize:x]

// 图片
#define UIImageNamed(x)     [UIImage imageNamed:x]
#define UIImageViewNamed(x) [[UIImageView alloc] initWithImage:UIImageNamed(x)]
#define UIImageViewImage(x) [[UIImageView alloc] initWithImage:x]

// 字符串
#define NSStringInt(x)   [NSString stringWithFormat:@"%ld", x]
#define NSStringFloat(x) [NSString stringWithFormat:@"%f", x]

// url
#define NSURLWithString(x) [NSURL URLWithString:x]

// nib
#define UINibWithName(x) [UINib nibWithNibName:x bundle:[NSBundle mainBundle]]

// 其他
#define BlockSelf(x) __block typeof(self) x = self
#define WeakSelf(x) __weak typeof(self) x = self
#define StandardUserDefaults [NSUserDefaults standardUserDefaults]
#define DefaultNotificationCenter [NSNotificationCenter defaultCenter]
#define DefaultFileManager [NSFileManager defaultManager]

//lx add
//textAlignment
#ifdef __IPHONE_6_0
# define MMIALineBreakModeWordWrap  NSLineBreakByWordWrapping
# define MMIATextAlignment          NSTextAlignment

# define MMIATextAlignmentCenter    NSTextAlignmentCenter
# define MMIATextAlignmentLeft      NSTextAlignmentLeft
# define MMIATextAlignmentRight     NSTextAlignmentRight

#else
# define MMIALineBreakModeWordWrap   UILineBreakModeWordWrap
# define MMIATextAlignment           UITextAlignment


# define MMIATextAlignmentCenter    UITextAlignmentCenter
# define MMIATextAlignmentLeft      UITextAlignmentLeft
# define MMIATextAlignmentRight     UITextAlignmentRight
#endif


#endif
