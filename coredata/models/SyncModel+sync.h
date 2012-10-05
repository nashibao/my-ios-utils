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

+ (NAMappingDriver *)driver;


+ (void)sync_filter:(NSDictionary *)query handler:(void(^)())handler;
+ (void)sync_get:(NSNumber *)pk handler:(void(^)())handler;
- (void)sync_get:(void(^)())handler;
+ (void)sync_create:(NSDictionary *)query handler:(void(^)())handler;
- (void)sync_create:handler:(void(^)())handler;
+ (void)sync_update:(NSNumber *)pk query:(NSDictionary *)query handler:(void(^)())handler;
- (void)sync_update:(NSDictionary *)query handler:(void(^)())handler;

@end
