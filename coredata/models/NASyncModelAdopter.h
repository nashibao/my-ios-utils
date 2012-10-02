//
//  NASyncModelAdopter.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 実際のsyncmodelでのrestAPIの実装はこちら
 直接使うことももちろん出来る
 */
@interface NASyncModelAdopter : NSObject

+ (void)as_filter:(NSDictionary *)query handler:(void(^)(NSArray *mos, NSError *err))handler;
+ (void)as_get:(NSDictionary *)query handler:(void(^)(NSManagedObject *mo, NSError *err))handle;
+ (void)as_create:(NSDictionary *)query handler:(void(^)(NSManagedObject *mo, NSError *err))handle;
+ (void)as_upload:(void(^)(NSManagedObject *mo, NSError *err))handle;
+ (void)as_download:(void(^)(NSManagedObject *mo, NSError *err))handle;

@end
