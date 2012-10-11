//
//  NSManagedObject+na.m
//  SK3
//
//  Created by nashibao on 2012/10/11.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSManagedObject+na.h"

#import "NSManagedObjectContext+na.h"

@implementation NSManagedObject (na)

+ (NSPersistentStoreCoordinator *)coordinator{
    return nil;
}

+ (NSManagedObjectContext *)mainContext{
    return nil;
}

+ (NSManagedObjectContext *)createPrivateContext{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:[self coordinator]];
    return context;
}

+ (NSArray *)filter:(NSDictionary *)props options:(NSDictionary *)options{
    return [[self mainContext] filterObjects:NSStringFromClass(self) props:props];
}

+ (id)get:(NSDictionary *)props options:(NSDictionary *)options{
    return [[self mainContext] getObject:NSStringFromClass(self) props:props];
}

+ (id)create:(NSDictionary *)props options:(NSDictionary *)options{
    return [[self mainContext] createObject:NSStringFromClass(self) props:props];
}

+ (id)get_or_create:(NSDictionary *)props options:(NSDictionary *)options{
    return [[self mainContext] getOrCreateObject:NSStringFromClass(self) props:props];
}

+ (void)filter:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(NSArray *mos))complete{
    NSManagedObjectContext *privateContext = [self createPrivateContext];
    [privateContext performBlock:^{
        NSArray *mos = [privateContext filterObjects:NSStringFromClass(self) props:props];
        if(complete)
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(mos);
            });
    }];
}

+ (void)get:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete{
    NSManagedObjectContext *privateContext = [self createPrivateContext];
    [privateContext performBlock:^{
        id mo = [privateContext getObject:NSStringFromClass(self) props:props];
        if(complete)
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(mo);
            });
    }];
}

+ (void)create:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete{
    NSManagedObjectContext *privateContext = [self createPrivateContext];
    __block id mo = nil;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:privateContext queue:nil usingBlock:^(NSNotification *note) {
        [[self mainContext] mergeChangesFromContextDidSaveNotification:note];
        if(complete)
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(mo);
            });
    }];
    [privateContext performBlock:^{
        mo = [privateContext createObject:NSStringFromClass(self) props:props];
        [privateContext save:nil];
    }];
}

+ (void)get_or_create:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete{
    NSManagedObjectContext *privateContext = [self createPrivateContext];
    __block id mo = nil;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:privateContext queue:nil usingBlock:^(NSNotification *note) {
        [[self mainContext] mergeChangesFromContextDidSaveNotification:note];
        if(complete)
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(mo);
            });
    }];
    [privateContext performBlock:^{
        mo = [privateContext getObject:NSStringFromClass(self) props:props];
        if(!mo){
            mo = [privateContext createObject:NSStringFromClass(self) props:props];
            [privateContext save:nil];
        }else{
            if(complete)
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(mo);
                });
        }
    }];
}

@end
