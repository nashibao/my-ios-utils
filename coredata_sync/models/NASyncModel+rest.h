//
//  NASyncModel+rest.h
//  SK3
//
//  Created by nashibao on 2012/10/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASyncModel.h"

#import "NARestDriverProtocol.h"

#import "NSManagedObject+na.h"

#import "NASyncModelProtocol.h"

#import "NASyncModelRestProtocol.h"

#import "NASyncModel+sync.h"

#import "NASyncHelper.h"

@interface NASyncModel (rest)

+ (NSInteger)primaryKeyInServerItemData:(id)itemData;
+ (NSDate *)modifiedDateInServerItemData:(id)itemData;
- (BOOL)conflictedToServerItemData:(id)itemData;

#warning さすがに引数が多すぎるから、objectにでもまとめるか．．
+ (NASyncModelSyncError)updateByServerData:(id)data
                                  restType:(NARestType)restType
                                 inContext:(NSManagedObjectContext *)context
                                     query:(NASyncQueryObject *)query
                        network_identifier:(NSString *)network_identifier
                  network_cache_identifier:(NSString *)network_cache_identifier;

+ (NSError *)isErrorByServerData:(id)data
                        restType:(NARestType)restType
                       inContext:(NSManagedObjectContext *)context
                           query:(NASyncQueryObject *)query
              network_identifier:(NSString *)network_identifier
        network_cache_identifier:(NSString *)network_cache_identifier;

+ (NASyncModelSyncError)deupdateByServerError:(NSError *)error
                                         data:(id)data
                                     restType:(NARestType)restType
                                    inContext:(NSManagedObjectContext *)context
                                        query:(NASyncQueryObject *)query
                           network_identifier:(NSString *)network_identifier
                     network_cache_identifier:(NSString *)network_cache_identifier;

- (void)updateByServerItemData:(id)itemData;
- (NSDictionary *)getQuery;

+ (id<NARestDriverProtocol>) restDriver;
+ (NSString *)restName;

+ (NSString *)restModelName;
+ (NSString *)restEndpoint;
+ (NSString *)restEntityName;
+ (NSString *)restCallbackName;

+ (NASyncModelConflictOption)conflictOption;
+ (NASyncModelErrorOption)errorOption;

- (void)resolveConflictByOption:(NASyncModelConflictOption)conflictOption
                           data:(id)data
                       restType:(NARestType)restType
                      inContext:(NSManagedObjectContext *)context
                          query:(NASyncQueryObject *)query;

@end
