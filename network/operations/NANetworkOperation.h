//
//  NANetworkOperation.h
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NABaseNetworkOperation.h"

@interface NANetworkOperation : NABaseNetworkOperation

+ (NANetworkOperation *)sendJsonAsynchronousRequest:(NSURLRequest *)request
                                         jsonOption:(NSJSONReadingOptions)jsonOption
                                 returnEncoding:(NSStringEncoding)returnEncoding
                                     returnMain:(BOOL)returnMain
                                 successHandler:(void(^)(NANetworkOperation *op, id data))successHandler
                                   errorHandler:(void(^)(NANetworkOperation *op, NSError *err))errorHandler;

+ (NANetworkOperation *)sendAsynchronousRequest:(NSURLRequest *)request
                                 returnEncoding:(NSStringEncoding)returnEncoding
                                     returnMain:(BOOL)returnMain
                                 successHandler:(void(^)(NANetworkOperation *op, id data))successHandler
                                   errorHandler:(void(^)(NANetworkOperation *op, NSError *err))errorHandler;

@end
