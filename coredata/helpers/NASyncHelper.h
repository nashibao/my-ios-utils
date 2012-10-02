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

+ (void)syncFilter:(NSDictionary *)query driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler;
//+ (void)syncGet:(NSDictionary *)query handler:(void(^)(NSManagedObject *mo, NSError *err))handler;
//+ (void)syncCreate:(NSDictionary *)query handler:(void(^)(NSManagedObject *mo, NSError *err))handler;
//
//+ (void)syncUpdate:(void(^)(NSManagedObject *mo, NSError *err))handler;
//+ (void)syncUpdate:(NSDictionary *)query handler:(void(^)(NSManagedObject *mo, NSError *err))handler;

@end
