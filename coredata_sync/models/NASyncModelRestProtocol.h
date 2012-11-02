//
//  NASyncModelRestProtocol.h
//  SK3
//
//  Created by nashibao on 2012/10/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NASyncHelper.h"

#import "NASyncQueryObject.h"

@interface NSObject(NASyncModelRestProtocol)

+ (NSInteger)primaryKeyInServerItemData:(id)itemData;
+ (NSDate *)modifiedDateInServerItemData:(id)itemData;

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

+ (id<NARestDriverProtocol>) restDriver;
+ (NSString *)restName;

+ (NSString *)restModelName;
+ (NSString *)restEndpoint;
+ (NSString *)restEntityName;
+ (NSString *)restCallbackName;

+ (NASyncModelConflictOption)conflictOption;

+ (void)syncing_on:(NSManagedObjectID *)objectID;
+ (void)syncing_off:(NSManagedObjectID *)objectID;

@end
