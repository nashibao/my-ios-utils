//
//  NSNull+na.m
//  SK3
//
//  Created by nashibao on 2012/12/07.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSNull+na.h"

@implementation NSNull (na)
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig=[[NSNull class] instanceMethodSignatureForSelector:aSelector];
    // Just return some meaningless signature
    if (sig == nil) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    
    return sig;
}

@end
