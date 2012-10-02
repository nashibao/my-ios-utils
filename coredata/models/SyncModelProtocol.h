//
//  SyncModelProtocol.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 実際の実装はNASyncModelAdopterに投げる
 */
@protocol SyncModelProtocol <NSObject>

/*
 クラスメソッド系REST API
 callbackを設定
 warning!!: mainthreadでは返さない！！
 <実装済み>
 as_filter: queryに当てはまるもの全て取ってくる
 <実装未定>
 as_sync: sync_versionの最新のだけ取ってくるラッパ
 as_upload: edited=YESのものをまとめてupload
 */
+ (void)as_filter:(NSDictionary *)query handler:(void(^)(NSArray *mos, NSError *err))handler;
+ (void)as_get:(NSDictionary *)query handler:(void(^)(NSManagedObject *mo, NSError *err))handler;
+ (void)as_create:(NSDictionary *)query handler:(void(^)(NSManagedObject *mo, NSError *err))handler;
//+ (void)as_sync:(void(^)(SyncModel *mo, NSError *err))handle;
//+ (void)as_upload;

/*
 インスタンスメソッド系REST API
 */
- (void)as_upload:(void(^)(NSManagedObject *mo, NSError *err))handler;
- (void)as_download:(void(^)(NSManagedObject *mo, NSError *err))handler;

@end
