//
//  NSNotificationCenter+na.m
//  SK3
//
//  Created by nashibao on 2012/12/24.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSNotificationCenter+na.h"

@implementation NSNotificationCenter (na)

+ (void)postNotificationByName:(NSString *)name{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

@end
