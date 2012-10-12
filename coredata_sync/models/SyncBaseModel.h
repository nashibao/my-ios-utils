//
//  SyncBaseModel.h
//  SK3
//
//  Created by nashibao on 2012/10/12.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SyncBaseModel : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) id data;
@property (nonatomic, retain) NSNumber * is_deleted;
@property (nonatomic, retain) NSNumber * is_edited;
@property (nonatomic, retain) NSString * network_cache_identifier;
@property (nonatomic, retain) NSString * network_identifier;
@property (nonatomic, retain) NSNumber * pk;
@property (nonatomic, retain) id raw_data;
@property (nonatomic, retain) NSNumber * sync_error;
@property (nonatomic, retain) NSNumber * sync_version;
@property (nonatomic, retain) NSDate * updated_at;

@end
