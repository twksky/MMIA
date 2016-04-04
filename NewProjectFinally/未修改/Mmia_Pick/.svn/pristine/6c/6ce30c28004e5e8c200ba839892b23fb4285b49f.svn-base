//
//  UtilityAdditions.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "UtilityAdditions.h"

#pragma mark NSObject

@implementation NSObject (YHX)

- (BOOL)isDictionary
{
    return [self isKindOfClass:[NSDictionary class]];
}

- (BOOL)isMutableDictionary
{
    return [self isKindOfClass:[NSMutableDictionary class]];
}

- (BOOL)isArray
{
    return [self isKindOfClass:[NSArray class]];
}

- (BOOL)isMutableArray
{
    return [self isKindOfClass:[NSMutableArray class]];
}

- (BOOL)isString
{
    return [self isKindOfClass:[NSString class]];
}

- (BOOL)isMutableString
{
    return [self isKindOfClass:[NSMutableString class]];
}

- (BOOL)isNumber
{
    return [self isKindOfClass:[NSNumber class]];
}

- (BOOL)isNull
{
    return [self isKindOfClass:[NSNull class]];
}

- (NSInteger)myIntValue
{
    if ([self isString])
    {
        return [(NSString*)self intValue];
    }
    else if ([self isNumber])
    {
        return [(NSNumber*)self intValue];
    }
    return 0;
}

@end
