//
//  NAModelController.h
//  SK3
//
//  Created by nashibao on 2012/09/28.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NAFetchHelper.h"

#import "NASyncModel+sync.h"

#import "NSManagedObjectContext+na.h"

#import "NSFetchRequest+na.h"

/*
 model controller class.
 which includes "model", "coordinator", "mainContext".
 setup function made them all.
 
 "mainContext" is a context in the main thread. then don't use it for 
 heavy tasks! you can create new context in background thread.
 */
@interface NAModelController : NSObject

@property (strong, nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (strong, nonatomic) NSManagedObjectContext *mainContext;

/*
 setup function.
 
 <args>
 name: should be xcdatamodeld name.
 (ex)
 if model file is "hoge.xcdatamodeld",
 hoge.sqlite will be created.
 "name" should be @"hoge".
 
 if you added hoge.sqlite in mainbundle, it will be copied to app doc directory
 and used as initial sqlite database.
 */
- (void)setup:(NSString *)name;

/*
 migrations
 */
//- (void)migrate:(NSString *)newpath newversion:(NSInteger)newversion;

@end
