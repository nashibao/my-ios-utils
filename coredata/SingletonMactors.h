//
//  SingletonMactors.h
//  na_ios_test
//
//  Created by nashibao on 2012/11/06.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SHARED_CONTROLLER(classname) \
+ (classname *)sharedController{ \
    static classname *__instance__ = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        __instance__ = [[classname alloc] init]; \
    }); \
    return __instance__; \
} \

@interface SingletonMactors : NSObject

@end
