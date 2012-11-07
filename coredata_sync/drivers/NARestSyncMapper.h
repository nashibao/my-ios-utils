//
//  NARestSyncMapper.h
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "NARestMapper.h"

@interface NARestSyncMapper : NARestMapper

- (void)resolveConflictByOption:(NASyncModelConflictOption)conflictOption
                           data:(id)data
                             mo:(NSManagedObject *)mo
                       restType:(NARestType)restType
                      inContext:(NSManagedObjectContext *)context
                          query:(NARestQueryObject *)query;

@end
