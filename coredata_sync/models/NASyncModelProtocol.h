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
 エラー時の戦略
 */
typedef enum NASyncModelErrorOption: NSUInteger{
    NASyncModelErrorOptionLeave,
    NASyncModelErrorOptionResign,
    NASyncModelErrorOptionRetry,
    NASyncModelErrorOptionUserAlert,
} NASyncModelErrorOption;

/*
 同期エラーの種類
 */
typedef enum NASyncModelSyncError: NSUInteger{
    NASyncModelSyncErrorNone = 0,
    NASyncModelSyncErrorConflict = 1,
    NASyncModelSyncErrorMerge = 2,
    NASyncModelSyncErrorOther = 3,
} NASyncModelSyncError;

/*
 
 プロトコルベースに書き換え中．
 説明もこちらに書く．
 
 */

@protocol NASyncModelProtocol <NSObject>

@end
