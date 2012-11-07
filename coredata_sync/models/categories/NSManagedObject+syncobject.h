//
//  NSManagedObject+getmapper.h
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "NASyncModelProtocol.h"

#import "coredata_rest.h"

/** 
 */
@interface NSManagedObject (syncobject)

@property(nonatomic, readonly)NSString *modified_date_for_sync_key;
@property(nonatomic, readonly)NSString *sync_state_for_sync_key;
@property(nonatomic, readonly)NSString *sync_error_for_sync_key;

@property(nonatomic, readwrite)NSDate *modified_date_for_sync;
@property(nonatomic, readwrite)NASyncModelSyncState sync_state_for_sync;
@property(nonatomic, readwrite)NASyncModelSyncError sync_error_for_sync;

+ (NSDate *)modifiedDateInServerItemData:(id)itemData;

+ (NASyncModelConflictOption)conflictOption;

+ (NASyncModelErrorOption)errorOption;

- (BOOL)conflictedToServerItemData:(id)itemData;

@end
