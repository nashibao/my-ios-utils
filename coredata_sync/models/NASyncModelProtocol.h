//
//  SyncBaseModelProtocol.h
//  SK3
//
//  Created by nashibao on 2012/10/22.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum NASyncModelGUIDType : NSInteger{
    NASyncModelGUIDTypeNotInServer = -1,
} NASyncModelGUIDType;

/*
 同期状態
 */
typedef enum NASyncModelSyncState : NSInteger{
    NASyncModelSyncStateSYNCED = 0,
    NASyncModelSyncStateEDITED = 1,
    NASyncModelSyncStateDELETED = 2,
} NASyncModelSyncState;

/*
 コンフリクト時の戦略
 */
typedef enum NASyncModelConflictOption: NSUInteger{
    NASyncModelConflictOptionServerPriority,
    NASyncModelConflictOptionLocalPriority,
    NASyncModelConflictOptionUserAlert,
    NASyncModelConflictOptionAutoMerge,
} NASyncModelConflictOption;

/*
 同期エラーの種類
 */
typedef enum NASyncModelSyncError: NSUInteger{
    NASyncModelSyncErrorCONFLICT,
} NASyncModelSyncError;

/*
 
 プロトコルベースに書き換え中．
 説明もこちらに書く．
 
 */

@protocol NASyncModelProtocol <NSObject>

/*
 dictionary. 生データ
 */
@property (nonatomic, retain) id data;

/*
 dictionary. 編集データ
 */
@property (nonatomic, retain) id edited_data;

/*
 global unique id => primary key
 */
@property (nonatomic) int32_t guid;

/*
 編集日時
 */
@property (nonatomic, retain) NSDate * modified_date;

/*
 同期状態
 */
@property (nonatomic) int32_t sync_state;

/*
 同期エラー
 */
@property (nonatomic) int32_t sync_error;

/*
 transientな変数
 */

/*
 upload中
 */
@property (nonatomic) BOOL is_updating;

/*
 option
 同期には関係無し
 */
@optional
/*
 ネットワークでかえってくるarrayの順番などを保持．
 */
@property (nonatomic, retain) NSString * cache_identifier;
@property (nonatomic) int32_t cache_index;

@end
