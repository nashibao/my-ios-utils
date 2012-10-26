//
//  NASyncModel.h
//  SK3
//
//  Created by nashibao on 2012/10/26.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NASyncModel : NSManagedObject

@property (nonatomic, retain) NSString * cache_identifier_;
@property (nonatomic) int32_t cache_index_;
@property (nonatomic, retain) id data;
@property (nonatomic, retain) id edited_data;
@property (nonatomic) int32_t pk;
@property (nonatomic, retain) NSDate * modified_date_;
@property (nonatomic) int32_t sync_error_;
@property (nonatomic) int32_t sync_state_;
@property (nonatomic) BOOL is_conflicted_;

@end
