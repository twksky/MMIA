//
//  UtilityAdditions.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YHX)

- (BOOL)isDictionary;
- (BOOL)isMutableDictionary;
- (BOOL)isArray;
- (BOOL)isMutableArray;
- (BOOL)isString;
- (BOOL)isMutableString;
- (BOOL)isNumber;
- (BOOL)isNull;
- (NSInteger)myIntValue;

@end
