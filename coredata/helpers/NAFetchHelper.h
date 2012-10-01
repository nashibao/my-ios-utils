//
//  NAFetchHelper.h
//  SK3
//
//  Created by nashibao on 2012/09/28.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAFetchHelper : NSObject

+ (NSPredicate *)predicateForProps:(NSDictionary *)props;
+ (NSPredicate *)predicateForProps:(NSDictionary *)props withCustomPredicate:(NSArray *)customPredicate;

@end
