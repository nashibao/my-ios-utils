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

+ (NSString *)guid_for_sync_key{
    return @"pk";
}

+ (NSString *)data_for_sync_key{
    return @"data";
}

+ (NSString *)edited_data_for_sync_key{
    return @"edited_data";
}

+ (NSString *)cache_index_for_sync_key{
    return @"cache_index";
}

+ (NSString *)cache_identifier_for_sync_key{
    return @"cache_identifier";
}


INTEGER_ACCESSOR(guid_for_sync, setGuid_for_sync, [[self class] guid_for_sync_key], NSInteger)
INTEGER_ACCESSOR(cache_index_for_sync, setCache_index_for_sync, [[self class] cache_index_for_sync_key], NSInteger)

- (NSDictionary *)data_for_sync{
    return [self valueForKey:[[self class] data_for_sync_key]];
}

- (void)setData_for_sync:(NSDictionary *)data_for_sync{
    [self setValue:data_for_sync forKey:[[self class] data_for_sync_key]];
}

- (NSDictionary *)edited_data_for_sync{
    return [self valueForKey:[[self class] edited_data_for_sync_key]];
}

- (void)setEdited_data_for_sync:(NSDictionary *)edited_data_for_sync{
    [self setValue:edited_data_for_sync forKey:[[self class] edited_data_for_sync_key]];
}

- (NSString *)cache_identifier_for_sync{
    return [self valueForKey:[[self class] cache_identifier_for_sync_key]];
}

- (void)setCache_identifier_for_sync:(NSString *)cache_identifier_for_sync{
    [self setValue:cache_identifier_for_sync forKey:[[self class] cache_identifier_for_sync_key]];
}

- (NSDictionary *)getQuery{
    return self.edited_data_for_sync;
}

+ (NSInteger)primaryKeyInServerItemData:(id)itemData{
    return [itemData[@"id"] integerValue];
}


@end
