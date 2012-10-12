//
//  NAMappingDriver.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NARestDriverProtocol.h"

@interface NAMappingDriver : NSObject

@property (strong, nonatomic) Class syncModel;
@property (strong, nonatomic) NSString *endpoint;
@property (strong, nonatomic) NSString *modelName;
@property (readonly, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSString *callbackName;
@property (strong, nonatomic) NSString *primaryKey;
@property (strong, nonatomic) NSMutableDictionary *jsonKeys;
@property (strong, nonatomic) NSMutableDictionary *queryKeys;
@property (strong, nonatomic) NSMutableDictionary *uniqueKeys;
@property (strong, nonatomic) id<NARestDriverProtocol> restDriver;

@property (readonly, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (readonly, nonatomic) NSManagedObjectContext *mainContext;

- (NSDictionary *)mo2query:(NSManagedObject *)mo;
- (NSDictionary *)json2dictionary:(NSDictionary *)json;
- (NSDictionary *)json2uniqueDictionary:(NSDictionary *)json;

@end
