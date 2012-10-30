//
//  NSManagedObject+na.h
//  SK3
//
//  Created by nashibao on 2012/10/11.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (na)

+ (NSPersistentStoreCoordinator *)coordinator;
+ (NSManagedObjectContext *)mainContext;
+ (void)setMainContext:(NSManagedObjectContext *)context;

+ (NSArray *)filter:(NSDictionary *)props options:(NSDictionary *)options;
+ (id)get:(NSDictionary *)props options:(NSDictionary *)options;
+ (id)create:(NSDictionary *)props options:(NSDictionary *)options;
+ (id)get_or_create:(NSDictionary *)props options:(NSDictionary *)options;

+ (void)filter:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(NSArray *mos))complete;
+ (void)get:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete;
+ (void)create:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete;
+ (void)get_or_create:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete;

+ (void)delete_all;

+ (NSError *)save;

#pragma mark frc用ショートカット

+ (NSFetchedResultsController *)controllerWithEqualProps:(NSDictionary *)equalProps sorts:(NSArray *)sorts context:(NSManagedObjectContext *)context options:(NSDictionary *)options;
+ (NSFetchRequest *)requestWithEqualProps:(NSDictionary *)equalProps sorts:(NSArray *)sorts options:(NSDictionary *)options;
+ (NSFetchedResultsController *)controllerWithProps:(NSArray *)props sorts:(NSArray *)sorts context:(NSManagedObjectContext *)context options:(NSDictionary *)options;
+ (NSFetchRequest *)requestWithProps:(NSArray *)props sorts:(NSArray *)sorts options:(NSDictionary *)options;

@end
