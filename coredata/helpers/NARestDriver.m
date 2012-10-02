//
//  NARestDriver.m
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NARestDriver.h"

@implementation NARestDriver

- (id)init{
    self = [super init];
    if(self){
        self.encoding = NSUTF8StringEncoding;
        self.returnEncoding = NSUTF8StringEncoding;
    }
    return self;
}


- (NSString *)getURLByModel:(NSString*)modelname endpoint:(NSString *)endpoint pk:(NSInteger)pk{
    return [NSString stringWithFormat:@"%@get/%@/%d/", endpoint, modelname, pk];
}

- (NANetworkProtocol)getProtocolByModel:(NSString*)modelname{
    return NANetworkProtocolGET;
}

- (NSString *)filterURLByModel:(NSString*)modelname endpoint:(NSString *)endpoint{
    return [NSString stringWithFormat:@"%@filter/%@/", endpoint, modelname];
}

- (NANetworkProtocol)filterProtocolByModel:(NSString*)modelname{
    return NANetworkProtocolGET;
}

- (NSString *)createURLByModel:(NSString*)modelname endpoint:(NSString *)endpoint{
    return [NSString stringWithFormat:@"%@create/%@/", endpoint, modelname];
}

- (NANetworkProtocol)createProtocolByModel:(NSString*)modelname{
    return NANetworkProtocolPOST;
}

- (NSString *)updateURLByModel:(NSString*)modelname endpoint:(NSString *)endpoint pk:(NSInteger)pk{
    return [NSString stringWithFormat:@"%@update/%@/%d/", endpoint, modelname, pk];
}

- (NANetworkProtocol)updateProtocolByModel:(NSString*)modelname{
    return NANetworkProtocolPOST;
}


- (NSString *)deleteURLByModel:(NSString*)modelname endpoint:(NSString *)endpoint pk:(NSInteger)pk{
    return [NSString stringWithFormat:@"%@delete/%@/%d/", endpoint, modelname, pk];
}

- (NANetworkProtocol)deleteProtocolByModel:(NSString*)modelname{
    return NANetworkProtocolPOST;
}

@end
