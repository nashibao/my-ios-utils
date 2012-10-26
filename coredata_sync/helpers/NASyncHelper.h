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

#import "NASyncModel+sync.h"

#import "NASyncModel+rest.h"

#import "NASyncModelRestProtocol.h"

/*
 実際のsyncmodelでのrestAPIの実装はこちら
 直接使うことももちろん出来る
 */
@interface NASyncHelper : NSObject

+ (void)cancel:(NARestType)restType rpcname:(NSString *)rpcname modelkls:(Class)modelkls options:(NSDictionary *)options handler:(void(^)())handler;

+ (NSString *)network_identifier:(NARestType)restType rpcname:(NSString *)rpcname modelkls:(Class)modelkls options:(NSDictionary *)options;

+ (void)syncFilter:(NSDictionary *)query modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;
+ (void)syncGet:(NSInteger)pk modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;
+ (void)syncCreate:(NSDictionary *)query modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;
+ (void)syncUpdate:(NSDictionary *)query pk:(NSInteger)pk modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;
+ (void)syncDelete:(NSInteger)pk modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;
+ (void)syncRPC:(NSDictionary *)query rpcname:(NSString *)rpcname modelkls:(Class)modelkls options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;

@end
