//
//  NASyncModelAdopter.m
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASyncHelper.h"

#import "NANetworkOperation.h"

#import "NSManagedObject+sync.h"

#import "NSManagedObject+rest.h"

#import "NANetworkActivityIndicatorManager.h"

#import "NSURLRequest+na.h"

@implementation NASyncHelper

/*
 call when network is ended.
 */
+ (void)_successByRestType:(NARestType)restType
                     query:(NASyncQueryObject *)query
                identifier:identifier
                  response:(NSURLResponse *)resp
                      data:(id)data{
    __block NSError *err = nil;
    [[query.modelkls mainContext] performBlockOutOfOwnThread:^(NSManagedObjectContext *context){
        
        NSString *network_identifier = @"";
        NSString *network_cache_identifier = @"";
        if(query.options){
            if(query.options[@"network_identifier"])
                network_identifier = query.options[@"network_identifier"];
            if(query.options[@"network_cache_identifier"])
                network_cache_identifier = query.options[@"network_cache_identifier"];
        }
        @try {
            NSError *isError = [query.modelkls isErrorByServerData:data restType:restType inContext:context query:query network_identifier:network_identifier network_cache_identifier:network_cache_identifier];
            NASyncModelSyncError syncError = NASyncModelSyncErrorNone;
            if(isError){
                syncError = [query.modelkls deupdateByServerError:isError data:data restType:restType inContext:context query:query network_identifier:network_identifier network_cache_identifier:network_cache_identifier];
            }else{
                syncError = [query.modelkls updateByServerData:data restType:restType inContext:context query:query network_identifier:network_identifier network_cache_identifier:network_cache_identifier];
            }
            
            NSError *err = nil;
            if(syncError != NASyncModelSyncErrorNone){
                err = [NSError errorWithDomain:@"NASyncModelSyncError" code:syncError userInfo:nil];
                [[NANetworkActivityIndicatorManager sharedManager] insert:identifier error:@"同期エラー" option:query.options];
            }
            
            [context save:nil];
        }@catch (NSException *exception) {
            NSLog(@"%s|%@", __PRETTY_FUNCTION__, exception);
            NSError *err = [NSError errorWithDomain:exception.reason code:0 userInfo:nil];
            NASyncModelSyncError syncError = NASyncModelSyncErrorNone;
            syncError = [query.modelkls deupdateByServerError:err data:data restType:restType inContext:context query:query network_identifier:network_identifier network_cache_identifier:network_cache_identifier];
            if(syncError != NASyncModelSyncErrorNone){
                err = [NSError errorWithDomain:@"NASyncModelSyncError" code:syncError userInfo:nil];
                [[NANetworkActivityIndicatorManager sharedManager] insert:identifier error:@"同期エラー" option:query.options];
            }else{
                err = nil;
            }
            [context save:nil];
        }@finally {
        }
        
    } afterSaveOnMainThread:^(NSNotification *note) {
        if(query.completeHandler)
            query.completeHandler(err);
    }];
}

/*
 call when network is errored.
 */
+ (void)_errorByRestType:(NARestType)restType
                   query:(NASyncQueryObject *)query
              identifier:identifier
                response:(NSURLResponse *)resp
                   error:(NSError *)error{
    __block NSError *err = nil;
    [[query.modelkls mainContext] performBlockOutOfOwnThread:^(NSManagedObjectContext *context) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
        NASyncModelSyncError syncError = NASyncModelSyncErrorNone;
        syncError = [query.modelkls deupdateByServerError:error data:nil restType:restType inContext:context query:query network_identifier:nil network_cache_identifier:nil];
        if(syncError != NASyncModelSyncErrorNone){
            err = [NSError errorWithDomain:@"NASyncModelSyncError" code:syncError userInfo:nil];
            [[NANetworkActivityIndicatorManager sharedManager] insert:identifier error:@"同期エラー" option:query.options];
        }else{
            err = nil;
        }
        [context save:nil];
    } afterSaveOnMainThread:^(NSNotification *note) {
        if(query.completeHandler)
            query.completeHandler(err);
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
+ (void)syncBaseByType:(NARestType)type query:(NASyncQueryObject *)query{
    query.restType = type;
    NSDictionary *option = nil;
    if(query.rpcName){
        option = @{@"rpc_name": query.rpcName};
    }
    NSString *url = [[query.modelkls restDriver] URLByType:type model:[query.modelkls restModelName] endpoint:[query.modelkls restEndpoint] pk:query.pk option:option];
    NANetworkProtocol protocol = [[query.modelkls restDriver] ProtocolByType:type model:[query.modelkls restModelName]];
    NSURLRequest *req = [NSURLRequest request:url query:query.query protocol:protocol encoding:[[query.modelkls restDriver] encoding]];
    NSString *identifier = [self network_identifier:type rpcname:query.rpcName modelkls:query.modelkls options:option];
#warning saveもしてないし．．
    if(query.objectID)
        [query.modelkls syncing_on:query.objectID];
#warning queueはsyncmodel用に別個用意するか？？今はglobalBackgroundQueue.
    [NANetworkOperation sendJsonAsynchronousRequest:req jsonOption:NSJSONReadingAllowFragments returnEncoding:[query.modelkls restDriver].returnEncoding returnMain:NO queue:nil identifier:identifier identifierMaxCount:1 options:query.options queueingOption:NANetworkOperationQueingOptionDefault successHandler:^(NANetworkOperation *op, id data) {
#warning そもそもここにかかずに_success, _error内で処理すべきだな．．
        if(query.objectID)
            [query.modelkls syncing_off:query.objectID];
        [self _successByRestType:type query:query identifier:identifier response:nil data:data];
    } errorHandler:^(NANetworkOperation *op, NSError *err) {
        if(query.objectID)
            [query.modelkls syncing_off:query.objectID];
        [self _errorByRestType:type query:query identifier:identifier response:nil error:err];
    }];
}

+ (void)syncByRestType:(NARestType)restType query:(NASyncQueryObject *)query{
    switch (restType) {
        case NARestTypeCREATE:
            [self syncCreate:query];
            break;
            
        case NARestTypeDELETE:
            [self syncDelete:query];
            break;
            
        case NARestTypeFILTER:
            [self syncFilter:query];
            break;
            
        case NARestTypeGET:
            [self syncGet:query];
            break;
            
        case NARestTypeRPC:
            [self syncRPC:query];
            break;
            
        case NARestTypeUPDATE:
            [self syncUpdate:query];
            break;
            
        default:
            break;
    }
}

+ (void)syncFilter:(NASyncQueryObject *)query{
    [self syncBaseByType:NARestTypeFILTER query:query];
}

+ (void)syncGet:(NASyncQueryObject *)query{
    [self syncBaseByType:NARestTypeGET query:query];
}

+ (void)syncCreate:(NASyncQueryObject *)query{
    [self syncBaseByType:NARestTypeCREATE query:query];
}

+ (void)syncUpdate:(NASyncQueryObject *)query{
    [self syncBaseByType:NARestTypeUPDATE query:query];
}

+ (void)syncDelete:(NASyncQueryObject *)query{
    [self syncBaseByType:NARestTypeDELETE query:query];
}
+ (void)syncRPC:(NASyncQueryObject *)query{
    [self syncBaseByType:NARestTypeRPC query:query];
}

@end
