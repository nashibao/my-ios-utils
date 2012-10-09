//
//  SyncBaseModel+sync.m
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "SyncBaseModel+sync.h"

#import "NASyncHelper.h"

@implementation SyncBaseModel (sync)

+ (NSString *)primaryKeyField{
    return [[self driver] primaryKey];
}

- (NSNumber *)primaryKey{
    return [self valueForKey:[[self class] primaryKeyField]];
}

+ (NAMappingDriver *)driver{
	@throw [NSException exceptionWithName:@"MUST_BE_OVERRIDED"
								   reason:@"driver: MUST_BE_OVERRIDED"
								 userInfo:nil];
    return nil;
}

/*
 mapping
 */
+ (NSDictionary *)mo2query:(NSManagedObject *)mo{
    NAMappingDriver *driver = [self driver];
    NSMutableDictionary *temp = [@{} mutableCopy];
    for(NSString *fromkey in [driver queryKeys]){
        NSString *tokey = [driver queryKeys][fromkey];
        id val = [mo valueForKey:fromkey];
        if(val){
            temp[tokey] = val;
        }
    }
    return temp;
}

+ (NSDictionary *)json2dictionary:(NSDictionary *)json{
    NAMappingDriver *driver = [self driver];
    NSMutableDictionary *temp = [@{} mutableCopy];
    for(NSString *fromkey in [driver jsonKeys]){
        NSString *tokey = [driver jsonKeys][fromkey];
        id val = json[fromkey];
        if(val){
            temp[tokey] = val;
        }
    }
    return temp;
}

+ (NSDictionary *)json2uniqueDictionary:(NSDictionary *)json{
    NAMappingDriver *driver = [self driver];
    NSMutableDictionary *temp = [@{} mutableCopy];
    for(NSString *fromkey in [driver jsonKeys]){
        NSString *tokey = [driver jsonKeys][fromkey];
        if([driver uniqueKeys][tokey]){
            id val = json[fromkey];
            if(val){
                temp[tokey] = val;
            }
        }
    }
    return temp;
}



+ (void)sync_filter:(NSDictionary *)query complete:(void(^)())complete{
    [NASyncHelper syncFilter:query driver:[self driver] handler:nil saveHandler:complete];
}

+ (void)sync_get:(NSNumber *)pk complete:(void(^)())complete{
    [NASyncHelper syncGet:pk driver:[self driver] handler:nil saveHandler:complete];
}

- (void)sync_get:(void(^)())complete{
    [NASyncHelper syncGet:[self primaryKey] driver:[[self class] driver] handler:nil saveHandler:complete];
}

+ (void)sync_create:(NSDictionary *)query complete:(void(^)())complete{
    [NASyncHelper syncCreate:query driver:[self driver] handler:nil saveHandler:complete];
}

- (void)sync_create:(void(^)())complete{
    NSDictionary *query = [[self class]mo2query:self];
    [NASyncHelper syncCreate:query driver:[[self class] driver] handler:nil saveHandler:complete];
}

+ (void)sync_update:(NSNumber *)pk query:(NSDictionary *)query complete:(void(^)())complete{
    [NASyncHelper syncUpdate:query pk:pk driver:[self driver] handler:nil saveHandler:complete];
}
- (void)sync_update:(NSDictionary *)query complete:(void(^)())complete{
    [NASyncHelper syncUpdate:query pk:[self primaryKey] driver:[[self class] driver] handler:nil saveHandler:complete];
}



static NSString *__network_identifier__ = nil;

+ (void)set_network_identifier:(NSString *)networkIdentifier{
    if([networkIdentifier isEqualToString:[self network_identifier]])
        return;
    __network_identifier__ = networkIdentifier;
}

+ (NSString *)network_identifier{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __network_identifier__ = nil;
    });
    return __network_identifier__;
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

@end
