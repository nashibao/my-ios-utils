//
//  NARestDriver.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NANetworkGCDHelper.h"

@interface NARestDriver : NSObject

@property (nonatomic) NSStringEncoding encoding;
@property (nonatomic) NSStringEncoding returnEncoding;

- (NSString *)getURLByModel:(NSString*)modelname endpoint:(NSString *)endpoint pk:(NSInteger)pk;
- (NANetworkProtocol)getProtocolByModel:(NSString*)modelname;

- (NSString *)filterURLByModel:(NSString*)modelname endpoint:(NSString *)endpoint;
- (NANetworkProtocol)filterProtocolByModel:(NSString*)modelname;

- (NSString *)createURLByModel:(NSString*)modelname endpoint:(NSString *)endpoint;
- (NANetworkProtocol)createProtocolByModel:(NSString*)modelname;

- (NSString *)updateURLByModel:(NSString*)modelname endpoint:(NSString *)endpoint pk:(NSInteger)pk;
- (NANetworkProtocol)updateProtocolByModel:(NSString*)modelname;

- (NSString *)deleteURLByModel:(NSString*)modelname endpoint:(NSString *)endpoint pk:(NSInteger)pk;
- (NANetworkProtocol)deleteProtocolByModel:(NSString*)modelname;

@end
