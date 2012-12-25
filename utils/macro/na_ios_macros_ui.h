//
//  ViewMacros.h
//  SK3
//
//  Created by nashibao on 2012/11/12.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COMMON_INITIAL_SETTINGS() \
- (id)initWithFrame:(CGRect)frame{ \
    self = [super initWithFrame:frame]; \
    if (self) [self commonInitialSettings]; \
    return self; \
} \
- (id)initWithCoder:(NSCoder *)aDecoder{ \
    self = [super initWithCoder:aDecoder]; \
    if(self)[self commonInitialSettings]; \
    return self; \
} \
- (id)init{ \
    self = [super init]; \
    if(self)[self commonInitialSettings]; \
    return self; \
} \
