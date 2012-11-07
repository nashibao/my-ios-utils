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

#import "NSManagedObject+restapi.h"

#import "NARestQueryObject.h"

/*
 実際のsyncmodelでのrestAPIの実装はこちら
 直接使うことももちろん出来る
 */
@interface NARestHelper : NSObject

+ (void)cancel:(NARestType)restType
       rpcname:(NSString *)rpcname
      modelkls:(Class)modelkls
       options:(NSDictionary *)options
       handler:(void(^)())handler;

+ (NSString *)network_identifier:(NARestType)restType
                         rpcname:(NSString *)rpcname
                        modelkls:(Class)modelkls
                         options:(NSDictionary *)options;

+ (void)syncByRestType:(NARestType)restType query:(NARestQueryObject *)query;

+ (void)syncFilter:(NARestQueryObject *)query;

+ (void)syncGet:(NARestQueryObject *)query;

+ (void)syncCreate:(NARestQueryObject *)query;

+ (void)syncUpdate:(NARestQueryObject *)query;

+ (void)syncDelete:(NARestQueryObject *)query;

+ (void)syncRPC:(NARestQueryObject *)query;

@end
