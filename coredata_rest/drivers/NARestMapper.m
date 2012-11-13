//
//  NARestMapper.m
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "NARestMapper.h"

#import "NSManagedObject+restdriver.h"

#import "NSManagedObject+restobject.h"

#import "NSManagedObjectContext+na.h"

@implementation NARestMapper

- (NSError *)updateByServerData:(id)data
                       restType:(NARestType)restType
                      inContext:(NSManagedObjectContext *)context
                          query:(NARestQueryObject *)query
             network_identifier:(NSString *)network_identifier
       network_cache_identifier:(NSString *)network_cache_identifier{
    
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, data);
    NSArray *items = nil;
    if([query.modelkls restCallbackName]){
        items = data[[query.modelkls restCallbackName]];
    }else{
        items = data;
    }
    
    NSMutableArray *temp = [@[] mutableCopy];
    int cnt = 0;
    NSMutableArray *objs = [@[] mutableCopy];
    for(NSDictionary *d in items){
        NSManagedObject *mo = [context getOrCreateObject:[query.modelkls restEntityName] props:@{[query.modelkls guid_for_sync_key]: @([query.modelkls primaryKeyInServerItemData:d])}];
        id obj = [self _updateByServerItemData:d mo:mo];
        //        エラーを吐いたobjectを把握
        if(obj)
            [objs addObject:obj];
        mo.cache_identifier_for_sync = network_cache_identifier;
        mo.cache_index_for_sync = cnt;
        cnt += 1;
        [temp addObject:mo];
    }
    return [self _afterUpdateByServerData:objs restType:restType
                                inContext:context
                                    query:query
                       network_identifier:network_cache_identifier
                 network_cache_identifier:network_cache_identifier];
}


- (id)_updateByServerItemData:(NSDictionary *)data mo:(NSManagedObject *)mo{
    mo.data_for_sync = data;
    mo.edited_data_for_sync = nil;
    [mo updateByServerItemData:data];
    return nil;
}

- (NSError *)_afterUpdateByServerData:(NSArray *)objs
                             restType:(NARestType)restType
                            inContext:(NSManagedObjectContext *)context
                                query:(NARestQueryObject *)query
                   network_identifier:(NSString *)network_identifier
             network_cache_identifier:(NSString *)network_cache_identifier{
    return nil;
}

- (NSError *)isErrorByServerData:(id)data
                        restType:(NARestType)restType
                       inContext:(NSManagedObjectContext *)context
                           query:(NARestQueryObject *)query
              network_identifier:(NSString *)network_identifier
        network_cache_identifier:(NSString *)network_cache_identifier{
    return nil;
}

- (void)deupdateByServerError:(NSError *)error
                              data:(id)data
                          restType:(NARestType)restType
                         inContext:(NSManagedObjectContext *)context
                             query:(NARestQueryObject *)query
                network_identifier:(NSString *)network_identifier
          network_cache_identifier:(NSString *)network_cache_identifier{
    return;
}

@end
