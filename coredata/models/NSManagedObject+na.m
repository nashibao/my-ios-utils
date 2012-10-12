//
//  NSManagedObject+na.m
//  SK3
//
//  Created by nashibao on 2012/10/11.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSManagedObject+na.h"

#import "NSManagedObjectContext+na.h"

#import "NAFetchHelper.h"

#import <objc/runtime.h>

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

+ (NSFetchedResultsController *)controllerWithEqualProps:(NSDictionary *)equalProps sorts:(NSArray *)sorts context:(NSManagedObjectContext *)context options:(NSDictionary *)options{
    NSFetchRequest *req = [self requestWithEqualProps:equalProps sorts:sorts options:options];
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:req managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return frc;
}

+ (NSFetchRequest *)requestWithEqualProps:(NSDictionary *)equalProps sorts:(NSArray *)sorts options:(NSDictionary *)options{
    NSString *class_name = [NSString stringWithCString:class_getName(self) encoding:NSUTF8StringEncoding];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:class_name];
    NSMutableArray *_sorts = [@[] mutableCopy];
    for(NSString *sort in sorts){
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:sort ascending:NO];
        [_sorts addObject:sd];
    }
    [req setSortDescriptors:_sorts];
    NSPredicate *pred = [NAFetchHelper predicateForEqualProps:equalProps];
    if(pred)
        [req setPredicate:pred];
    return req;
}

+ (NSFetchedResultsController *)controllerWithProps:(NSArray *)props sorts:(NSArray *)sorts context:(NSManagedObjectContext *)context options:(NSDictionary *)options{
    NSFetchRequest *req = [self requestWithProps:props sorts:sorts options:options];
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:req managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return frc;
}

+ (NSFetchRequest *)requestWithProps:(NSArray *)props sorts:(NSArray *)sorts options:(NSDictionary *)options{
    NSString *class_name = [NSString stringWithCString:class_getName(self) encoding:NSUTF8StringEncoding];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:class_name];
    NSMutableArray *_sorts = [@[] mutableCopy];
    for(NSString *sort in sorts){
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:sort ascending:NO];
        [_sorts addObject:sd];
    }
    [req setSortDescriptors:_sorts];
    NSPredicate *pred = [NAFetchHelper predicateForProps:props];
    if(pred)
        [req setPredicate:pred];
    return req;
}


@end
