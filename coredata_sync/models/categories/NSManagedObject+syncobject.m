//
//  NSManagedObject+getmapper.m
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "NSManagedObject+syncobject.h"

#import "AccessorMacros.h"

@implementation NSManagedObject (syncobject)

- (NSString *)modified_date_for_sync_key{
    return @"modified_date";
}

- (NSString *)sync_state_for_sync_key{
    return @"sync_state";
}

- (NSString *)sync_error_for_sync_key{
    return @"sync_error";
}

INTEGER_ACCESSOR(sync_state_for_sync, setSync_state_for_sync, [self sync_state_for_sync_key], NASyncModelSyncState)
INTEGER_ACCESSOR(sync_error_for_sync, setSync_error_for_sync, [self sync_error_for_sync_key], NASyncModelSyncError)

- (NSDate *)modified_date_for_sync{
    return [self valueForKey:[self modified_date_for_sync_key]];
}

- (void)setModified_date_for_sync:(NSDate *)modified_date_for_sync{
    [self setValue:modified_date_for_sync forKey:[self modified_date_for_sync_key]];
}

+ (NSDate *)modifiedDateInServerItemData:(id)itemData{
    return itemData[@"modified_data"];
}

+ (NASyncModelConflictOption)conflictOption{
    return NASyncModelConflictOptionServerPriority;
}

+ (NASyncModelErrorOption)errorOption{
    return NASyncModelErrorOptionUserAlert;
}

- (BOOL)conflictedToServerItemData:(id)itemData{
    if(!self.modified_date_for_sync)
        return NO;
    if(itemData[@"is_conflicted"])
        return YES;
    return NO;
}

@end
