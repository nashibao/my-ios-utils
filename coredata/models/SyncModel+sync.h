//
//  SyncModel+sync.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "SyncModel.h"

#import "NAMappingDriver.h"

@interface SyncModel (sync)

/*
 upload中かどうか
 */
@property(nonatomic)BOOL is_uploading;

/*
 変更検知から外すkey
 */
+ (NSArray *)exclude_edit_management_keys;

/*
 変更検知のマニュアル化
 default: YES
 */
+ (BOOL)is_manual_edit_management;

#pragma mark TODO: 実際のcoredataのプロパティから切り離すために、こいつはカテゴリじゃなくてSyncModelの基底モデルにすべき． 
+ (NAMappingDriver *)driver;
- (NSString *)primaryKeyField;
- (NSNumber *)primaryKey;

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
