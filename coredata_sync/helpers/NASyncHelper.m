//
//  NASyncModelAdopter.m
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASyncHelper.h"

#import "NANetworkGCDHelper.h"

#import "NSManagedObjectContext+na.h"

#import "SyncBaseModel+sync.h"

@implementation NASyncHelper

/*
 call when network is ended.
 */
+ (void)_success:(NAMappingDriver *)driver response:(NSURLResponse *)resp data:(id)data options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:driver.coordinator];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:context queue:nil usingBlock:^(NSNotification *note) {
        [driver.mainContext mergeChangesFromContextDidSaveNotification:note];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(saveHandler)
                saveHandler();
        });
    }];
    
    [context performBlock:^{
        NSString *network_identifier = @"";
        NSString *network_cache_identifier = @"";
        if(options){
            if(options[@"network_identifier"])
                network_identifier = options[@"network_identifier"];
            if(options[@"network_cache_identifier"])
                network_cache_identifier = options[@"network_cache_identifier"];
        }
        NSArray *items = nil;
        if(driver.callbackName){
            items = data[driver.callbackName];
        }else{
            items = data;
        }
        NSLog(@"%s|%d", __PRETTY_FUNCTION__, [items count]);
        NSMutableArray *temp = [@[] mutableCopy];
        int cnt = 0;
        for(NSDictionary *d in items){
            NSManagedObject *mo = [context getOrCreateObject:[driver entityName] props:[driver json2uniqueDictionary:d]];
            BOOL updated = YES;
            if([mo isKindOfClass:[SyncBaseModel class]]){
                SyncBaseModel *sm = (SyncBaseModel *)mo;
                if([sm.sync_version integerValue] < [d[@"sync_version"] integerValue]){
                    [sm setData:d];
                    [sm setRaw_data:d];
                }else{
                    updated = NO;
                }
                [sm setNetwork_identifier:network_identifier];
                [sm setNetwork_cache_identifier:network_cache_identifier];
                [sm setNetwork_index:@(cnt)];
                cnt += 1;
            }
            if(updated)
                [mo setValuesForKeysWithDictionary:[driver json2dictionary:d]];
            [temp addObject:mo];
        }
        [context save:nil];
    }];
}

/*
 call when network is errored.
 */
+ (void)_error:(NAMappingDriver *)driver response:(NSURLResponse *)resp error:(NSError *)err options:(NSDictionary *)options    saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
    if(errorHandler)
        errorHandler(err);
}

/*
 base function
 */
+ (void)syncBaseByType:(NARestType)type query:(NSDictionary *)query pk:(NSNumber *)pk rpcname:(NSString *)rpcname driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    NSDictionary *option = nil;
    if(rpcname){
        option = @{@"rpc_name": rpcname};
    }
    NSString *url = [driver.restDriver URLByType:type model:driver.modelName endpoint:driver.endpoint pk:pk option:option];
    NANetworkProtocol protocol = [driver.restDriver ProtocolByType:type model:driver.modelName];
    NSURLRequest *req = [NANetworkGCDHelper requestTo:url query:query protocol:protocol encoding:driver.restDriver.encoding];
    [NANetworkGCDHelper sendJsonAsynchronousRequest:req jsonOption:NSJSONReadingAllowFragments returnEncoding:driver.restDriver.returnEncoding returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
        [self _success:driver response:resp data:data options:options saveHandler:saveHandler errorHandler:errorHandler];
    } errorHandler:^(NSURLResponse *resp, NSError *err) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
        [self _error:driver response:resp error:err options:options saveHandler:saveHandler errorHandler:errorHandler];
    }];
}

+ (void)syncFilter:(NSDictionary *)query driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeFILTER query:query pk:nil rpcname:nil driver:driver options:options saveHandler:saveHandler errorHandler:errorHandler];
}

+ (void)syncGet:(NSNumber *)pk driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeGET query:nil pk:pk rpcname:nil driver:driver options:options saveHandler:saveHandler errorHandler:errorHandler];
}

+ (void)syncCreate:(NSDictionary *)query driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeCREATE query:query pk:nil rpcname:nil driver:driver options:options saveHandler:saveHandler errorHandler:errorHandler];
}

+ (void)syncUpdate:(NSDictionary *)query pk:(NSNumber *)pk driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeUPDATE query:query pk:pk rpcname:nil driver:driver options:options saveHandler:saveHandler errorHandler:errorHandler];
}
+ (void)syncRPC:(NSDictionary *)query rpcname:(NSString *)rpcname driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeRPC query:query pk:nil rpcname:rpcname driver:driver options:options saveHandler:saveHandler errorHandler:errorHandler];
}

@end
