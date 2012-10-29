//
//  NAAsyncOCUnit.h
//  na_ios_test
//
//  Created by nashibao on 2012/10/29.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#define STAsynchronousTestStart(identifier) __block NSUInteger STAsynchronousTest_ ## identifier = 1
#define STAsynchronousTestDone(identifier) STAsynchronousTest_ ## identifier -= 1
#define STAsynchronousTestWait(identifier, interval) while (STAsynchronousTest_ ## identifier > 0)\
[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:(interval)]]
#define STAsynchronousTestSetCount(identifier, count) STAsynchronousTest_ ## identifier = count

#import <Foundation/Foundation.h>

@interface NAAsyncOCUnit : NSObject

@end
