//
//  NAOperation.h
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NANetworkConfig.h"

@interface NABaseNetworkOperation : NSOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) NSURLResponse *response;
@property (strong, nonatomic) NSData *responseData;
@property (strong, nonatomic) NSError *error;

- (id)initWithRequest:(NSURLRequest *)urlRequest;

- (void)pause;
- (BOOL)isPaused;
- (void)resume;

@end
