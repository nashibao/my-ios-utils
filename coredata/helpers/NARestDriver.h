//
//  NARestDriver.h
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NANetworkGCDHelper.h"

typedef enum NARestType: NSUInteger{
    NARestTypeGET,
    NARestTypeFILTER,
    NARestTypeCREATE,
    NARestTypeUPDATE,
    NARestTypeDELETE,
} NARestType;


@interface NARestDriver : NSObject

@property (nonatomic) NSStringEncoding encoding;
@property (nonatomic) NSStringEncoding returnEncoding;

- (NSString *)URLByType:(NARestType)type model:(NSString*)modelname endpoint:(NSString *)endpoint pk:(NSNumber *)pk;
- (NANetworkProtocol)ProtocolByType:(NARestType)type model:(NSString*)modelname;

@end
