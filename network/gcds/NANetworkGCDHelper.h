//
//  NANetworkHelper.h
//  SK3
//
//  Created by nashibao on 2012/09/25.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum NANetworkProtocol: NSUInteger{
    NANetworkProtocolGET,
    NANetworkProtocolPOST,
    NANetworkProtocolPUT,
    NANetworkProtocolDELETE,
} NANetworkProtocol;


@interface NANetworkGCDHelper : NSObject

/*
 for managing statusbar indicator
 */
+ (void)networkStart;
+ (void)networkEnd;

+ (NSURLRequest *)requestTo:(NSString *)baseURL
                      query:(NSDictionary *)query
                   protocol:(NANetworkProtocol)protocol
                   encoding:(NSStringEncoding)encoding;

/*
 main function of this class.
 
 <args>
 endpoint: url should be domains + endpoint
 data: request data
 isPost: boolean for post/get
 encoding: escape encoding
 jsonOption: if this param is not nil, callback param(id data) will be a json data.
 returnMain: it this param is YES, callback func is enclosed by main queue dispatch
 successHandler/errorHandler: blocks for callback
 
 */

+ (void)sendJsonAsynchronousRequest:(NSURLRequest *)request
                         jsonOption:(NSJSONReadingOptions)jsonOption
                     returnEncoding:(NSStringEncoding)returnEncoding
                         returnMain:(BOOL)returnMain
                     successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                       errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;

+ (void)sendAsynchronousRequest:(NSURLRequest *)request
                 returnEncoding:(NSStringEncoding)returnEncoding
                     returnMain:(BOOL)returnMain
                 successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                   errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;

@end
