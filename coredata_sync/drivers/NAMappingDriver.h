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
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSString *callbackName;
@property (strong, nonatomic) NSString *primaryKey;
@property (strong, nonatomic) NSDictionary *jsonKeys;
@property (strong, nonatomic) NSDictionary *queryKeys;
@property (strong, nonatomic) NSDictionary *uniqueKeys;
@property (strong, nonatomic) id<NARestDriverProtocol> restDriver;
@property (strong, nonatomic) NSManagedObjectContext *mainContext;

@end
