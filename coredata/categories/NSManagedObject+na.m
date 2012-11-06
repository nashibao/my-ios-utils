//
//  NSManagedObject+na.m
//  SK3
//
//  Created by nashibao on 2012/10/11.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSManagedObject+na.h"

#import "NSManagedObjectContext+na.h"

#import "NSPredicate+na.h"

#import <objc/runtime.h>

@implementation NSManagedObject (na)

+ (NSPersistentStoreCoordinator *)coordinator{
    if ([self mainContext])
        return [[self mainContext] persistentStoreCoordinator];
    return nil;
}

static NSManagedObjectContext * __main_context__ = nil;

+ (NSManagedObjectContext *)mainContext{
    return __main_context__;
}

+ (void)setMainContext:(NSManagedObjectContext *)context{
    __main_context__ = context;
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
    [[self mainContext] performBlockOutOfOwnThread:^(NSManagedObjectContext *context) {
        NSArray *mos = [context filterObjects:NSStringFromClass(self) props:props];
        if(complete)
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(mos);
            });
    } afterSaveOnMainThread:nil];
}

+ (void)get:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete{
    [[self mainContext] performBlockOutOfOwnThread:^(NSManagedObjectContext *context) {
        id mo = [context getObject:NSStringFromClass(self) props:props];
        if(complete)
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(mo);
        });
    } afterSaveOnMainThread:nil];
}

+ (void)create:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete{
    __block id mo = nil;
    [[self mainContext] performBlockOutOfOwnThread:^(NSManagedObjectContext *context) {
        mo = [context createObject:NSStringFromClass(self) props:props];
        [context save:nil];
    } afterSaveOnMainThread:^(NSNotification *note) {
        if(complete)
            complete(mo);
    }];
}

+ (void)get_or_create:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete save:(void(^)())save{
    __block id mo = nil;
    [[self mainContext] performBlockOutOfOwnThread:^(NSManagedObjectContext *context) {
        mo = [context getObject:NSStringFromClass(self) props:props];
        if(!mo){
            mo = [context createObject:NSStringFromClass(self) props:props];
            [context save:nil];
        }else{
            if(complete)
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(mo);
                });
        }
    } afterSaveOnMainThread:^(NSNotification *note) {
        if(complete)
            complete(mo);
    }];
}

+ (void)delete_all{
    [[self mainContext] deleteAllObjects:NSStringFromClass(self)];
}

+ (NSError *)save{
    NSError *err = nil;
    [[self mainContext] save:&err];
    return err;
}

+ (NSFetchedResultsController *)controllerWithEqualProps:(NSDictionary *)equalProps sorts:(NSArray *)sorts context:(NSManagedObjectContext *)context options:(NSDictionary *)options{
    NSFetchRequest *req = [self requestWithEqualProps:equalProps sorts:sorts options:options];
    if(!context)
        context = [self mainContext];
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:req managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return frc;
}

+ (NSFetchRequest *)requestWithEqualProps:(NSDictionary *)equalProps sorts:(NSArray *)sorts options:(NSDictionary *)options{
    NSString *class_name = [NSString stringWithCString:class_getName(self) encoding:NSUTF8StringEncoding];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:class_name];
    NSMutableArray *_sorts = [@[] mutableCopy];
    for(NSString *sort in sorts){
        BOOL asc = YES;
        NSRange range = [sort rangeOfString:@"-"];
        NSString *temp = sort;
        if(range.location==0 && range.length>0){
            temp = [sort stringByReplacingOccurrencesOfString:@"-" withString:@""];
            asc = NO;
        }
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:temp ascending:asc];
        [_sorts addObject:sd];
    }
    [req setSortDescriptors:_sorts];
    NSPredicate *pred = nil;
    if(equalProps && [equalProps count] > 0)
        pred = [NSPredicate predicateForEqualProps:equalProps];
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
    NSPredicate *pred = nil;
    if(props && [props count] > 0)
        pred = [NSPredicate predicateForProps:props];
    if(pred)
        [req setPredicate:pred];
    return req;
}


@end
