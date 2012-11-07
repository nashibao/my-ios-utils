//
//  NSManagedObject+setmapper.m
//  naiostest
//
//  Created by nashibao on 2012/11/07.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "NSManagedObject+serverobject.h"

@implementation NSManagedObject (serverobject)

+ (NSInteger)primaryKeyInServerItemData:(id)itemData{
    return [itemData[@"id"] integerValue];
}

+ (NSDate *)modifiedDateInServerItemData:(id)itemData{
    return itemData[@"modified_data"];
}

@end
