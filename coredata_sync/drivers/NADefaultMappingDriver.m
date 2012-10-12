//
//  NADefaultMappingDriver.m
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NADefaultMappingDriver.h"

#import "NADefaultRestDriver.h"

@implementation NADefaultMappingDriver

- (id)init{
    self = [super init];
    if(self){
        self.primaryKey = @"pk";
        self.uniqueKeys = [@{@"pk": @YES} mutableCopy];
        self.jsonKeys = [@{
            @"pk": @"pk",
        } mutableCopy];
        self.queryKeys = [@{
            @"pk": @"pk",
        } mutableCopy];
    }
    return self;
}

@end
