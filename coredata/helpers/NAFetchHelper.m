//
//  NAFetchHelper.m
//  SK3
//
//  Created by nashibao on 2012/09/28.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFetchHelper.h"

@implementation NAFetchHelper

+ (NSPredicate *)predicateForProps:(NSDictionary *)props{
    return [self predicateForProps:props withCustomPredicate:nil];
}

+ (NSPredicate *)predicateForProps:(NSDictionary *)props withCustomPredicate:(NSArray *)customPredicate{
    if(!props)return nil;
    NSMutableArray *ps = [[NSMutableArray alloc] init];
    for(NSString *key in props){
        id val = props[key];
        NSPredicate *p = [NSPredicate predicateWithFormat:@"%K == %@", key, val];
        [ps addObject:p];
    }
    
    if(customPredicate){
        for(id p in customPredicate){
            [ps addObject:p];
        }
    }
    NSPredicate *pred = [NSCompoundPredicate andPredicateWithSubpredicates:ps];
    return pred;
}

@end
