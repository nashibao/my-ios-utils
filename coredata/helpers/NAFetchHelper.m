//
//  NAFetchHelper.m
//  SK3
//
//  Created by nashibao on 2012/09/28.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFetchHelper.h"

@implementation NAFetchHelper

+ (NSPredicate *)predicateForEqualProps:(NSDictionary *)equalProps{
    if(!equalProps)return nil;
    NSMutableArray *ps = [[NSMutableArray alloc] init];
    for(NSString *key in equalProps){
        id val = equalProps[key];
        NSPredicate *p = [NSPredicate predicateWithFormat:@"%K == %@", key, val];
        [ps addObject:p];
    }
    if([ps count]==0)
        return nil;
    NSPredicate *pred = [NSCompoundPredicate andPredicateWithSubpredicates:ps];
    return pred;
}

+ (NSPredicate *)predicateForProps:(NSArray *)props{
    if(!props)return nil;
    NSMutableArray *ps = [[NSMutableArray alloc] init];
    for(NSArray *prop in props){
        NSString *format = prop[0];
        NSArray *vals = [prop subarrayWithRange:NSMakeRange(1, prop.count-1)];
        NSPredicate *p = [NSPredicate predicateWithFormat:format argumentArray:vals];
        [ps addObject:p];
    }
    if([ps count]==0)
        return nil;
    NSPredicate *pred = [NSCompoundPredicate andPredicateWithSubpredicates:ps];
    return pred;
}

@end
