//
//  Event+na.m
//  na_ios_test
//
//  Created by nashibao on 2012/11/06.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "Event+na.h"

#import "EventModelController.h"

@implementation Event (na)

+ (NSManagedObjectContext *)mainContext{
    return [[EventModelController sharedController] mainContext];
}

@end
