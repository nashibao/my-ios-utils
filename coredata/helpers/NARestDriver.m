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

- (NSString *)URLByType:(NARestType)type model:(NSString*)modelname endpoint:(NSString *)endpoint pk:(NSNumber *)_pk{
    int pk = -1;
    if(_pk)
        pk = [_pk intValue];
    switch (type) {
        case NARestTypeGET:
            return [NSString stringWithFormat:@"%@get/%@/%d/", endpoint, modelname, pk];
            break;
        case NARestTypeFILTER:
            return [NSString stringWithFormat:@"%@filter/%@/", endpoint, modelname];
            break;
        case NARestTypeCREATE:
            return [NSString stringWithFormat:@"%@create/%@/", endpoint, modelname];
            break;
        case NARestTypeUPDATE:
            return [NSString stringWithFormat:@"%@update/%@/%d/", endpoint, modelname, pk];
            break;
        case NARestTypeDELETE:
            return [NSString stringWithFormat:@"%@delete/%@/%d/", endpoint, modelname, pk];
            break;
            
        default:
            break;
    }
}

- (NANetworkProtocol)ProtocolByType:(NARestType)type model:(NSString*)modelname{
    switch (type) {
        case NARestTypeGET:
            return NANetworkProtocolGET;
            break;
        case NARestTypeFILTER:
            return NANetworkProtocolGET;
            break;
        case NARestTypeCREATE:
            return NANetworkProtocolPOST;
            break;
        case NARestTypeUPDATE:
            return NANetworkProtocolPOST;
            break;
        case NARestTypeDELETE:
            return NANetworkProtocolPOST;
            break;
            
        default:
            break;
    }
}

@end
