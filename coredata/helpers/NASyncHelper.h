//
//  NASyncModelAdopter.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NARestDriver.h"

#import "NAMappingDriver.h"

/*
 実際のsyncmodelでのrestAPIの実装はこちら
 直接使うことももちろん出来る
 */
@interface NASyncHelper : NSObject

+ (void)syncFilter:(NSDictionary *)query driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler;
+ (void)syncGet:(NSNumber *)pk driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler;
+ (void)syncCreate:(NSDictionary *)query driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler;
+ (void)syncUpdate:(NSDictionary *)query pk:(NSNumber *)pk driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler;

@end
