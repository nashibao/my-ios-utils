//
//  NARestMapper.h
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NASyncModelProtocol.h"

#import "NARestDriverProtocol.h"

#import "NARestQueryObject.h"

@interface NARestMapper : NSObject

- (NSError *)updateByServerData:(id)data
                       restType:(NARestType)restType
                      inContext:(NSManagedObjectContext *)context
                          query:(NARestQueryObject *)query
             network_identifier:(NSString *)network_identifier
       network_cache_identifier:(NSString *)network_cache_identifier;

- (NSError *)isErrorByServerData:(id)data
                        restType:(NARestType)restType
                       inContext:(NSManagedObjectContext *)context
                           query:(NARestQueryObject *)query
              network_identifier:(NSString *)network_identifier
        network_cache_identifier:(NSString *)network_cache_identifier;

- (void)deupdateByServerError:(NSError *)error
                              data:(id)data
                          restType:(NARestType)restType
                         inContext:(NSManagedObjectContext *)context
                             query:(NARestQueryObject *)query
                network_identifier:(NSString *)network_identifier
          network_cache_identifier:(NSString *)network_cache_identifier;

@end
