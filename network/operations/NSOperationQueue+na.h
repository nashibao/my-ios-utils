//
//  NSOperationQueue+nashibao.h
//  SK3
//
//  Created by nashibao on 2012/09/24.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (na)


#pragma mark TODO: add a priority param.
/*
 global gackground queue like GCD.
 */
+ (id)globalBackgroundQueue;

@end
