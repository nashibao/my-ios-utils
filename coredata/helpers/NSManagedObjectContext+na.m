//
//  NSManagedObjectContext+na.m
//  SK3
//
//  Created by nashibao on 2012/10/01.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NSManagedObjectContext+na.h"

#import "NAFetchHelper.h"

@implementation NSManagedObjectContext (na)

- (NSManagedObject *)getObject:(NSString *)entityName props:(NSDictionary *)props{
    NSPredicate* pred = [NAFetchHelper predicateForEqualProps:props];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
	[fetchRequest setPredicate:pred];
	[fetchRequest setEntity:entity];
	
    @try {
        NSError *error;
        NSArray *arr = [self executeFetchRequest:fetchRequest error:&error];
        if(arr && [arr count]>0){
            NSManagedObject *obj = [arr objectAtIndex:0];
            return obj;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%s:%@",__FUNCTION__,exception);
    }
    @finally {
    }
	return nil;
}

- (NSManagedObject *)createObject:(NSString *)entityName props:(NSDictionary *)props{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self];
    for(NSString *key in props){
        id val = props[key];
        [obj setValue:val forKeyPath:key];
    }
    return obj;
}

- (NSManagedObject *)getOrCreateObject:(NSString *)entityName props:(NSDictionary *)props{
    NSManagedObject *obj = [self getObject:entityName props:props];
    if(obj)return obj;
    obj = [self createObject:entityName props:props];
    return obj;
}

#pragma mark delete

- (void)deleteObjectWithCheck:(NSManagedObject *)obj{
    if(!obj)
        return;
    @try {
        [self deleteObject:obj];
    }@catch (NSException *exception) {
        NSLog(@"%s:%@",__FUNCTION__,@"already deleted");
    }@finally {
    }
}

- (void)deleteAllObjects:(NSString *)entityName{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
	
    NSError *error;
    NSArray *items = [self executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *managedObject in items) {
        [self deleteObjectWithCheck:managedObject];
    }
}

- (void)deleteObjectByPath:(NSFetchedResultsController *)fetchedResultController :(NSIndexPath *)indexPath{
    NSManagedObject *mo = [fetchedResultController objectAtIndexPath:indexPath];
    [self deleteObjectWithCheck:mo];
}

@end
