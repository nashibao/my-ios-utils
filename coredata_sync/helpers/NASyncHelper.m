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
                  response:(NSURLResponse *)resp
                      data:(id)data options:(NSDictionary *)options
               saveHandler:(void(^)())saveHandler
              errorHandler:(void(^)(NSError *err))errorHandler{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:[modelkls coordinator]];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:context queue:nil usingBlock:^(NSNotification *note) {
        [[modelkls mainContext] mergeChangesFromContextDidSaveNotification:note];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(saveHandler)
                saveHandler();
        });
    }];
    
    //    __block __weak NSManagedObjectContext *wcontext = context;
    
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
            BOOL bl = [modelkls updateByServerData:data restType:restType inContext:context options:options network_identifier:network_identifier network_cache_identifier:network_cache_identifier];
            if(bl)
                [context save:nil];
        }@catch (NSException *exception) {
            NSLog(@"%s|%@", __PRETTY_FUNCTION__, exception);
            if(errorHandler)
                errorHandler([NSError errorWithDomain:exception.reason code:0 userInfo:nil]);
        }@finally {
        }
    }];
}

/*
 call when network is errored.
 */
+ (void)_errorByRestType:(NARestType)restType
                modelkls:(Class)modelkls
                response:(NSURLResponse *)resp
                   error:(NSError *)err
                 options:(NSDictionary *)options
             saveHandler:(void(^)())saveHandler
            errorHandler:(void(^)(NSError *err))errorHandler{
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
    if(errorHandler)
        errorHandler(err);
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
+ (void)syncBaseByType:(NARestType)type query:(NSDictionary *)query pk:(NSInteger)pk rpcname:(NSString *)rpcname modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    NSDictionary *option = nil;
    if(rpcname){
        option = @{@"rpc_name": rpcname};
    }
    NSString *url = [[modelkls restDriver] URLByType:type model:[modelkls restModelName] endpoint:[modelkls restEndpoint] pk:pk option:option];
    NANetworkProtocol protocol = [[modelkls restDriver] ProtocolByType:type model:[modelkls restModelName]];
    NSURLRequest *req = [NANetworkGCDHelper requestTo:url query:query protocol:protocol encoding:[[modelkls restDriver] encoding]];
    NSString *network_identifier = [self network_identifier:type rpcname:rpcname modelkls:modelkls options:option];
#pragma mark TODO: queueはsyncmodel用に別個用意するか？？今はglobalBackgroundQueue.
    [NANetworkOperation sendJsonAsynchronousRequest:req jsonOption:NSJSONReadingAllowFragments returnEncoding:[modelkls restDriver].returnEncoding returnMain:NO queue:nil identifier:network_identifier identifierMaxCount:1 queueingOption:NANetworkOperationQueingOptionDefault successHandler:^(NANetworkOperation *op, id data) {
        [self _successByRestType:type modelkls:modelkls response:nil data:data options:options saveHandler:saveHandler errorHandler:errorHandler];
    } errorHandler:^(NANetworkOperation *op, NSError *err) {
        [self _errorByRestType:type modelkls:modelkls response:nil error:err options:options saveHandler:saveHandler errorHandler:errorHandler];
    }];
    //    [NANetworkGCDHelper sendJsonAsynchronousRequest:req jsonOption:NSJSONReadingAllowFragments returnEncoding:driver.restDriver.returnEncoding returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
    //        [self _success:driver response:resp data:data options:options saveHandler:saveHandler errorHandler:errorHandler];
    //    } errorHandler:^(NSURLResponse *resp, NSError *err) {
    //        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
    //        [self _error:driver response:resp error:err options:options saveHandler:saveHandler errorHandler:errorHandler];
    //    }];
}

+ (void)syncFilter:(NSDictionary *)query modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeFILTER query:query pk:0 rpcname:nil modelkls:modelkls options:options saveHandler:saveHandler errorHandler:errorHandler];
}

+ (void)syncGet:(NSInteger)pk modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeGET query:nil pk:pk rpcname:nil modelkls:modelkls options:options saveHandler:saveHandler errorHandler:errorHandler];
}

+ (void)syncCreate:(NSDictionary *)query modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeCREATE query:query pk:0 rpcname:nil modelkls:modelkls options:options saveHandler:saveHandler errorHandler:errorHandler];
}

+ (void)syncUpdate:(NSDictionary *)query pk:(NSInteger)pk modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeUPDATE query:query pk:pk rpcname:nil modelkls:modelkls options:options saveHandler:saveHandler errorHandler:errorHandler];
}

+ (void)syncDelete:(NSInteger)pk modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeDELETE query:nil pk:pk rpcname:nil modelkls:modelkls options:options saveHandler:saveHandler errorHandler:errorHandler];
}
+ (void)syncRPC:(NSDictionary *)query rpcname:(NSString *)rpcname modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler{
    [self syncBaseByType:NARestTypeRPC query:query pk:0 rpcname:rpcname modelkls:modelkls options:options saveHandler:saveHandler errorHandler:errorHandler];
}

@end
