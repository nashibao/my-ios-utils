//
//  NANetworkConfig.h
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum NANetworkProtocol: NSUInteger{
    NANetworkProtocolGET,
    NANetworkProtocolPOST,
    NANetworkProtocolPUT,
    NANetworkProtocolDELETE,
} NANetworkProtocol;


@interface NANetworkConfig : NSObject

@end
