//
//  AccessorMacros.h
//  na_ios_unit_test
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INTEGER_ACCESSOR(accessorName, bigAccessorName, keyName, typeName) \
- (void)bigAccessorName:(typeName)b { \
    [self willChangeValueForKey:keyName]; \
    [self setPrimitiveValue:[NSNumber numberWithInt:b] forKey:keyName]; \
    [self didChangeValueForKey:keyName]; \
} \
- (typeName)accessorName{ \
    [self willAccessValueForKey:keyName]; \
    NSInteger b = [[self primitiveValueForKey:keyName] intValue]; \
    [self didAccessValueForKey:keyName]; \
    return b; \
} \

#define SHARED_CONTROLLER(classname) \
+ (classname *)sharedController{ \
    static classname *__instance__ = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        __instance__ = [[classname alloc] init]; \
    }); \
    return __instance__; \
} \

