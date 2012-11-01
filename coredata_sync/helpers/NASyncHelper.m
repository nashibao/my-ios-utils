//
//  NASyncModelAdopter.m
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASyncHelper.h"

#import "NANetworkOperation.h"

#import "NASyncModel+sync.h"

#import "NASyncModel+rest.h"

@implementation NASyncHelper

/*
 call when network is ended.
 */
+ (void)_successByRestType:(NARestType)restType
                  modelkls:(Class)modelkls
                        objectID:(NSManagedObjectID *)objectID
                  response:(NSURLResponse *)resp
                      data:(id)data options:(NSDictionary *)options
               saveHandler:(void(^)())saveHandler
              completeHandler:(void(^)(NSError *err))completeHandler{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:[modelkls coordinator]];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:context queue:nil usingBlock:^(NSNotification *note) {
        [[modelkls mainContext] mergeChangesFromContextDidSaveNotification:note];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(saveHandler)
                saveHandler();
        });
    }];
    
#warning こうしなくて平気か？？ __block __weak NSManagedObjectContext *wcontext = context;
    
    [context performBlock:^{
        NSString *network_identifier = @"";
        NSString *network_cache_identifier = @"";
        if(options){
            if(options[@"network_identifier"])
                network_identifier = options[@"network_identifier"];
            if(options[@"network_cache_identifier"])
                network_cache_identifier = options[@"network_cache_identifier"];
        }
        @try {
            
            NSError *isError = [modelkls isErrorByServerData:data restType:restType inContext:context objectID:objectID options:options network_identifier:network_identifier network_cache_identifier:network_cache_identifier];
            NASyncModelSyncError syncError = NASyncModelSyncErrorNone;
            if(isError){
                syncError = [modelkls deupdateByServerError:isError data:data restType:restType inContext:context objectID:objectID options:options];
            }else{
                syncError = [modelkls updateByServerData:data restType:restType inContext:context objectID:objectID options:options network_identifier:network_identifier network_cache_identifier:network_cache_identifier];
            }
            
            NSError *err = nil;
            if(syncError != NASyncModelSyncErrorNone){
                err = [NSError errorWithDomain:@"NASyncModelSyncError" code:syncError userInfo:nil];
            }
            
            if(completeHandler){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeHandler(err);
                });
            }
            
            [context save:nil];
        }@catch (NSException *exception) {
            NSLog(@"%s|%@", __PRETTY_FUNCTION__, exception);
            NSError *err = [NSError errorWithDomain:exception.reason code:0 userInfo:nil];
            NASyncModelSyncError syncError = NASyncModelSyncErrorNone;
            syncError = [modelkls deupdateByServerError:err data:data restType:restType inContext:context objectID:objectID options:options];
            if(syncError != NASyncModelSyncErrorNone){
                err = [NSError errorWithDomain:@"NASyncModelSyncError" code:syncError userInfo:nil];
            }else{
                err = nil;
            }
            if(completeHandler){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeHandler(nil);
                });
            }
            [context save:nil];
        }@finally {
        }
    }];
}

/*
 call when network is errored.
 */
+ (void)_errorByRestType:(NARestType)restType
                modelkls:(Class)modelkls
                objectID:(NSManagedObjectID *)objectID
                response:(NSURLResponse *)resp
                   error:(NSError *)err
                 options:(NSDictionary *)options
             saveHandler:(void(^)())saveHandler
            completeHandler:(void(^)(NSError *err))completeHandler{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:[modelkls coordinator]];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:context queue:nil usingBlock:^(NSNotification *note) {
        [[modelkls mainContext] mergeChangesFromContextDidSaveNotification:note];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(saveHandler)
                saveHandler();
        });
    }];
    
    [context performBlock:^{
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
        NASyncModelSyncError syncError = NASyncModelSyncErrorNone;
        syncError = [modelkls deupdateByServerError:err data:nil restType:restType inContext:context objectID:objectID options:options];
        NSError *err = nil;
        if(syncError != NASyncModelSyncErrorNone){
            err = [NSError errorWithDomain:@"NASyncModelSyncError" code:syncError userInfo:nil];
        }else{
            err = nil;
        }
        if(completeHandler){
            dispatch_async(dispatch_get_main_queue(), ^{
                completeHandler(nil);
            });
        }
        [context save:nil];
    }];
}

+ (void)cancel:(NARestType)restType rpcname:(NSString *)rpcname modelkls:(Class)modelkls options:(NSDictionary *)options handler:(void(^)())handler{
    NSString *network_identifier = [self network_identifier:restType rpcname:rpcname modelkls:modelkls options:options];
    [NANetworkOperation cancelByIdentifier:network_identifier handler:handler];
}

+ (NSString *)network_identifier:(NARestType)restType rpcname:(NSString *)rpcname modelkls:(Class)modelkls options:(NSDictionary *)options{
    if(options[@"network_identifier"])
        return options[@"network_identifier"];
    if(rpcname){
        return [NSString stringWithFormat:@"__sync_api_%@_%d_%@__", [modelkls restModelName], restType, rpcname];
    }else{
        return [NSString stringWithFormat:@"__sync_api_%@_%d__", [modelkls restModelName], restType];
    }
    return nil;
}

/*
 base function
 */
