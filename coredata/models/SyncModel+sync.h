//
//  SyncModel+sync.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "SyncModel.h"

@interface SyncModel (sync)

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
