//
//  SyncBaseModel+sync.m
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSManagedObject+restapi.h"

#import "NARestHelper.h"

#import "NSPredicate+na.h"

#import <objc/runtime.h>

#import "NSManagedObject+syncobject.h"

#import "NSManagedObject+restobject.h"

@implementation NSManagedObject (restapi)

/*
 class methods
 */
+ (void)sync_filter:(NSDictionary *)query
           maskType:(NAProgressHUDMaskType)maskType
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete{
    [NARestHelper syncFilter:[NARestQueryObject query:query model:self maskType:maskType options:options completeHandler:complete]];
}

+ (void)sync_get:(NSInteger)pk
        maskType:(NAProgressHUDMaskType)maskType
         options:(NSDictionary *)options
        complete:(void(^)(NSError *err))complete{
    [NARestHelper syncGet:[NARestQueryObject query:nil pk:pk objectID:nil model:self maskType:maskType options:options completeHandler:complete]];
}

+ (void)sync_create:(NSDictionary *)query
           maskType:(NAProgressHUDMaskType)maskType
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete{
    [NARestHelper syncCreate:[NARestQueryObject query:query model:self maskType:maskType options:options completeHandler:complete]];
}

+ (void)sync_update:(NSInteger)pk
              query:(NSDictionary *)query
           maskType:(NAProgressHUDMaskType)maskType
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete{
    [NARestHelper syncUpdate:[NARestQueryObject query:query pk:pk objectID:nil model:self maskType:maskType options:options completeHandler:complete]];
}


+ (void)sync_delete:(NSInteger)pk
           maskType:(NAProgressHUDMaskType)maskType
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete{
    [NARestHelper syncDelete:[NARestQueryObject query:nil pk:pk objectID:nil model:self maskType:maskType options:options completeHandler:complete]];
}


+ (void)sync_rpc:(NSDictionary *)query
         rpcname:(NSString *)rpcname
        maskType:(NAProgressHUDMaskType)maskType
         options:(NSDictionary *)options
        complete:(void(^)(NSError *err))complete{
    NARestQueryObject *qo = [NARestQueryObject query:query model:self maskType:maskType options:options completeHandler:complete];
    [qo setRpcName:rpcname];
    [NARestHelper syncRPC:qo];
}

+ (void)sync_filter:(NSDictionary *)query
           complete:(void(^)(NSError *err))complete{
    [self sync_filter:query maskType:NAProgressHUDMaskTypeDefault options:nil complete:complete];
}
+ (void)sync_get:(NSInteger)pk
        complete:(void(^)(NSError *err))complete{
    [self sync_get:pk maskType:NAProgressHUDMaskTypeDefault options:nil complete:complete];
}
+ (void)sync_create:(NSDictionary *)query
           complete:(void(^)(NSError *err))complete{
    [self sync_create:query maskType:NAProgressHUDMaskTypeDefault options:nil complete:complete];
}
+ (void)sync_update:(NSInteger)pk
              query:(NSDictionary *)query
           complete:(void(^)(NSError *err))complete{
    [self sync_update:pk query:query maskType:NAProgressHUDMaskTypeDefault options:nil complete:complete];
}
+ (void)sync_delete:(NSInteger)pk
           complete:(void(^)(NSError *err))complete{
    [self sync_delete:pk maskType:NAProgressHUDMaskTypeDefault options:nil complete:complete];
}
+ (void)sync_rpc:(NSDictionary *)query
         rpcname:(NSString *)rpcname
        complete:(void(^)(NSError *err))complete{
    [self sync_rpc:query rpcname:rpcname maskType:NAProgressHUDMaskTypeDefault options:nil complete:complete];
}


/*
 bulk commands
 */

+ (void)sync_bulk_update_or_create:(NSDictionary *)query
                          maskType:(NAProgressHUDMaskType)maskType
                           options:(NSDictionary *)options{
    NSDictionary *newQuery = nil;
    if(query){
        NSMutableDictionary *temp = [query mutableCopy];
        [temp addEntriesFromDictionary:@{@"sync_state": @(NASyncModelSyncStateEDITED)}];
        newQuery = temp;
    }else{
        newQuery = @{@"sync_state": @(NASyncModelSyncStateEDITED)};
    }
    NSArray *mos = [self filter:newQuery options:nil];
    for (NSManagedObject *mo in mos) {
        if(mo.guid_for_sync != NASyncModelGUIDTypeNotInServer){
            [mo sync_update:maskType options:options complete:nil];
        }else{
            [mo sync_create:maskType options:options complete:nil];
        }
    }
}

