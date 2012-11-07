//
//  NASyncModel+rest.h
//  SK3
//
//  Created by nashibao on 2012/10/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NARestDriverProtocol.h"

#import "NSManagedObject+na.h"

#import "NASyncModelProtocol.h"

#import "NASyncModelRestProtocol.h"

#import "NSManagedObject+sync.h"

@interface NSManagedObject (rest)

+ (id<NARestDriverProtocol>) restDriver;

+ (NSString *)restName;

+ (NSString *)restModelName;

+ (NSString *)restEndpoint;

+ (NSString *)restEntityName;

+ (NSString *)restCallbackName;

- (void)updateByServerItemData:(id)itemData;

+ (NASyncModelConflictOption)conflictOption;

+ (NASyncModelErrorOption)errorOption;

@end
