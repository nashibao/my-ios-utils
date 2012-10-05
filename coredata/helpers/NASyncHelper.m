//
//  NASyncModelAdopter.m
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASyncHelper.h"

#import "NANetworkGCDHelper.h"

#import "NSManagedObjectContext+na.h"

#import "NARestDriver.h"

#import "SyncModel+sync.h"

@implementation NASyncHelper

/*
 call when network is ended.
 */
+ (void)_success:(NAMappingDriver *)driver response:(NSURLResponse *)resp data:(id)data handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:driver.coordinator];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:context queue:nil usingBlock:^(NSNotification *note) {
        [driver.mainContext mergeChangesFromContextDidSaveNotification:note];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(saveHandler)
                saveHandler();
        });
    }];
    NSArray *items = nil;
    if(driver.callbackName){
        items = data[driver.callbackName];
    }else{
        items = data;
    }
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, items);
    NSMutableArray *temp = [@[] mutableCopy];
    for(NSDictionary *d in items){
        NSManagedObject *mo = [context getOrCreateObject:[driver entityName] props:[driver json2uniqueDictionary:d]];
        [mo setValuesForKeysWithDictionary:[driver json2dictionary:d]];
        if([mo isKindOfClass:[SyncModel class]]){
            SyncModel *sm = (SyncModel *)mo;
            [sm setData:d];
        }
        [temp addObject:mo];
    }
    [context save:nil];
    if(handler)
        handler(temp, nil);
}

/*
 call when network is errored.
 */
+ (void)_error:(NAMappingDriver *)driver response:(NSURLResponse *)resp error:(NSError *)err handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler{
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
    if(handler)
        handler(nil, err);
}

/*
 base function
 */
+ (void)syncBaseByType:(NARestType)type query:(NSDictionary *)query pk:(NSNumber *)pk driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler{
    NSString *url = [driver.restDriver URLByType:type model:driver.modelName endpoint:driver.endpoint pk:pk];
    NANetworkProtocol protocol = [driver.restDriver ProtocolByType:type model:driver.modelName];
    
    [NANetworkGCDHelper sendAsynchronousRequestByEndPoint:url data:query protocol:protocol encoding:driver.restDriver.encoding returnEncoding:driver.restDriver.returnEncoding jsonOption:NSJSONReadingAllowFragments returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
        [self _success:driver response:resp data:data handler:handler saveHandler:saveHandler];
    } errorHandler:^(NSURLResponse *resp, NSError *err) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
        [self _error:driver response:resp error:err handler:handler saveHandler:saveHandler];
    }];
}

+ (void)syncFilter:(NSDictionary *)query driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler{
    [self syncBaseByType:NARestTypeFILTER query:query pk:nil driver:driver handler:handler saveHandler:saveHandler];
}

+ (void)syncGet:(NSNumber *)pk driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler{
    [self syncBaseByType:NARestTypeGET query:nil pk:pk driver:driver handler:handler saveHandler:saveHandler];
}

+ (void)syncCreate:(NSDictionary *)query driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler{
    [self syncBaseByType:NARestTypeCREATE query:query pk:nil driver:driver handler:handler saveHandler:saveHandler];
}

+ (void)syncUpdate:(NSDictionary *)query pk:(NSNumber *)pk driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler{
    [self syncBaseByType:NARestTypeUPDATE query:query pk:nil driver:driver handler:handler saveHandler:saveHandler];
}

@end
