//
//  NANetworkHelper.h
//  SK3
//
//  Created by nashibao on 2012/09/25.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NANetworkGCDHelper : NSObject

/*
 for managing statusbar indicator
 */
+ (void)networkStart;
+ (void)networkEnd;

#pragma mark TODO: use custom domains
/*
 domains
 */
+ (void)setDomain:(NSString *)domain;
+ (NSString *)getDomain;


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
+ (void)sendAsynchronousRequestByEndPoint:(NSString *)endpoint data:(NSDictionary *)data isPost:(BOOL)isPost encoding:(NSStringEncoding)encoding returnEncoding:(NSStringEncoding)returnEncoding jsonOption:(NSJSONReadingOptions)jsonOption returnMain:(BOOL)returnMain successHandler:(void(^)(NSURLResponse *resp, id data))successHandler errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;

@end
