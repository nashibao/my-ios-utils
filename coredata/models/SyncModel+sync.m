//
//  SyncModel+sync.m
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "SyncModel+sync.h"

@implementation SyncModel (sync)

@dynamic is_uploading;

/*
 変更検知から外すkey
 */
+ (NSArray *)exclude_edit_management_keys{
    static NSArray *__exclude_keys__ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __exclude_keys__ = @[
        @"created_at",
        @"data",
        @"pk",
        @"sync_date",
        @"sync_version",
        @"updated_at",
        @"is_edited"
        ];
    });
    return __exclude_keys__;
}

/*
 変更検知のマニュアル化
 default: YES
 */
+ (BOOL)is_manual_edit_management{
    return YES;
}

/*
 変更の検知はここで行う．
 */
- (void)didChangeValueForKey:(NSString *)key{
    if(![[self class] is_manual_edit_management]){
        BOOL bl = YES;
        for(NSString *ex_key in [[self class] exclude_edit_management_keys]){
            if([key isEqualToString:ex_key]){
                bl = NO;
                break;
            }
        }
        if(bl){
            self.is_edited = @YES;
        }
    }
    [super didChangeValueForKey:key];
}

@end
