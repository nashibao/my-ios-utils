//
//  NASyncModelAdopter.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NAMappingDriver.h"

/*
 実際のsyncmodelでのrestAPIの実装はこちら
 直接使うことももちろん出来る
 */
@interface NASyncHelper : NSObject

+ (void)cancel:(NARestType)restType rpcname:(NSString *)rpcname driver:(NAMappingDriver *)driver options:(NSDictionary *)options handler:(void(^)())handler;

+ (NSString *)network_identifier:(NARestType)restType rpcname:(NSString *)rpcname driver:(NAMappingDriver *)driver options:(NSDictionary *)options;

+ (void)syncFilter:(NSDictionary *)query driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;
+ (void)syncGet:(NSNumber *)pk driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;
+ (void)syncCreate:(NSDictionary *)query driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;
+ (void)syncUpdate:(NSDictionary *)query pk:(NSNumber *)pk driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;
+ (void)syncRPC:(NSDictionary *)query rpcname:(NSString *)rpcname driver:(NAMappingDriver *)driver options:(NSDictionary *)options saveHandler:(void(^)())saveHandler errorHandler:(void(^)(NSError *err))errorHandler;

@end
