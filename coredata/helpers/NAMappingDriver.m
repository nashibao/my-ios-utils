//
//  NAMappingDriver.m
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAMappingDriver.h"

@implementation NAMappingDriver

- (id)init{
    self = [super init];
    if(self){
        self.primaryKey = @{@"id" : @"pk"};
        self.jsonKeys = @{
        @"id": @"pk",
        @"is_active": @"is_active",
        @"created_at": @"created_at",
        @"updated_at": @"updated_at",
        @"sync_date": @"sync_date",
        @"sync_version": @"sync_version",
        };
        self.queryKeys = @{
        @"pk": @"pk",
        @"is_active": @"is_active",
        @"created_at": @"created_at",
        @"updated_at": @"updated_at",
        @"sync_date": @"sync_date",
        @"sync_version": @"sync_version",
        };
        self.uniqueKeys = @{@"pk": @YES};
        self.restDriver = [[NARestDriver alloc] init];
    }
    return self;
}

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

@end
