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

@implementation NASyncHelper

+ (void)syncFilter:(NSDictionary *)query driver:(NAMappingDriver *)driver handler:(void(^)(NSArray *mos, NSError *err))handler saveHandler:(void(^)())saveHandler{
    NSString *url = [driver.restDriver filterURLByModel:driver.modelName endpoint:driver.endpoint];
    NANetworkProtocol protocol = [driver.restDriver filterProtocolByModel:driver.modelName];
    [NANetworkGCDHelper sendAsynchronousRequestByEndPoint:url data:query protocol:protocol encoding:driver.restDriver.encoding returnEncoding:driver.restDriver.returnEncoding jsonOption:NSJSONReadingAllowFragments returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, data);
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context setPersistentStoreCoordinator:driver.coordinator];
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:context queue:nil usingBlock:^(NSNotification *note) {
            [driver.mainContext mergeChangesFromContextDidSaveNotification:note];
            if(saveHandler)
                saveHandler();
        }];
        NSArray *items = nil;
        if(driver.callbackName){
            items = data[driver.callbackName];
        }else{
            items = data;
        }
        NSMutableArray *temp = [@[] mutableCopy];
        for(NSDictionary *d in items){
            NSManagedObject *mo = [context getOrCreateObject:[driver entityName] props:[driver json2uniqueDictionary:d]];
            [temp addObject:mo];
        }
        [context save:nil];
        if(handler)
            handler(temp, nil);
    } errorHandler:^(NSURLResponse *resp, NSError *err) {
        
        if(handler)
            handler(nil, err);
    }];
}

@end
