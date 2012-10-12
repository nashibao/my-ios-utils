//
//  NAMappingDriver.m
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAMappingDriver.h"

#import "NSManagedObject+na.h"

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

@end