+ (void)sync_bulk_delete:(NSDictionary *)query
                maskType:(NAProgressHUDMaskType)maskType
                 options:(NSDictionary *)options{
    NSDictionary *newQuery = nil;
    if(query){
        NSMutableDictionary *temp = [query mutableCopy];
        [temp addEntriesFromDictionary:@{@"sync_state": @(NASyncModelSyncStateEDITED)}];
        newQuery = temp;
    }else{
        newQuery = @{@"sync_state": @(NASyncModelSyncStateEDITED)};
    }
    NSArray *mos = [self filter:newQuery options:nil];
    for (NSManagedObject *mo in mos) {
        if(mo.guid_for_sync != NASyncModelGUIDTypeNotInServer){
            [mo sync_delete:maskType options:options complete:nil];
        }else{
            [mo local_delete:options];
        }
    }
}

+ (void)sync:(NSDictionary *)query
    maskType:(NAProgressHUDMaskType)maskType
     options:(NSDictionary *)options{
    [self sync_bulk_update_or_create:query maskType:maskType options:options];
    [self sync_bulk_delete:query maskType:maskType options:options];
    [self sync_filter:query maskType:maskType options:options complete:nil];
}

+ (void)sync_bulk_update_or_create:(NSDictionary *)query{
    [self sync_bulk_update_or_create:query maskType:NAProgressHUDMaskTypeDefault options:nil];
}
+ (void)sync_bulk_delete:(NSDictionary *)query{
    [self sync_bulk_delete:query maskType:NAProgressHUDMaskTypeDefault options:nil];
}
+ (void)sync:(NSDictionary *)query{
    [self sync:query maskType:NAProgressHUDMaskTypeDefault options:nil];
}

/*
 instance methods
 */
- (void)sync_get:(NAProgressHUDMaskType)maskType
         options:(NSDictionary *)options
        complete:(void(^)(NSError *err))complete{
    [NARestHelper syncGet:[NARestQueryObject query:nil pk:[self guid_for_sync] objectID:self.objectID model:[self class] maskType:maskType options:options completeHandler:complete]];
}

- (void)sync_create:(NAProgressHUDMaskType)maskType
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete{
    NSDictionary *query = [self getQuery];
    [NARestHelper syncCreate:[NARestQueryObject query:query model:[self class] maskType:maskType options:options completeHandler:complete]];
}

- (void)sync_update:(NSDictionary *)query
           maskType:(NAProgressHUDMaskType)maskType
            options:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    [self local_update:query options:options];
    query = [self getQuery];
    [NARestHelper syncUpdate:[NARestQueryObject query:query pk:[self guid_for_sync] objectID:self.objectID model:[self class] maskType:maskType options:options completeHandler:complete]];
}

- (void)sync_update:(NAProgressHUDMaskType)maskType
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete{
    NSDictionary *query = [self getQuery];
    [NARestHelper syncUpdate:[NARestQueryObject query:query pk:[self guid_for_sync] objectID:self.objectID model:[self class] maskType:maskType options:options completeHandler:complete]];
}

- (void)sync_delete:(NAProgressHUDMaskType)maskType
            options:(NSDictionary *)options
           complete:(void(^)(NSError *err))complete{
    [NARestHelper syncDelete:[NARestQueryObject query:nil pk:[self guid_for_sync] objectID:self.objectID model:[self class] maskType:maskType options:options completeHandler:complete]];
}

- (void)sync_rpc:(NSDictionary *)query
         rpcname:(NSString *)rpcname
        maskType:(NAProgressHUDMaskType)maskType
         options:(NSDictionary *)options
        complete:(void(^)(NSError *err))complete{
    NARestQueryObject *qo = [NARestQueryObject query:query pk:[self guid_for_sync] objectID:self.objectID model:[self class] maskType:maskType options:options completeHandler:complete];
    [qo setRpcName:rpcname];
    [NARestHelper syncEachRPC:qo];
}

