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
+ (NSManagedObjectContext *)createPrivateContext;

+ (NSArray *)filter:(NSDictionary *)props options:(NSDictionary *)options;
+ (id)get:(NSDictionary *)props options:(NSDictionary *)options;
+ (id)create:(NSDictionary *)props options:(NSDictionary *)options;
+ (id)get_or_create:(NSDictionary *)props options:(NSDictionary *)options;

+ (void)filter:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(NSArray *mos))complete;
+ (void)get:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete;
+ (void)create:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete;
+ (void)get_or_create:(NSDictionary *)props options:(NSDictionary *)options complete:(void(^)(id mo))complete;

@end
