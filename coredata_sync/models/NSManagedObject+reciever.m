//
//  NSManagedObject+reciever.m
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "NSManagedObject+reciever.h"

#import "NSManagedObject+syncobject.h"

#import "NSManagedObject+serverobject.h"

@implementation NSManagedObject (reciever)


+ (NASyncModelSyncError)updateByServerData:(id)data
                                  restType:(NARestType)restType
                                 inContext:(NSManagedObjectContext *)context
                                     query:(NASyncQueryObject *)query
                        network_identifier:(NSString *)network_identifier
                  network_cache_identifier:(NSString *)network_cache_identifier{
    
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, data);
    NSArray *items = nil;
    if([self restCallbackName]){
        items = data[[self restCallbackName]];
    }else{
        items = data;
    }
    //    NSLog(@"%s|%@", __PRETTY_FUNCTION__, items);
    NSMutableArray *temp = [@[] mutableCopy];
    int cnt = 0;
    NSMutableArray *conflict_sms = [@[] mutableCopy];
    for(NSDictionary *d in items){
        NSManagedObject *mo = [context getOrCreateObject:[self restEntityName] props:@{@"pk": @([self primaryKeyInServerItemData:d])}];
        if([mo conflictedToServerItemData:d]){
            //            conflict
            [conflict_sms addObject:@{@"sm":mo, @"data": d, @"option":@([self conflictOption])}];
        }else{
            if(mo.sync_state_for_sync == NASyncModelSyncStateSYNCED){
                //                no conflict
                mo.sync_state_for_sync = NASyncModelSyncErrorNone;
                mo.data_for_sync = d;
                mo.modified_date_for_sync = [self modifiedDateInServerItemData:d];
                mo.edited_data_for_sync = nil;
                mo.sync_state_for_sync = NASyncModelSyncStateSYNCED;
                [mo updateByServerItemData:d];
            }else{
                if([[mo modified_date_for_sync] compare:[self modifiedDateInServerItemData:d]] == NSOrderedAscending){
                    //                    ローカルで検知したコンフリクト
                    [conflict_sms addObject:@{@"sm":mo, @"data": d, @"option":@([self conflictOption])}];
                }else{
                    //                    local priority
                    [conflict_sms addObject:@{@"sm":mo, @"data": d, @"option":@(NASyncModelConflictOptionLocalPriority)}];
                }
            }
        }
        mo.cache_identifier_for_sync = network_cache_identifier;
        mo.cache_index_for_sync = cnt;
        cnt += 1;
        [temp addObject:mo];
    }
    if([conflict_sms count] > 0){
        for (NSDictionary *temp in conflict_sms) {
            NSManagedObject *mo = temp[@"sm"];
            mo.sync_error_for_sync = NASyncModelSyncErrorConflict;
            id d = temp[@"data"];
            NASyncModelConflictOption option = [temp[@"option"] integerValue];
            [mo resolveConflictByOption:option
                                   data:d
                               restType:restType
                              inContext:context
                                  query:query];
        }
        return NASyncModelSyncErrorConflict;
    }
    return NASyncModelSyncErrorNone;
}

+ (NSError *)isErrorByServerData:(id)data
                        restType:(NARestType)restType
                       inContext:(NSManagedObjectContext *)context
                           query:(NASyncQueryObject *)query
              network_identifier:(NSString *)network_identifier
        network_cache_identifier:(NSString *)network_cache_identifier{
    return nil;
}

+ (NASyncModelSyncError)deupdateByServerError:(NSError *)error
                                         data:(id)data
                                     restType:(NARestType)restType
                                    inContext:(NSManagedObjectContext *)context
                                        query:(NASyncQueryObject *)query
                           network_identifier:(NSString *)network_identifier
                     network_cache_identifier:(NSString *)network_cache_identifier{
#warning useralert, retryはまだ実装してない．．出来ればSVProgressと同じように処理したい．singleton??
    NSManagedObject *mo = nil;
    if(query.objectID){
        mo = [context objectWithID:query.objectID];
        mo.sync_error_for_sync = NASyncModelSyncErrorOther;
    }
    
    switch ([self errorOption]) {
        case NASyncModelErrorOptionLeave:
            break;
        case NASyncModelErrorOptionResign:{
            if(mo){
                mo.edited_data_for_sync = nil;
                mo.sync_state_for_sync = NASyncModelSyncStateSYNCED;
            }
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
                        [mo resolveConflictByOption:NASyncModelConflictOptionServerPriority
                                               data:data restType:restType
                                          inContext:context
                                              query:query];
                    }];
                }else{
                    [alertView setCancelButtonWithTitle:@"閉じる" handler:^{
                    }];
                }
                [alertView addButtonWithTitle:@"リトライ" handler:^{
                    [NASyncHelper syncByRestType:restType query:query];
                }];
                [alertView show];
                
            });
            break;
        }
        default:
            break;
    }
    return NASyncModelSyncErrorOther;
}


- (void)resolveConflictByOption:(NASyncModelConflictOption)conflictOption
                           data:(id)data
                       restType:(NARestType)restType
                      inContext:(NSManagedObjectContext *)context
                          query:(NASyncQueryObject *)query{
    switch (conflictOption) {
        case NASyncModelConflictOptionServerPriority:
            //            server priority
            self.data_for_sync = data;
            self.modified_date_for_sync = [[self class] modifiedDateInServerItemData:data];
            self.edited_data_for_sync = nil;
            self.sync_state_for_sync = NASyncModelSyncStateSYNCED;
            [self updateByServerItemData:data];
            break;
        case NASyncModelConflictOptionLocalPriority:
            //            local priority
            self.modified_date_for_sync = [[self class] modifiedDateInServerItemData:data];
            [self sync_update:nil complete:nil];
            break;
        case NASyncModelConflictOptionUserAlert:{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"同期エラー" message:@"サーバでの変更とコンフリクトしました．"];
                [alertView setCancelButtonWithTitle:@"編集内容を破棄する" handler:^{
                    [self resolveConflictByOption:NASyncModelConflictOptionServerPriority
                                             data:data
                                         restType:restType
                                        inContext:context
                                            query:query];
                }];
                [alertView addButtonWithTitle:@"リトライ" handler:^{
                    [NASyncHelper syncByRestType:restType query:query];
                }];
                [alertView show];
            });
            break;
        }
        case NASyncModelConflictOptionAutoMerge:{
            //            auto merge
            NSMutableDictionary *newData = [data mutableCopy];
            [newData addEntriesFromDictionary:self.edited_data_for_sync];
            self.data_for_sync = newData;
            self.modified_date_for_sync = [[self class] modifiedDateInServerItemData:data];
            [self updateByServerItemData:data];
            [self sync_update:nil complete:nil];
            break;
        }
        default:
            break;
    }
}

- (BOOL)conflictedToServerItemData:(id)itemData{
    if(!self.modified_date_for_sync)
        return NO;
    if(itemData[@"is_conflicted"])
        return YES;
    return NO;
}

@end
