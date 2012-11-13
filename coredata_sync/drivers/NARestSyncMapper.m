//
//  NARestSyncMapper.m
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "NARestSyncMapper.h"

#import "NSManagedObject+syncobject.h"

@implementation NARestSyncMapper

- (void)resolveConflictByOption:(NASyncModelConflictOption)conflictOption
                           data:(id)data
                             mo:(NSManagedObject *)mo
                       restType:(NARestType)restType
                      inContext:(NSManagedObjectContext *)context
                          query:(NARestQueryObject *)query{
    switch (conflictOption) {
        case NASyncModelConflictOptionServerPriority:
            //            server priority
            mo.data_for_sync = data;
            mo.modified_date_for_sync = [[mo class] modifiedDateInServerItemData:data];
            mo.edited_data_for_sync = nil;
            mo.sync_state_for_sync = NASyncModelSyncStateSYNCED;
            [mo updateByServerItemData:data];
            break;
        case NASyncModelConflictOptionLocalPriority:
            //            local priority
            mo.modified_date_for_sync = [[mo class] modifiedDateInServerItemData:data];
            [mo sync_update:nil complete:nil];
            break;
        case NASyncModelConflictOptionUserAlert:{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"同期エラー" message:@"サーバでの変更とコンフリクトしました．"];
                [alertView setCancelButtonWithTitle:@"編集内容を破棄する" handler:^{
                    [self resolveConflictByOption:NASyncModelConflictOptionServerPriority
                                             data:data
                                             mo:mo
                                         restType:restType
                                        inContext:context
                                            query:query];
                }];
                [alertView addButtonWithTitle:@"リトライ" handler:^{
                    [NARestHelper syncByRestType:restType query:query];
                }];
                [alertView show];
            });
            break;
        }
        case NASyncModelConflictOptionAutoMerge:{
            //            auto merge
            NSMutableDictionary *newData = [data mutableCopy];
            [newData addEntriesFromDictionary:mo.edited_data_for_sync];
            mo.data_for_sync = newData;
            mo.modified_date_for_sync = [[mo class] modifiedDateInServerItemData:data];
            [mo updateByServerItemData:data];
            [mo sync_update:nil complete:nil];
            break;
        }
        default:
            break;
    }
}

- (id)_updateByServerItemData:(NSDictionary *)data mo:(NSManagedObject *)mo{
    
    if([mo conflictedToServerItemData:data]){
        //            conflict
        return @{@"sm":mo, @"data": data, @"option":@([[mo class] conflictOption])};
    }else{
        if(mo.sync_state_for_sync == NASyncModelSyncStateSYNCED){
            //                no conflict
            mo.sync_state_for_sync = NASyncModelSyncErrorNone;
            mo.sync_state_for_sync = NASyncModelSyncStateSYNCED;
            mo.data_for_sync = data;
            mo.modified_date_for_sync = [[mo class] modifiedDateInServerItemData:data];
            mo.edited_data_for_sync = nil;
            [mo updateByServerItemData:data];
        }else{
            if([[mo modified_date_for_sync] compare:[[mo class] modifiedDateInServerItemData:data]] == NSOrderedAscending){
                //                    ローカルで検知したコンフリクト
                return @{@"sm":mo, @"data": data, @"option":@([[mo class] conflictOption])};
            }else{
                //                    local priority
                return @{@"sm":mo, @"data": data, @"option":@(NASyncModelConflictOptionLocalPriority)};
            }
        }
    }
    return nil;
}


- (NSError *)_afterUpdateByServerData:(NSArray *)objs
                             restType:(NARestType)restType
                            inContext:(NSManagedObjectContext *)context
                                query:(NARestQueryObject *)query
                   network_identifier:(NSString *)network_identifier
             network_cache_identifier:(NSString *)network_cache_identifier{
    if([objs count] > 0){
        for (NSDictionary *temp in objs) {
            NSManagedObject *mo = temp[@"sm"];
            mo.sync_error_for_sync = NASyncModelSyncErrorConflict;
            id d = temp[@"data"];
            NASyncModelConflictOption option = [temp[@"option"] integerValue];
            [self resolveConflictByOption:option
                                     data:d
                                       mo:mo
                                 restType:restType
                                inContext:context
                                    query:query];
        }
        return [NSError errorWithDomain:@"同期エラー" code:NASyncModelSyncErrorConflict userInfo:nil];
    }
    return nil;
}

- (void)deupdateByServerError:(NSError *)error
                                         data:(id)data
                                     restType:(NARestType)restType
                                    inContext:(NSManagedObjectContext *)context
                                        query:(NARestQueryObject *)query
                           network_identifier:(NSString *)network_identifier
                     network_cache_identifier:(NSString *)network_cache_identifier{
    NSManagedObject *mo = nil;
    if(query.objectID){
        mo = [context objectWithID:query.objectID];
        mo.sync_error_for_sync = NASyncModelSyncErrorOther;
    }
    switch ([query.modelkls errorOption]) {
        case NASyncModelErrorOptionLeave:
            break;
        case NASyncModelErrorOptionResign:{
            if(mo){
                mo.edited_data_for_sync = nil;
                mo.sync_state_for_sync = NASyncModelSyncStateSYNCED;
            }
            break;
        }
        case NASyncModelErrorOptionResignAndAlert:{
            if(mo){
                mo.edited_data_for_sync = nil;
                mo.sync_state_for_sync = NASyncModelSyncStateSYNCED;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"ネットワークエラー" message:error.domain];
                [alertView setCancelButtonWithTitle:@"閉じる" handler:^{
                }];
                [alertView show];
            });
            break;
        }
        case NASyncModelErrorOptionRetry:{
            break;
        }
        case NASyncModelErrorOptionUserAlert:{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"ネットワークエラー" message:@"通信できませんでした．"];
                if(mo){
                    [alertView setCancelButtonWithTitle:@"編集内容を破棄する" handler:^{
                        [self resolveConflictByOption:NASyncModelConflictOptionServerPriority
                                               data:data
                                                   mo:mo
                                             restType:restType
                                            inContext:context
                                                query:query];
                    }];
                }else{
                    [alertView setCancelButtonWithTitle:@"閉じる" handler:^{
                    }];
                }
                [alertView addButtonWithTitle:@"リトライ" handler:^{
                    [NARestHelper syncByRestType:restType query:query];
                }];
                [alertView show];
                
            });
            break;
        }
        default:
            break;
    }
}

@end
