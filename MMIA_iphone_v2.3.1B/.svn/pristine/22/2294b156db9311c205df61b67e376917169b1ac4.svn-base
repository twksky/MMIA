//
//  MMIJudgeTypeUtil.m
//  MMIA
//
//  Created by Free on 14-6-14.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMIJudgeTypeUtil.h"

@implementation MMIJudgeTypeUtil


//判断是否为邮箱
+(BOOL)isEmailNumber:(NSString *)str{
    
   // UITextField *mail = (UITextField *)[self.view viewWithTag:REGIST_EMAIL_TAG];
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
   
    
    
}

//判断是否为手机号
+(BOOL)isPhoneNumber:(NSString *)str
{
    NSString *regex = @"^1[3458]{1}[\\d]{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}







@end
