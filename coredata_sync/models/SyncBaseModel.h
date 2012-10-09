//
//  SyncBaseModel.h
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SyncBaseModel : NSManagedObject

@property (nonatomic, retain) NSString * network_identifier;
@property (nonatomic, retain) NSString * network_cache_identifier;

@end
