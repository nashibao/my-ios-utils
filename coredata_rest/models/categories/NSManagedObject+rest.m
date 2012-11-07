//
//  NASyncModel+rest.m
//  SK3
//
//  Created by nashibao on 2012/10/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSManagedObject+rest.h"

#import "NSManagedObjectContext+na.h"

#import "AccessorMacros.h"

@implementation NSManagedObject (rest)

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

- (void)updateByServerItemData:(id)itemData{
//    それぞれのマッピング
}

+ (NASyncModelConflictOption)conflictOption{
    return NASyncModelConflictOptionServerPriority;
}

+ (NASyncModelErrorOption)errorOption{
    return NASyncModelErrorOptionUserAlert;
}

@end
