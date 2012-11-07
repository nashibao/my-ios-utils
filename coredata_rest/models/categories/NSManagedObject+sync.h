//
//  SyncBaseModel+sync.h
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSManagedObject+na.h"

#import "NASyncModelProtocol.h"

#import "NARestDriverProtocol.h"

@interface NSManagedObject (sync)


#pragma mark ベースモデルの説明

#pragma mark REST/Mappingの設定

#pragma mark 同期用のショートカット


/*
 completeはmainthreadでsave後にmainthreadで帰ってくる
 
 options:
  identifier(on memory in an operation.): キャンセル用途
  network_identifier(mo): frcの名前などを入れておく
  network_cache_identifier(mo): 検索語などを入れておく
 */

/*
 class methods
 */
+ (void)sync_filter:(NSDictionary *)query
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
+ (void)sync_get:(NSInteger)pk
         options:(NSDictionary *)options
        complete:(void(^)(NSError *err))complete;
+ (void)sync_create:(NSDictionary *)query
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
+ (void)sync_update:(NSInteger)pk
              query:(NSDictionary *)query
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
+ (void)sync_delete:(NSInteger)pk
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
+ (void)sync_rpc:(NSDictionary *)query
         rpcname:(NSString *)rpcname
         options:(NSDictionary *)options
        complete:(void(^)(NSError *err))complete;

/*
 bulk commands
 単純だが、callbackが扱えない
 */
+ (void)sync_bulk_update_or_create:(NSDictionary *)query
                           options:(NSDictionary *)options;
+ (void)sync_bulk_delete:(NSDictionary *)query
                 options:(NSDictionary *)options;
+ (void)sync:(NSDictionary *)query
     options:(NSDictionary *)options;

/*
 instance methods
 */
- (void)sync_get:(NSDictionary *)options
        complete:(void(^)(NSError *err))complete;
- (void)sync_create:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
- (void)sync_update:(NSDictionary *)query
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
- (void)sync_update:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;
- (void)sync_delete:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete;

/*
 instance methods without sync
 */
- (void)local_update:(NSDictionary *)query options:(NSDictionary *)options;
- (void)local_delete:(NSDictionary *)options;

/*
 is_syncing_のtoggle
 threadが気になるので外だしする
 */
+ (void)syncing_on:(NSManagedObjectID *)objectID;
+ (void)syncing_off:(NSManagedObjectID *)objectID;


/*
 canceling
 */
+ (void)sync_cancel;
+ (void)sync_cancel:(NARestType)restType rpcname:(NSString *)rpcname options:(NSDictionary *)options handler:(void(^)())handler;



//自動でsync_stateを変更するかどうか
+ (BOOL)is_auto_change_sync_state_management;
//変更検知に含めるkey
+ (NSArray *)is_auto_change_sync_state_management_keys;

@end
