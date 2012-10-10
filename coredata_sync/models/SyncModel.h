//
//  SyncModel.h
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncBaseModel+sync.h"


@interface SyncModel : SyncBaseModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) id data;
@property (nonatomic, retain) NSNumber * is_active;
@property (nonatomic, retain) NSNumber * is_edited;
@property (nonatomic, retain) NSNumber * pk;
@property (nonatomic, retain) NSDate * sync_date;
@property (nonatomic, retain) NSNumber * sync_version;
@property (nonatomic, retain) NSDate * updated_at;

@end
