//
//  NAMappingDriver.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NARestDriver.h"

@interface NAMappingDriver : NSObject

@property (strong, nonatomic) NSString *endpoint;
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSString *callbackName;
@property (strong, nonatomic) NSDictionary *primaryKey;
@property (strong, nonatomic) NSDictionary *jsonKeys;
@property (strong, nonatomic) NSDictionary *queryKeys;
@property (strong, nonatomic) NSDictionary *uniqueKeys;
@property (strong, nonatomic) NARestDriver *restDriver;
@property (strong, nonatomic) NSManagedObjectContext *mainContext;

- (NSDictionary *)mo2query:(NSManagedObject *)mo;
- (NSDictionary *)json2dictionary:(NSDictionary *)json;
- (NSDictionary *)json2uniqueDictionary:(NSDictionary *)json;

@end
