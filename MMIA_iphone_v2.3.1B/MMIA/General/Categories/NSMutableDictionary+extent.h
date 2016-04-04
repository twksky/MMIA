//
//  NSMutableDictionary+extent.h
//  USchoolCircle
//
//  Created by sunbingtuan on 14-2-28.
//  Copyright (c) 2014年 uskytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSMutableDictionary (extent)
+ (void)extent; 
- (void)setDictionaryObject:(id)anObject forKey:(id)key;
- (id)objectNotNULLForKey:(id)key;
//void setDictionaryObject(id self,IMP cmd,id object, id key);
@end

@interface NSUserDefaults (extent)
- (void)setUserDefaultObject:(id)anObject forKey:(id)key;
- (id)objectNotNULLForKey:(id)key;
@end

@interface NSDictionary (extent)
- (id)objectNotNULLForKey:(id)key;
@end
