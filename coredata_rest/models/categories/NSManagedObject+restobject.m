//
//  NSManagedObject+restobject.m
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "NSManagedObject+restobject.h"

#import "AccessorMacros.h"

@implementation NSManagedObject (restobject)

- (NSString *)guid_for_sync_key{
    return @"pk_";
}

- (NSString *)data_for_sync_key{
    return @"data_";
}

- (NSString *)edited_data_for_sync_key{
    return @"edited_data_";
}

- (NSString *)cache_index_for_sync_key{
    return @"cache_index_";
}

- (NSString *)cache_identifier_for_sync_key{
    return @"cache_identifier_";
}


INTEGER_ACCESSOR(guid_for_sync, setGuid_for_sync, [self guid_for_sync_key], NSInteger)
INTEGER_ACCESSOR(cache_index_for_sync, setCache_index_for_sync, [self cache_index_for_sync_key], NSInteger)

- (NSDictionary *)data_for_sync{
    return [self valueForKey:[self data_for_sync_key]];
}

- (void)setData_for_sync:(NSDictionary *)data_for_sync{
    [self setValue:data_for_sync forKey:[self data_for_sync_key]];
}

- (NSDictionary *)edited_data_for_sync{
    return [self valueForKey:[self edited_data_for_sync_key]];
}

- (void)setEdited_data_for_sync:(NSDictionary *)edited_data_for_sync{
    [self setValue:edited_data_for_sync forKey:[self edited_data_for_sync_key]];
}

- (NSString *)cache_identifier_for_sync{
    return [self valueForKey:[self cache_identifier_for_sync_key]];
}

- (void)setCache_identifier_for_sync:(NSString *)cache_identifier_for_sync{
    [self setValue:cache_identifier_for_sync forKey:[self cache_identifier_for_sync_key]];
}

- (NSDictionary *)getQuery{
    return self.edited_data_for_sync;
}

@end
