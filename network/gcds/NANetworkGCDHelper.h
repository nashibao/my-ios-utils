//
//  NANetworkHelper.h
//  SK3
//
//  Created by nashibao on 2012/09/25.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NANetworkGCDHelper : NSObject

//for managing statusbar indicator
+ (void)networkStart;
+ (void)networkEnd;

+ (void)setDomain:(NSString *)domain;

+ (NSString *)getDomain;

+ (void)sendAsynchronousRequestByEndPoint:(NSString *)endpoint data:(NSDictionary *)data isPost:(BOOL)isPost encoding:(NSStringEncoding)encoding jsonOption:(NSJSONReadingOptions)jsonOption returnMain:(BOOL)returnMain successHandler:(void(^)(NSURLResponse *resp, id data))successHandler errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;

@end