//easy alias
- (void)sync_get:(void(^)(NSError *err))complete{
    [self sync_get:0 options:nil complete:complete];
}
- (void)sync_create:(void(^)(NSError *err))complete{
    [self sync_create:0 options:nil complete:complete];
}
- (void)sync_update:(NSDictionary *)query
           complete:(void(^)(NSError *err))complete{
    [self sync_update:query maskType:NAProgressHUDMaskTypeDefault options:nil complete:complete];
}
- (void)sync_update:(void(^)(NSError *err))complete{
    [self sync_update:0 options:nil complete:complete];
}
- (void)sync_delete:(void(^)(NSError *err))complete{
    [self sync_delete:0 options:nil complete:complete];
}
- (void)sync_rpc:(NSDictionary *)query
         rpcname:(NSString *)rpcname
        complete:(void(^)(NSError *err))complete{
    [self sync_rpc:query rpcname:rpcname maskType:NAProgressHUDMaskTypeDefault options:nil complete:complete];
}


/*
 instance methods without sync
 */
- (void)local_update:(NSDictionary *)query options:(NSDictionary *)options{
    NSDictionary *old_edited_data = [self edited_data_for_sync];
    NSDictionary *new_edited_data = query;
    if(old_edited_data){
        NSMutableDictionary *temp = [old_edited_data mutableCopy];
        [temp addEntriesFromDictionary:query];
        new_edited_data = temp;
    }
    self.edited_data_for_sync = new_edited_data;
}

- (void)local_delete:(NSDictionary *)options{
    if([self guid_for_sync] == NASyncModelGUIDTypeNotInServer){
        [self delete:nil];
    }else{
        if([self sync_state_for_sync] != NASyncModelSyncStateDELETED){
            self.sync_state_for_sync = NASyncModelSyncStateDELETED;
        }
    }
}


#warning ここはthread safeじゃないのでcontext performBlockを利用すべきだが．．パフォーマンスを考えて保留
/*
 is_syncing_のtoggle
 threadが気になるので外だしする
 */
+ (void)syncing_on:(NSManagedObjectID *)objectID{
    //    NASyncModel *sm = (NASyncModel *)[[[self class] mainContext] objectWithID:objectID];
    //    sm.is_syncing_ = YES;
}

+ (void)syncing_off:(NSManagedObjectID *)objectID{
    //    NASyncModel *sm = (NASyncModel *)[[[self class] mainContext] objectWithID:objectID];
    //    sm.is_syncing_ = NO;
}


/*
 canceling
 */
+ (void)sync_cancel{
    [self sync_cancel:NARestTypeFILTER rpcname:nil options:nil handler:nil];
    [self sync_cancel:NARestTypeGET rpcname:nil options:nil handler:nil];
    [self sync_cancel:NARestTypeCREATE rpcname:nil options:nil handler:nil];
    [self sync_cancel:NARestTypeUPDATE rpcname:nil options:nil handler:nil];
}

+ (void)sync_cancel:(NARestType)restType rpcname:(NSString *)rpcname options:(NSDictionary *)options handler:(void(^)())handler{
    [NARestHelper cancel:restType rpcname:rpcname modelkls:self options:options handler:handler];
}

/*
 変更検知に含めるkey
 */
+ (NSArray *)is_auto_change_sync_state_management_keys{
    static NSArray *__edited_management_include_keys__ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __edited_management_include_keys__ = @[
        @"edited_data",
        ];
    });
    return __edited_management_include_keys__;
}
/*
 変更検知のマニュアル化
 default: YES
 */
+ (BOOL)is_auto_change_sync_state_management{
    return YES;
}


#warning didChangeValueForKeyはカテゴリだと無理
/*
 変更の検知はここで行う．
 これカテゴリだと無理だな！！
 */
//- (void)didChangeValueForKey:(NSString *)key{
//    if([[self class] is_auto_change_sync_state_management]){
//        BOOL bl = NO;
//        for(NSString *ex_key in [[self class] is_auto_change_sync_state_management_keys]){
//            if([key isEqualToString:ex_key]){
//                bl = YES;
//                break;
//            }
//        }
//        if(bl){
//            if(self.sync_state_for_sync == NASyncModelSyncStateSYNCED){
//                self.sync_state_for_sync = NASyncModelSyncStateEDITED;
//            }
//        }
//    }
//    [super didChangeValueForKey:key];
//}

@end
