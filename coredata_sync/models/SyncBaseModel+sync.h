//
//  SyncBaseModel+sync.h
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "SyncBaseModel.h"

#import "NAMappingDriver.h"

@interface SyncBaseModel (sync)

/*
 additional schemes
 */
+ (NAMappingDriver *)driver;
+ (NSString *)primaryKeyField;
- (NSNumber *)primaryKey;

/*
 mapping
 */
+ (NSDictionary *)mo2query:(NSManagedObject *)mo;
+ (NSDictionary *)json2dictionary:(NSDictionary *)json;
+ (NSDictionary *)json2uniqueDictionary:(NSDictionary *)json;

/*
 completeはmainthreadでsave後にmainthreadで帰ってくる
 */
+ (void)sync_filter:(NSDictionary *)query complete:(void(^)())complete;
+ (void)sync_get:(NSNumber *)pk complete:(void(^)())complete;
- (void)sync_get:(void(^)())complete;
+ (void)sync_create:(NSDictionary *)query complete:(void(^)())complete;
- (void)sync_create:(void(^)())complete;
+ (void)sync_update:(NSNumber *)pk query:(NSDictionary *)query complete:(void(^)())complete;
- (void)sync_update:(NSDictionary *)query complete:(void(^)())complete;

@end
