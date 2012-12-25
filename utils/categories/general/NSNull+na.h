//
//  NSNull+na.h
//  SK3
//
//  Created by nashibao on 2012/12/07.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>


#define isnull(val) !val || (id)val == [NSNull null]
#define isnotnull(val) YES && val && (id)val != [NSNull null]

@interface NSNull (na)

@end
