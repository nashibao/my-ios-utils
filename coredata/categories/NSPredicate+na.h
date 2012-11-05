//
//  NSPredicate+na.h
//  na_ios_test
//
//  Created by nashibao on 2012/11/05.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (na)

+ (NSPredicate *)predicateForEqualProps:(NSDictionary *)equalProps;
+ (NSPredicate *)predicateForProps:(NSArray *)props;

@end
