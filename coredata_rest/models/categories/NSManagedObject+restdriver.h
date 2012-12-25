//
//  NASyncModel+rest.h
//  SK3
//
//  Created by nashibao on 2012/10/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NARestDriverProtocol.h"

#import "NSManagedObject+na.h"

#import "NARestMapper.h"

@interface NSManagedObject (restdriver)

+ (id<NARestDriverProtocol>) restDriver;

+ (Class)restMapperClass;
+ (NARestMapper *) restMapper;

+ (NSString *)restName;

+ (NSString *)restModelName;

+ (NSString *)restEndpoint;

+ (NSString *)restEntityName;

+ (NSString *)restCallbackName;

+ (void)prepareData:(id)data context:(NSManagedObjectContext *)context;

- (void)updateByServerItemData:(id)itemData context:(NSManagedObjectContext *)context;

@end
