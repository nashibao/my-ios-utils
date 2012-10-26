//
//  NASyncModel+rest.m
//  SK3
//
//  Created by nashibao on 2012/10/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASyncModel+rest.h"

#import "NSManagedObjectContext+na.h"

@implementation NASyncModel (rest)

+ (NSInteger)primaryKeyInServerItemData:(id)itemData{
    return [itemData[@"id"] integerValue];
}

+ (NSDate *)modifiedDateInServerItemData:(id)itemData{
    return itemData[@"modified_data"];
}

- (BOOL)conflictedToServerItemData:(id)itemData{
    if(!self.modified_date_)
        return NO;
    if(itemData[@"is_conflicted"])
        return YES;
    return NO;
}

+ (id<NARestDriverProtocol>)restDriver{
    return nil;
}

+ (NSString *)restName{
    return nil;
}

+ (NSString *)restModelName{
    return [self restName];
}

+ (NSString *)restEndpoint{
    return @"/api/";
}

+ (NSString *)restEntityName{
    return NSStringFromClass([self class]);
}

+ (NSString *)restCallbackName{
    return [self restName];
}

+ (BOOL)updateByServerData:(id)data restType:(NARestType)restType inContext:(NSManagedObjectContext *)context options:(NSDictionary *)options network_identifier:(NSString *)network_identifier network_cache_identifier:(NSString *)network_cache_identifier{
    NSArray *items = nil;
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, data);
    if([self restCallbackName]){
        items = data[[self restCallbackName]];
    }else{
        items = data;
    }
    NSMutableArray *temp = [@[] mutableCopy];
    int cnt = 0;
    NSMutableArray *conflict_sms = [@[] mutableCopy];
    for(NSDictionary *d in items){
        NASyncModel *sm = (NASyncModel *)[context getOrCreateObject:[self restEntityName] props:@{@"pk": @([self primaryKeyInServerItemData:d])}];
        if([sm conflictedToServerItemData:d]){
//            conflict
            [conflict_sms addObject:@{@"sm":sm, @"data": d, @"option":@([self conflictOption])}];
        }else{
            if(sm.sync_state_ == NASyncModelSyncStateSYNCED){
//                no conflict
                sm.data = d;
                sm.modified_date_ = [self modifiedDateInServerItemData:d];
                sm.edited_data = nil;
                sm.sync_state_ = NASyncModelSyncStateSYNCED;
                [sm updateByServerItemData:d];
            }else{
                if([[sm modified_date_] compare:[self modifiedDateInServerItemData:d]] == NSOrderedAscending){
//                    ローカルで検知したコンフリクト
                    [conflict_sms addObject:@{@"sm":sm, @"data": d, @"option":@([self conflictOption])}];
                }else{
//                    local priority
                    [conflict_sms addObject:@{@"sm":sm, @"data": d, @"option":@(NASyncModelConflictOptionLocalPriority)}];
                }
            }
        }
        [sm setCache_identifier_:network_cache_identifier];
        [sm setCache_index_:cnt];
        cnt += 1;
        [temp addObject:sm];
    }
    if([conflict_sms count] > 0){
        for (NSDictionary *temp in conflict_sms) {
            NASyncModel *sm = temp[@"sm"];
            id d = temp[@"data"];
            NASyncModelConflictOption option = [temp[@"option"] integerValue];
            [sm resolveConflictByOption:option data:d];
        }
        return NO;
    }else{
        return YES;
    }
}

- (void)updateByServerItemData:(id)itemData{
//    それぞれのマッピング
}

- (NSDictionary *)getQuery{
    return self.edited_data;
}

+ (NASyncModelConflictOption)conflictOption{
    return NASyncModelConflictOptionServerPriority;
}

- (void)resolveConflictByOption:(NASyncModelConflictOption)conflictOption data:(id)data{
    switch (conflictOption) {
        case NASyncModelConflictOptionServerPriority:
//            server priority
            self.data = data;
            self.modified_date_ = [[self class] modifiedDateInServerItemData:data];
            self.edited_data = nil;
            self.sync_state_ = NASyncModelSyncStateSYNCED;
            [self updateByServerItemData:data];
            break;
        case NASyncModelConflictOptionLocalPriority:
//            local priority
            self.modified_date_ = [[self class] modifiedDateInServerItemData:data];
            [self sync_update:nil complete:nil error:nil];
            break;
        case NASyncModelConflictOptionUserAlert:
//            user alert
#warning conflict時のuser alert.
            break;
        case NASyncModelConflictOptionAutoMerge:{
//            auto merge
            NSMutableDictionary *newData = [data mutableCopy];
            [newData addEntriesFromDictionary:self.edited_data];
            self.data = newData;
            self.modified_date_ = [[self class] modifiedDateInServerItemData:data];
            [self updateByServerItemData:data];
            [self sync_update:nil complete:nil error:nil];
            break;
        }
        default:
            break;
    }
}

@end
