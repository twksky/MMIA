//
//  MmiJudgeTypeUtil.h
//  MmiaHD
//
//  Created by twksky on 15/3/24.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MmiJudgeTypeUtil : NSObject
+(BOOL)isEmailNumber:(NSString *)str;
+(BOOL)isPhoneNumber:(NSString *)str;
@end
