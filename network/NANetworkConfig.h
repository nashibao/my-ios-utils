//
//  NANetworkConfig.h
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

/** http用プロトコルのenumバージョン
 */
typedef enum NANetworkProtocol: NSUInteger{
    NANetworkProtocolGET,
    NANetworkProtocolPOST,
    NANetworkProtocolPUT,
    NANetworkProtocolDELETE,
} NANetworkProtocol;


/**
 設定値
 */
@interface NANetworkConfig : NSObject

@end
