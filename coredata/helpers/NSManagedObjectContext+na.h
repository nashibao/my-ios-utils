//
//  NSManagedObjectContext+na.h
//  SK3
//
//  Created by nashibao on 2012/10/01.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <CoreData/CoreData.h>

/*
 NSManagedObjectContext category to add utility functions to get/create/delete mo.
 */
@interface NSManagedObjectContext (na)

- (NSArray *)filterObjects:(NSString *)entityName props:(NSDictionary *)props;
- (NSManagedObject *)getObject:(NSString *)entityName props:(NSDictionary *)props;
- (NSManagedObject *)createObject:(NSString *)entityName props:(NSDictionary *)props;
- (NSManagedObject *)getOrCreateObject:(NSString *)entityName props:(NSDictionary *)props;

#pragma mark delete

- (void)deleteObjectWithCheck:(NSManagedObject *)obj;
- (void)deleteAllObjects:(NSString *)entityName;
- (void)deleteObjectByPath:(NSFetchedResultsController *)fetchedResultController :(NSIndexPath *)indexPath;

@end
