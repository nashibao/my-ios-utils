//
//  NSManagedObject+reciever.h
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "NASyncModelProtocol.h"

#import "NASyncModelRestProtocol.h"

@interface NSManagedObject (reciever)

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

- (void)resolveConflictByOption:(NASyncModelConflictOption)conflictOption
                           data:(id)data
                       restType:(NARestType)restType
                      inContext:(NSManagedObjectContext *)context
                          query:(NASyncQueryObject *)query;

- (BOOL)conflictedToServerItemData:(id)itemData;

@end
