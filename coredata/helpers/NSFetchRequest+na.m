//
//  NSFetchRequest+na.m
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSFetchRequest+na.h"

#import "NAFetchHelper.h"

@implementation NSFetchRequest (na)

- (void)updateWithEqualProps:(NSDictionary *)equalProps{
    NSPredicate *pred = [NAFetchHelper predicateForEqualProps:equalProps];
    [self setPredicate:pred];
}

- (void)updateWithProps:(NSArray *)props{
    NSPredicate *pred = [NAFetchHelper predicateForProps:props];
    [self setPredicate:pred];
}

@end
