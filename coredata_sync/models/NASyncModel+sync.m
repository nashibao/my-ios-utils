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
+ (void)sync_filter:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    [NASyncHelper syncFilter:query modelkls:self options:options saveHandler:complete errorHandler:error];
}

+ (void)sync_get:(NSInteger)pk options:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    [NASyncHelper syncGet:pk modelkls:self options:options saveHandler:complete errorHandler:error];
}

+ (void)sync_create:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    [NASyncHelper syncCreate:query modelkls:self options:options saveHandler:complete errorHandler:error];
}

+ (void)sync_update:(NSInteger)pk query:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    [NASyncHelper syncUpdate:query pk:pk modelkls:self options:options saveHandler:complete errorHandler:error];
}

+ (void)sync_bulk_update:(NSDictionary *)query options:(NSDictionary *)options{
    NSArray *edited_sms = [self filter:@{@"sync_state": @(NASyncModelSyncStateEDITED)} options:nil];
    for (NASyncModel *sm in edited_sms) {
        if(sm.pk != NASyncModelGUIDTypeNotInServer){
            [sm sync_update:options complete:nil error:nil];
        }else{
            [sm sync_create:options complete:nil error:nil];
        }
    }
}

+ (void)sync_delete:(NSInteger)pk options:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    [NASyncHelper syncDelete:pk modelkls:[self class] options:options saveHandler:complete errorHandler:error];
}

+ (void)sync_rpc:(NSDictionary *)query rpcname:(NSString *)rpcname options:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    [NASyncHelper syncRPC:query rpcname:rpcname modelkls:self options:options saveHandler:complete errorHandler:error];
}

+ (void)sync:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    
}


/*
 instance methods
 */
- (void)sync_get:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    [NASyncHelper syncGet:[self pk] modelkls:[self class] options:options saveHandler:complete errorHandler:error];
}

- (void)sync_create:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    NSDictionary *query = [self getQuery];
    [NASyncHelper syncCreate:query modelkls:[self class] options:options saveHandler:complete errorHandler:error];
}

- (void)sync_update:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    [self local_update:query options:options];
    [self sync_update:options complete:complete error:error];
}

- (void)sync_update:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    NSDictionary *query = [self getQuery];
    [NASyncHelper syncUpdate:query pk:[self pk] modelkls:[self class] options:options saveHandler:complete errorHandler:error];
}

- (void)sync_delete:(NSDictionary *)options complete:(void(^)())complete error:(void(^)(NSError *err))error{
    [NASyncHelper syncDelete:[self pk] modelkls:[self class] options:options saveHandler:complete errorHandler:error];
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
