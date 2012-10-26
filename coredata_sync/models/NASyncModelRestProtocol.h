//
//  NASyncModelRestProtocol.h
//  SK3
//
//  Created by nashibao on 2012/10/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(NASyncModelRestProtocol)

+ (NSInteger)primaryKeyInServerItemData:(id)itemData;
+ (NSDate *)modifiedDateInServerItemData:(id)itemData;

+ (BOOL)updateByServerData:(id)data restType:(NARestType)restType inContext:(NSManagedObjectContext *)context options:(NSDictionary *)options network_identifier:(NSString *)network_identifier network_cache_identifier:(NSString *)network_cache_identifier;

+ (id<NARestDriverProtocol>) restDriver;
+ (NSString *)restName;

+ (NSString *)restModelName;
+ (NSString *)restEndpoint;
+ (NSString *)restEntityName;
+ (NSString *)restCallbackName;

+ (NASyncModelConflictOption)conflictOption;

@end