+ (void)syncBaseByType:(NARestType)type query:(NSDictionary *)query pk:(NSInteger)pk objectID:(NSManagedObjectID *)objectID rpcname:(NSString *)rpcname modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler completeHandler:(void(^)(NSError *err))completeHandler{
    NSDictionary *option = nil;
    if(rpcname){
        option = @{@"rpc_name": rpcname};
    }
    NSString *url = [[modelkls restDriver] URLByType:type model:[modelkls restModelName] endpoint:[modelkls restEndpoint] pk:pk option:option];
    NANetworkProtocol protocol = [[modelkls restDriver] ProtocolByType:type model:[modelkls restModelName]];
    NSURLRequest *req = [NANetworkGCDHelper requestTo:url query:query protocol:protocol encoding:[[modelkls restDriver] encoding]];
    NSString *network_identifier = [self network_identifier:type rpcname:rpcname modelkls:modelkls options:option];
    if(objectID)
        [modelkls syncing_on:objectID];
#pragma mark TODO: queueはsyncmodel用に別個用意するか？？今はglobalBackgroundQueue.
    [NANetworkOperation sendJsonAsynchronousRequest:req jsonOption:NSJSONReadingAllowFragments returnEncoding:[modelkls restDriver].returnEncoding returnMain:NO queue:nil identifier:network_identifier identifierMaxCount:1 queueingOption:NANetworkOperationQueingOptionDefault successHandler:^(NANetworkOperation *op, id data) {
        if(objectID)
            [modelkls syncing_off:objectID];
        [self _successByRestType:type modelkls:modelkls objectID:objectID response:nil data:data options:options saveHandler:saveHandler completeHandler:completeHandler];
    } errorHandler:^(NANetworkOperation *op, NSError *err) {
        if(objectID)
            [modelkls syncing_off:objectID];
        [self _errorByRestType:type modelkls:modelkls objectID:objectID response:nil error:err options:options saveHandler:saveHandler completeHandler:completeHandler];
    }];
    //    [NANetworkGCDHelper sendJsonAsynchronousRequest:req jsonOption:NSJSONReadingAllowFragments returnEncoding:driver.restDriver.returnEncoding returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
    //        [self _success:driver response:resp data:data options:options saveHandler:saveHandler errorHandler:errorHandler];
    //    } errorHandler:^(NSURLResponse *resp, NSError *err) {
    //        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
    //        [self _error:driver response:resp error:err options:options saveHandler:saveHandler errorHandler:errorHandler];
    //    }];
}

+ (void)syncFilter:(NSDictionary *)query modelkls:(Class)modelkls options:(NSDictionary *)options completeHandler:(void(^)(NSError *err))completeHandler saveHandler:(void(^)())saveHandler{
    [self syncBaseByType:NARestTypeFILTER query:query pk:-1 objectID:nil rpcname:nil modelkls:modelkls options:options saveHandler:saveHandler completeHandler:completeHandler];
}

+ (void)syncGet:(NSInteger)pk objectID:(NSManagedObjectID *)objectID modelkls:(Class)modelkls options:(NSDictionary *)options completeHandler:(void(^)(NSError *err))completeHandler saveHandler:(void(^)())saveHandler{
    [self syncBaseByType:NARestTypeGET query:nil pk:pk objectID:objectID rpcname:nil modelkls:modelkls options:options saveHandler:saveHandler completeHandler:completeHandler];
}

+ (void)syncCreate:(NSDictionary *)query modelkls:(Class)modelkls options:(NSDictionary *)options completeHandler:(void(^)(NSError *err))completeHandler saveHandler:(void(^)())saveHandler{
    [self syncBaseByType:NARestTypeCREATE query:query pk:-1 objectID:nil rpcname:nil modelkls:modelkls options:options saveHandler:saveHandler completeHandler:completeHandler];
}

+ (void)syncUpdate:(NSDictionary *)query pk:(NSInteger)pk objectID:(NSManagedObjectID *)objectID modelkls:(Class)modelkls options:(NSDictionary *)options completeHandler:(void(^)(NSError *err))completeHandler saveHandler:(void(^)())saveHandler{
    [self syncBaseByType:NARestTypeUPDATE query:query pk:pk objectID:objectID rpcname:nil modelkls:modelkls options:options saveHandler:saveHandler completeHandler:completeHandler];
}

+ (void)syncDelete:(NSInteger)pk objectID:(NSManagedObjectID *)objectID modelkls:(Class)modelkls options:(NSDictionary *)options completeHandler:(void(^)(NSError *err))completeHandler saveHandler:(void(^)())saveHandler{
    [self syncBaseByType:NARestTypeDELETE query:nil pk:pk objectID:objectID rpcname:nil modelkls:modelkls options:options saveHandler:saveHandler completeHandler:completeHandler];
}
+ (void)syncRPC:(NSDictionary *)query rpcname:(NSString *)rpcname modelkls:(Class)modelkls options:(NSDictionary *)options completeHandler:(void(^)(NSError *err))completeHandler saveHandler:(void(^)())saveHandler{
    [self syncBaseByType:NARestTypeRPC query:query pk:-1 objectID:nil rpcname:rpcname modelkls:modelkls options:options saveHandler:saveHandler completeHandler:completeHandler];
}

@end
