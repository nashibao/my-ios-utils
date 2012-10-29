//
//  NANetworkHelper.h
//  SK3
//
//  Created by nashibao on 2012/09/25.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NANetworkConfig.h"

/** network class for gcd
 */
@interface NANetworkGCDHelper : NSObject

/** for managing statusbar indicator
 
 @param baseURL base url
 @param query query
 @param protocol protocol
 @param encoding encoding
 */

+ (NSURLRequest *)requestTo:(NSString *)baseURL
                      query:(NSDictionary *)query
                   protocol:(NANetworkProtocol)protocol
                   encoding:(NSStringEncoding)encoding;

/** main function of this class.
 
 @param request request
 @param jsonOption jsonOption
 @param returnEncoding jsonEncoding
 @param returnMain returnMain
 @param successHandler successHandler
 @param errorHandler errorHandler
 */
+ (void)sendJsonAsynchronousRequest:(NSURLRequest *)request
                         jsonOption:(NSJSONReadingOptions)jsonOption
                     returnEncoding:(NSStringEncoding)returnEncoding
                         returnMain:(BOOL)returnMain
                     successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                       errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;

/** json function of this class.
 
 @param request request
 @param returnEncoding jsonEncoding
 @param returnMain returnMain
 @param successHandler successHandler
 @param errorHandler errorHandler
 */
+ (void)sendAsynchronousRequest:(NSURLRequest *)request
                 returnEncoding:(NSStringEncoding)returnEncoding
                     returnMain:(BOOL)returnMain
                 successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                   errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;

/** global error handler
 
 @param errorHandler errorHandler
 */
+ (void)setGlobalErrorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;

@end
