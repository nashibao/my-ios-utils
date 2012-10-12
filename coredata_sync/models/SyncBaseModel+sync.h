//
//  SyncBaseModel+sync.h
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "SyncBaseModel.h"

#import "NAMappingDriver.h"

#import "NSManagedObject+na.h"

@interface SyncBaseModel (sync)


#pragma mark ベースモデルの説明

/*
 同期時にidをつけたい場合はこちらを使う.
 cache_identifierはtransientになっていて揮発性
 */
//@property (nonatomic, retain) NSString * network_cache_identifier;
//@property (nonatomic, retain) NSString * network_identifier;



/*
 primary key
 */
//@property (nonatomic, retain) NSNumber * pk;



/*
 sync_versionはserver側のバージョンを保持する．
 sync_versionが上がっていない場合は同期をしない．
 useSyncVersionによって利用するかどうかを制御可能
 */
//@property (nonatomic, retain) NSNumber * sync_version;



/*
 ローカルで削除する場合はこちらを使う．
 同期するまでmoは削除しない．
 */
//@property (nonatomic, retain) NSNumber * is_deleted;



/*
 同期作業以外で編集があった場合にはこちらがtrueになる
 is_editedがtrueの場合はサーバ側のsync_versionが上がったとしても
 マージエラーを吐く
 is_manual_edit_managementによって自動化可能．
 もし、フィールドによって編集のありなしを振り分けたい場合は、
 exclude_edit_management_keysを上書きすること．
 */
//@property (nonatomic, retain) NSNumber * is_edited;



/*
 dictionary形式でサーバからの生データを格納
 */
//@property (nonatomic, retain) id raw_data;



/*
 dictionary形式でサーバからの生データを格納
 raw_dataとは異なり、ローカルでの編集データを入れておく．
 表示にはraw_dataを使うかdataを使うかはアプリケーション側で選択する
 こと．
 */
//@property (nonatomic, retain) id data;



/*
 マージエラーなどを格納
 */
//@property (nonatomic, retain) NSNumber * sync_error;


#pragma mark REST/Mappingの設定

/*
 additional schemes
 */
+ (NAMappingDriver *)driver;
+ (NSString *)primaryKeyField;
- (NSNumber *)primaryKey;

/*
 mapping
 */
+ (NSDictionary *)mo2query:(NSManagedObject *)mo;
+ (NSDictionary *)json2dictionary:(NSDictionary *)json;
+ (NSDictionary *)json2uniqueDictionary:(NSDictionary *)json;



#pragma mark 同期用のショートカット


/*
 completeはmainthreadでsave後にmainthreadで帰ってくる
 
 options:
  identifier(on memory in an operation.): キャンセル用途
  network_identifier(mo): frcの名前などを入れておく
  network_cache_identifier(mo): 検索語などを入れておく
 */
+ (void)sync_filter:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete;
+ (void)sync_get:(NSNumber *)pk options:(NSDictionary *)options complete:(void(^)())complete;
- (void)sync_get:(NSDictionary *)options complete:(void(^)())complete;
+ (void)sync_create:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete;
- (void)sync_create:(NSDictionary *)options complete:(void(^)())complete;
+ (void)sync_update:(NSNumber *)pk query:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete;
- (void)sync_update:(NSDictionary *)query options:(NSDictionary *)options complete:(void(^)())complete;


#pragma mark 同期用設定

/*
 upload中かどうか
 */
@property(nonatomic)BOOL is_uploading;

/*
 変更検知から外すkey
 */
+ (NSArray *)exclude_edit_management_keys;

/*
 変更検知のマニュアル化
 default: YES
 */
+ (BOOL)is_manual_edit_management;

@end
