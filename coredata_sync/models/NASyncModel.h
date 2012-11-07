//
//  NASyncModel.h
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NASyncModel : NSManagedObject

@property (nonatomic, retain) NSString * cache_identifier_;
@property (nonatomic, retain) NSNumber * cache_index_;
@property (nonatomic, retain) id data_;
@property (nonatomic, retain) id edited_data_;
@property (nonatomic, retain) NSNumber * is_syncing_;
@property (nonatomic, retain) NSDate * modified_date_;
@property (nonatomic, retain) NSNumber * pk_;
@property (nonatomic, retain) NSNumber * sync_error_;
@property (nonatomic, retain) NSNumber * sync_state_;

@end
