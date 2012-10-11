//
//  SyncBaseModel+sync.h
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "SyncBaseModel.h"

#import "NAMappingDriver.h"

#import "NSManagedObject+na.h"

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
 
 options:
  identifier(on memory in an operation.): キャンセル用途
  network_identifier(mo): frcの名前などを入れておく
  network_cache_identifier(mo): 検索語などを入れておく
 */
+ (void)sync_filter:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete;
+ (void)sync_get:(NSNumber *)pk options:(NSDictionary *)options complete:(void(^)())complete;
- (void)sync_get:(NSDictionary *)options complete:(void(^)())complete;
+ (void)sync_create:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete;
- (void)sync_create:(NSDictionary *)options complete:(void(^)())complete;
+ (void)sync_update:(NSNumber *)pk query:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete;
- (void)sync_update:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete;

@end
