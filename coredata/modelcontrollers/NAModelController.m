//
//  NAModelController.m
//  SK3
//
//  Created by nashibao on 2012/09/28.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAModelController.h"

@implementation NAModelController

- (void)setup:(NSString *)name{
    [self setup:name withBundle:[NSBundle mainBundle]];
}
- (void)setup:(NSString *)name withBundle:(NSBundle *)bundle{
    
    NSString *model_path = [bundle pathForResource:name ofType:@"momd"];
    
    NSURL *model_url = [NSURL fileURLWithPath:model_path];
    
    self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:model_url];
    NSString *directory_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *location = [NSString stringWithFormat:@"%@.sqlite", name];
    NSString *store_path = [directory_path stringByAppendingPathComponent:location];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:store_path]){
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:name ofType:@"sqlite"];
        if(defaultStorePath){
            [[NSFileManager defaultManager] copyItemAtPath:defaultStorePath toPath:store_path error:NULL];
        }
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath:store_path];
    NSError *error = nil;
    self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    if (![self.coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"persistent coodinator creation error %@, %@", error, [error userInfo]);
        abort();
    }
    
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.mainContext setPersistentStoreCoordinator:self.coordinator];
}


@end
