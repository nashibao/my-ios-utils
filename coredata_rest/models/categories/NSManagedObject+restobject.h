//
//  NSManagedObject+restobject.h
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (restobject)

+ (NSString *)guid_for_sync_key;
+ (NSString *)data_for_sync_key;
+ (NSString *)edited_data_for_sync_key;
+ (NSString *)cache_index_for_sync_key;
+ (NSString *)cache_identifier_for_sync_key;

//@property(nonatomic, readonly)NSString *guid_for_sync_key;
//@property(nonatomic, readonly)NSString *data_for_sync_key;
//@property(nonatomic, readonly)NSString *edited_data_for_sync_key;
//@property(nonatomic, readonly)NSString *cache_index_for_sync_key;
//@property(nonatomic, readonly)NSString *cache_identifier_for_sync_key;

@property(nonatomic, readwrite)NSInteger guid_for_sync;
@property(nonatomic, readwrite)NSDictionary *data_for_sync;
@property(nonatomic, readwrite)NSDictionary *edited_data_for_sync;
@property(nonatomic, readwrite)NSInteger cache_index_for_sync;
@property(nonatomic, readwrite)NSString *cache_identifier_for_sync;

+ (NSInteger)primaryKeyInServerItemData:(id)itemData;

- (NSDictionary *)getQuery;

@end
