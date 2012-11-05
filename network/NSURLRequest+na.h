//
//  NSURLRequest+na.h
//  na_ios_test
//
//  Created by nashibao on 2012/11/05.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NANetworkConfig.h"

/** NSURLRequest用ユーティリティ
 とりあえず作成用関数のみ
 */
@interface NSURLRequest (na)

/** for managing statusbar indicator
 
 @param baseURL base url
 @param query query
 @param protocol protocol
 @param encoding encoding
 */
+ (NSURLRequest *)request:(NSString *)baseURL
                      query:(NSDictionary *)query
                   protocol:(NANetworkProtocol)protocol
                   encoding:(NSStringEncoding)encoding;
@end
