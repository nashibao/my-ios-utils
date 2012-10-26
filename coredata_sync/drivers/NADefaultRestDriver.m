//
//  NADefaultRestDriver.m
//  SK3
//
//  Created by nashibao on 2012/10/09.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NADefaultRestDriver.h"

@implementation NADefaultRestDriver

+ (NSString *)domain{
	@throw [NSException exceptionWithName:@"MUST_BE_OVERRIDED"
								   reason:@"driver: MUST_BE_OVERRIDED"
								 userInfo:nil];
}

- (id)init{
    self = [super init];
    if(self){
        self.encoding = NSUTF8StringEncoding;
        self.returnEncoding = NSUTF8StringEncoding;
    }
    return self;
}

- (NSString *)URLByType:(NARestType)type model:(NSString*)modelname endpoint:(NSString *)endpoint pk:(NSInteger)pk option:(NSDictionary *)option{
    switch (type) {
        case NARestTypeGET:
            return [NSString stringWithFormat:@"%@%@get/%@/%d/", [[self class] domain], endpoint, modelname, pk];
            break;
        case NARestTypeFILTER:
            return [NSString stringWithFormat:@"%@%@filter/%@/", [[self class] domain], endpoint, modelname];
            break;
        case NARestTypeCREATE:
            return [NSString stringWithFormat:@"%@%@create/%@/", [[self class] domain], endpoint, modelname];
            break;
        case NARestTypeUPDATE:
            return [NSString stringWithFormat:@"%@%@update/%@/%d/", [[self class] domain], endpoint, modelname, pk];
            break;
        case NARestTypeDELETE:
            return [NSString stringWithFormat:@"%@%@delete/%@/%d/", [[self class] domain], endpoint, modelname, pk];
            break;
        case NARestTypeRPC:
            return [NSString stringWithFormat:@"%@%@rpc/%@/%@/", [[self class] domain], endpoint, modelname, option[@"rpc_name"]];
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
        case NARestTypeRPC:
            return NANetworkProtocolGET;
            break;
            
        default:
            break;
    }
}

@end
