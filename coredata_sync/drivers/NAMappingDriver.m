//
//  NAMappingDriver.m
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAMappingDriver.h"

#import "NSManagedObject+na.h"

#import "NSManagedObjectContext+na.h"

#import "SyncBaseModel+sync.h"

@implementation NAMappingDriver

- (NSPersistentStoreCoordinator *)coordinator{
    return [_syncModel coordinator];
}

- (NSManagedObjectContext *)mainContext{
    return [_syncModel mainContext];
}

- (NSString *)entityName{
    return NSStringFromClass(_syncModel);
}

/*
 mapping
 */
- (NSDictionary *)mo2query:(NSManagedObject *)mo{
    NSMutableDictionary *temp = [@{} mutableCopy];
    for(NSString *fromkey in [self queryKeys]){
        NSString *tokey = [self queryKeys][fromkey];
        id val = [mo valueForKey:fromkey];
        if(val){
            temp[tokey] = val;
        }
    }
    return temp;
}

- (NSDictionary *)json2dictionary:(NSDictionary *)json{
    NSMutableDictionary *temp = [@{} mutableCopy];
    for(NSString *fromkey in [self jsonKeys]){
        NSString *tokey = [self jsonKeys][fromkey];
        id val = json[fromkey];
        if(val){
            temp[tokey] = val;
        }
    }
    return temp;
}

- (NSDictionary *)json2uniqueDictionary:(NSDictionary *)json{
    NSMutableDictionary *temp = [@{} mutableCopy];
    for(NSString *fromkey in [self jsonKeys]){
        NSString *tokey = [self jsonKeys][fromkey];
        if([self uniqueKeys][tokey]){
            id val = json[fromkey];
            if(val){
                temp[tokey] = val;
            }
        }
    }
    return temp;
}

- (id)data2syncVersion:(id)data{
    return data[@"sync_version"];
}

- (BOOL)mappingByRestType:(NARestType)restType data:(id)data inContext:(NSManagedObjectContext *)context options:(NSDictionary *)options network_identifier:(NSString *)network_identifier network_cache_identifier:(NSString *)network_cache_identifier{
    NSArray *items = nil;
    if(self.callbackName){
        items = data[self.callbackName];
    }else{
        items = data;
    }
    NSLog(@"%s|%d", __PRETTY_FUNCTION__, [items count]);
    NSMutableArray *temp = [@[] mutableCopy];
    int cnt = 0;
    NSMutableArray *conflict_sms = [@[] mutableCopy];
    for(NSDictionary *d in items){
        NSManagedObject *mo = [context getOrCreateObject:[self entityName] props:[self json2uniqueDictionary:d]];
        if([mo isKindOfClass:[SyncBaseModel class]]){
            SyncBaseModel *sm = (SyncBaseModel *)mo;
            if([sm isNewByCompareVersion:[self data2syncVersion:d]]){
                if([sm.is_edited boolValue] || [sm.is_deleted boolValue]){
                    [conflict_sms addObject:@{@"smid": [sm objectID], @"data": d}];
                }else{
                    [self setData:d to:sm];
                }
            }
            [sm setNetwork_identifier:network_identifier];
            [sm setNetwork_cache_identifier:network_cache_identifier];
            [sm setNetwork_index:@(cnt)];
            cnt += 1;
        }else{
            [mo setValuesForKeysWithDictionary:[self json2dictionary:d]];
        }
        [temp addObject:mo];
    }
    if([conflict_sms count] > 0){
        BOOL bl = [self conflict:[self mergeOption] sms:conflict_sms context:context];
        return bl;
    }else{
        return YES;
    }
}

- (NAMappingDriverMergeOption)mergeOption{
    return NAMappingDriverMergeOptionAlert;
}

- (BOOL)conflict:(NAMappingDriverMergeOption)mergeOption sms:(NSArray *)sms context:(NSManagedObjectContext *)context{
    switch (mergeOption) {
        case NAMappingDriverMergeOptionServerPriority:
            for (NSDictionary *temp in sms) {
                id data = temp[@"data"];
                SyncBaseModel *sm = (SyncBaseModel *)[context objectWithID:temp[@"smid"]];
                [self setData:data to:sm];
            }
            return YES;
            break;
            
        case NAMappingDriverMergeOptionLocalPriority:
            return NO;
            break;
            
        case NAMappingDriverMergeOptionAutoMerge:
#warning 実装中, いまのところ何もしない
            return YES;
            break;
            
        case NAMappingDriverMergeOptionAlert:{
            __block __weak NAMappingDriver *wself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"同期エラー" message:@"コンフリクトが起きました．ローカルの編集データを破棄してよろしいですか？"];
                [alertView addButtonWithTitle:@"破棄して上書き" handler:^{
                    [context performBlock:^{
                        for (NSDictionary *temp in sms) {
                            id data = temp[@"data"];
                            SyncBaseModel *_sm = (SyncBaseModel *)[context objectWithID:temp[@"smid"]];
                            [wself setData:data to:_sm];
                            [_sm setIs_edited:@NO];
                            [_sm setIs_deleted:@NO];
                        }
                        [context save:nil];
                    }];
                }];
                [alertView addButtonWithTitle:@"ローカルの編集を優先" handler:^{
                    [context save:nil];
#warning なぜかここでエラーが出る！！！！！！！！！！！
                    [wself.syncModel sync_update_all:nil complete:nil error:nil];
                }];
                [alertView addButtonWithTitle:@"何もしない" handler:^{
                    [context save:nil];
                }];
                [alertView show];
            });
            return NO;
            break;
        }
            
        default:
            break;
    }
    return YES;
}

- (void)setData:(id)data to:(SyncBaseModel *)sm{
    [sm setData:data];
    [sm setRaw_data:data];
    [sm setSync_version_for_sync:[self data2syncVersion:data]];
    [sm setValuesForKeysWithDictionary:[self json2dictionary:data]];
}

@end
