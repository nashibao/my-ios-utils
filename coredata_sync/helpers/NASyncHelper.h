//
//  NASyncModelAdopter.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSManagedObjectContext+na.h"

#import "NARestDriverProtocol.h"

#import "NSManagedObject+sync.h"

#import "NSManagedObject+rest.h"

#import "NASyncModelRestProtocol.h"

#import "NASyncQueryObject.h"

/*
 実際のsyncmodelでのrestAPIの実装はこちら
 直接使うことももちろん出来る
 */
@interface NASyncHelper : NSObject

+ (void)cancel:(NARestType)restType
       rpcname:(NSString *)rpcname
      modelkls:(Class)modelkls
       options:(NSDictionary *)options
       handler:(void(^)())handler;

+ (NSString *)network_identifier:(NARestType)restType
                         rpcname:(NSString *)rpcname
                        modelkls:(Class)modelkls
                         options:(NSDictionary *)options;

+ (void)syncByRestType:(NARestType)restType query:(NASyncQueryObject *)query;

+ (void)syncFilter:(NASyncQueryObject *)query;

+ (void)syncGet:(NASyncQueryObject *)query;

+ (void)syncCreate:(NASyncQueryObject *)query;

+ (void)syncUpdate:(NASyncQueryObject *)query;

+ (void)syncDelete:(NASyncQueryObject *)query;

+ (void)syncRPC:(NASyncQueryObject *)query;

@end
