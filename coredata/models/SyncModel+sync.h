//
//  SyncModel+sync.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "SyncModel.h"

#import "SyncModelProtocol.h"

@interface SyncModel (sync) <SyncModelProtocol>

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

/*
 エンドポイント
 ex: /api/event/
 */
+ (NSString *)endpoint;

+ (void)as_filter:(NSDictionary *)query handler:(void(^)(NSArray *mos, NSError *err))handler;
+ (void)as_get:(NSDictionary *)query handler:(void(^)(NSManagedObject *mo, NSError *err))handler;
+ (void)as_create:(NSDictionary *)query handler:(void(^)(NSManagedObject *mo, NSError *err))handler;
- (void)as_upload:(void(^)(NSManagedObject *mo, NSError *err))handler;
- (void)as_download:(void(^)(NSManagedObject *mo, NSError *err))handler;

@end
