//
//  SyncBaseModel.m
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "SyncBaseModel.h"

#import "NAFetchHelper.h"

#import <objc/runtime.h>

@implementation SyncBaseModel

@dynamic network_identifier;
@dynamic network_cache_identifier;

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
