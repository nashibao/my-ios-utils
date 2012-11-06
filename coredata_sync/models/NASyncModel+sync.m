//
//  SyncBaseModel+sync.m
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASyncModel+sync.h"

#import "NASyncHelper.h"

#import "NSPredicate+na.h"

#import <objc/runtime.h>

#import "NASyncModel+rest.h"

@implementation NASyncModel (sync)

/*
 class methods
 */
+ (void)sync_filter:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    [NASyncHelper syncFilter:[NASyncQueryObject query:query model:self options:options completeHandler:complete]];
}

+ (void)sync_get:(NSInteger)pk options:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    [NASyncHelper syncGet:[NASyncQueryObject query:nil pk:pk objectID:nil model:self options:options completeHandler:complete]];
}

+ (void)sync_create:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    [NASyncHelper syncCreate:[NASyncQueryObject query:query model:self options:options completeHandler:complete]];
}

+ (void)sync_update:(NSInteger)pk query:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    [NASyncHelper syncUpdate:[NASyncQueryObject query:query pk:pk objectID:nil model:self options:options completeHandler:complete]];
}


+ (void)sync_delete:(NSInteger)pk options:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    [NASyncHelper syncDelete:[NASyncQueryObject query:nil pk:pk objectID:nil model:self options:options completeHandler:complete]];
}


+ (void)sync_rpc:(NSDictionary *)query rpcname:(NSString *)rpcname options:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    NASyncQueryObject *qo = [NASyncQueryObject query:query model:self options:options completeHandler:complete];
    [qo setRpcName:rpcname];
    [NASyncHelper syncRPC:qo];
}


/*
 bulk commands
 */

+ (void)sync_bulk_update_or_create:(NSDictionary *)query options:(NSDictionary *)options{
    NSDictionary *newQuery = nil;
    if(query){
        NSMutableDictionary *temp = [query mutableCopy];
        [temp addEntriesFromDictionary:@{@"sync_state": @(NASyncModelSyncStateEDITED)}];
        newQuery = temp;
    }else{
        newQuery = @{@"sync_state": @(NASyncModelSyncStateEDITED)};
    }
    NSArray *sms = [self filter:newQuery options:nil];
    for (NASyncModel *sm in sms) {
        if(sm.pk != NASyncModelGUIDTypeNotInServer){
            [sm sync_update:options complete:nil];
        }else{
            [sm sync_create:options complete:nil];
        }
    }
}

+ (void)sync_bulk_delete:(NSDictionary *)query options:(NSDictionary *)options{
    NSDictionary *newQuery = nil;
    if(query){
        NSMutableDictionary *temp = [query mutableCopy];
        [temp addEntriesFromDictionary:@{@"sync_state": @(NASyncModelSyncStateEDITED)}];
        newQuery = temp;
    }else{
        newQuery = @{@"sync_state": @(NASyncModelSyncStateEDITED)};
    }
    NSArray *sms = [self filter:newQuery options:nil];
    for (NASyncModel *sm in sms) {
        if(sm.pk != NASyncModelGUIDTypeNotInServer){
            [sm sync_delete:options complete:nil];
        }else{
            [sm local_delete:options];
        }
    }
}

+ (void)sync:(NSDictionary *)query options:(NSDictionary *)options{
    [self sync_bulk_update_or_create:query options:options];
    [self sync_bulk_delete:query options:options];
    [self sync_filter:query options:options complete:nil];
}

/*
 instance methods
 */
- (void)sync_get:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    [NASyncHelper syncGet:[NASyncQueryObject query:nil pk:[self pk] objectID:self.objectID model:[self class] options:options completeHandler:complete]];
}

- (void)sync_create:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    NSDictionary *query = [self getQuery];
    [NASyncHelper syncCreate:[NASyncQueryObject query:query model:[self class] options:options completeHandler:complete]];
}

- (void)sync_update:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    [self local_delete:query];
    query = [self getQuery];
    [NASyncHelper syncUpdate:[NASyncQueryObject query:query pk:[self pk] objectID:self.objectID model:[self class] options:options completeHandler:complete]];
}

- (void)sync_update:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    NSDictionary *query = [self getQuery];
    [NASyncHelper syncUpdate:[NASyncQueryObject query:query pk:[self pk] objectID:self.objectID model:[self class] options:options completeHandler:complete]];
}

- (void)sync_delete:(NSDictionary *)options complete:(void(^)(NSError *err))complete{
    [NASyncHelper syncDelete:[NASyncQueryObject query:nil pk:[self pk] objectID:self.objectID model:[self class] options:options completeHandler:complete]];
}

/*
 instance methods without sync
 */
- (void)local_update:(NSDictionary *)query options:(NSDictionary *)options{
    NSDictionary *old_edited_data = [self edited_data];
    NSDictionary *new_edited_data = query;
    if(old_edited_data){
        NSMutableDictionary *temp = [old_edited_data mutableCopy];
        [temp addEntriesFromDictionary:query];
        new_edited_data = temp;
    }
    self.edited_data = new_edited_data;
}

- (void)local_delete:(NSDictionary *)options{
    if([self pk] == NASyncModelGUIDTypeNotInServer){
        [self delete:nil];
    }else{
        if([self sync_state_] != NASyncModelSyncStateDELETED){
            self.sync_state_ = NASyncModelSyncStateDELETED;
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
    [NASyncHelper cancel:restType rpcname:rpcname modelkls:self options:options handler:handler];
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

/*
 変更の検知はここで行う．
 */
- (void)didChangeValueForKey:(NSString *)key{
    if([[self class] is_auto_change_sync_state_management]){
        BOOL bl = NO;
        for(NSString *ex_key in [[self class] is_auto_change_sync_state_management_keys]){
            if([key isEqualToString:ex_key]){
                bl = YES;
                break;
            }
        }
        if(bl){
            if(self.sync_state_ == NASyncModelSyncStateSYNCED){
                self.sync_state_ = NASyncModelSyncStateEDITED;
            }
        }
    }
    [super didChangeValueForKey:key];
}

@end
