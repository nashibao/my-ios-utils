//
//  NSOperationQueue+nashibao.m
//  SK3
//
//  Created by nashibao on 2012/09/24.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSOperationQueue+nashibao.h"

@implementation NSOperationQueue (nashibao)

+ (id)globalBackgroundQueue{
    static NSOperationQueue *__background__queue__nashibao__ = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        __background__queue__nashibao__ = [[NSOperationQueue alloc] init];
    });
    return __background__queue__nashibao__;
}

@end
