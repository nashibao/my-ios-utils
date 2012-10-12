//
//  SyncBaseModel+sync.m
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "SyncBaseModel+sync.h"

#import "NASyncHelper.h"

#import "NAFetchHelper.h"

#import <objc/runtime.h>

#import "NADefaultMappingDriver.h"

#import "NADefaultRestDriver.h"

@implementation SyncBaseModel (sync)

+ (NAMappingDriver *)driver{
    static NADefaultMappingDriver *__mapping_driver__ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __mapping_driver__ = [[NADefaultMappingDriver alloc] init];
        __mapping_driver__.syncModel = self;
        __mapping_driver__.restDriver = [[NADefaultRestDriver alloc] init];
    });
    return __mapping_driver__;
}

- (NSNumber *)primaryKey{
    return [self valueForKey:[[[self class] driver] primaryKey]];
}


+ (void)sync_filter:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete{
    [NASyncHelper syncFilter:query driver:[self driver] options:options handler:nil saveHandler:complete];
}

+ (void)sync_get:(NSNumber *)pk options:(NSDictionary *)options complete:(void(^)())complete{
    [NASyncHelper syncGet:pk driver:[self driver] options:options handler:nil saveHandler:complete];
}

- (void)sync_get:(NSDictionary *)options complete:(void(^)())complete{
    [NASyncHelper syncGet:[self primaryKey] driver:[[self class] driver] options:options handler:nil saveHandler:complete];
}

+ (void)sync_create:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete{
    [NASyncHelper syncCreate:query driver:[self driver] options:options handler:nil saveHandler:complete];
}

- (void)sync_create:(NSDictionary *)options complete:(void(^)())complete{
    NSDictionary *query = [[[self class] driver] mo2query:self];
    [NASyncHelper syncCreate:query driver:[[self class] driver] options:options handler:nil saveHandler:complete];
}

+ (void)sync_update:(NSNumber *)pk query:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete{
    [NASyncHelper syncUpdate:query pk:pk driver:[self driver] options:options handler:nil saveHandler:complete];
}
- (void)sync_update:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete{
    [NASyncHelper syncUpdate:query pk:[self primaryKey] driver:[[self class] driver] options:options handler:nil saveHandler:complete];
}

static BOOL __is_loading__;

+ (BOOL)is_loading{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __is_loading__ = NO;
    });
    return __is_loading__;
}

+ (void)set_is_loading:(BOOL)is_loading{
    if(is_loading != [self is_loading]){
        __is_loading__ = is_loading;
    }
}

@dynamic is_uploading;

/*
 変更検知から外すkey
 */
+ (NSArray *)exclude_edit_management_keys{
    static NSArray *__exclude_keys__ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __exclude_keys__ = @[
        @"network_cache_identifier",
        @"network_identifier",
        @"pk",
        @"sync_version",
        @"is_deleted",
        @"is_edited",
        @"data",
        @"raw_data",
        @"sync_error",
        ];
    });
    return __exclude_keys__;
}

/*
 変更検知のマニュアル化
 default: YES
 */
+ (BOOL)is_manual_edit_management{
    return YES;
}

/*
 変更の検知はここで行う．
 */
- (void)didChangeValueForKey:(NSString *)key{
    if(![[self class] is_manual_edit_management]){
        BOOL bl = YES;
        for(NSString *ex_key in [[self class] exclude_edit_management_keys]){
            if([key isEqualToString:ex_key]){
                bl = NO;
                break;
            }
        }
        if(bl){
            self.is_edited = @YES;
        }
    }
    [super didChangeValueForKey:key];
}


@end
