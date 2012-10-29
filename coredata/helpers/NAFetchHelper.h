//
//  NAFetchHelper.h
//  SK3
//
//  Created by nashibao on 2012/09/28.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 helper class to fetch or create predicates.
 */
@interface NAFetchHelper : NSObject

/*
 equalProps: dic
  @{key : val} -> key == val
 
 props: array
 
 */

+ (NSPredicate *)predicateForEqualProps:(NSDictionary *)equalProps;
+ (NSPredicate *)predicateForProps:(NSArray *)props;

@end
