//
//  SyncBaseModel+sync.m
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASyncModel+sync.h"

#import "NASyncHelper.h"

#import "NAFetchHelper.h"

#import <objc/runtime.h>

#import "NASyncModel+rest.h"

@implementation NASyncModel (sync)

/*
 class methods
 */
+ (void)sync_filter:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    [NASyncHelper syncFilter:query modelkls:self options:options completeHandler:complete saveHandler:save];
}

+ (void)sync_get:(NSInteger)pk options:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    [NASyncHelper syncGet:pk objectID:nil modelkls:self options:options completeHandler:complete saveHandler:save];
}

+ (void)sync_create:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    [NASyncHelper syncCreate:query modelkls:self options:options completeHandler:complete saveHandler:save];
}

+ (void)sync_update:(NSInteger)pk query:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    [NASyncHelper syncUpdate:query pk:pk objectID:nil modelkls:self options:options completeHandler:complete saveHandler:save];
}


+ (void)sync_delete:(NSInteger)pk options:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    [NASyncHelper syncDelete:pk objectID:nil modelkls:[self class] options:options completeHandler:complete saveHandler:save];
}


+ (void)sync_rpc:(NSDictionary *)query rpcname:(NSString *)rpcname options:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    [NASyncHelper syncRPC:query rpcname:rpcname modelkls:self options:options completeHandler:complete saveHandler:save];
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
            [sm sync_update:options complete:nil save:nil];
        }else{
            [sm sync_create:options complete:nil save:nil];
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
            [sm sync_delete:options complete:nil save:nil];
        }else{
            [sm local_delete:options];
        }
    }
}

+ (void)sync:(NSDictionary *)query options:(NSDictionary *)options{
    [self sync_bulk_update_or_create:query options:options];
    [self sync_bulk_delete:query options:options];
    [self sync_filter:query options:options complete:nil save:nil];
}

/*
 instance methods
 */
- (void)sync_get:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    [NASyncHelper syncGet:[self pk] objectID:self.objectID modelkls:[self class] options:options completeHandler:complete saveHandler:save];
}

- (void)sync_create:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    NSDictionary *query = [self getQuery];
    [NASyncHelper syncCreate:query modelkls:[self class] options:options completeHandler:complete saveHandler:save];
}

- (void)sync_update:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    [NASyncHelper syncUpdate:query pk:[self pk] objectID:self.objectID modelkls:[self class] options:options completeHandler:complete saveHandler:save];
}

- (void)sync_update:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    NSDictionary *query = [self getQuery];
    [NASyncHelper syncUpdate:query pk:[self pk] objectID:self.objectID modelkls:[self class] options:options completeHandler:complete saveHandler:save];
}

- (void)sync_delete:(NSDictionary *)options complete:(void(^)(NSError *err))complete save:(void(^)())save{
    [NASyncHelper syncDelete:[self pk] objectID:self.objectID modelkls:[self class] options:options completeHandler:complete saveHandler:save];
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

/*
 is_syncing_のtoggle
 threadが気になるので外だしする
 */
+ (void)syncing_on:(NSManagedObjectID *)objectID{
    NASyncModel *sm = (NASyncModel *)[[[self class] mainContext] objectWithID:objectID];
    sm.is_syncing_ = YES;
}

+ (void)syncing_off:(NSManagedObjectID *)objectID{
    NASyncModel *sm = (NASyncModel *)[[[self class] mainContext] objectWithID:objectID];
    sm.is_syncing_ = NO;
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
