//
//  NSURLRequest+na.m
//  na_ios_test
//
//  Created by nashibao on 2012/11/05.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "NSURLRequest+na.h"

@implementation NSURLRequest (na)

+ (NSURLRequest *)request:(NSString *)baseURL query:(NSDictionary *)query protocol:(NANetworkProtocol)protocol encoding:(NSStringEncoding)encoding{
	NSString *urlstring = [baseURL stringByAddingPercentEscapesUsingEncoding:encoding];
    NSMutableString *requestString = [[NSMutableString alloc] init];
    NSString *method = @"GET";
    switch (protocol) {
        case NANetworkProtocolGET:
            method = @"GET";
            break;
        case NANetworkProtocolPOST:
            method = @"POST";
            break;
        case NANetworkProtocolPUT:
            method = @"PUT";
            break;
        case NANetworkProtocolDELETE:
            method = @"DELETE";
            break;
        default:
            break;
    }
    NSData *requestData = nil;
    if([query count] > 0){
        for(NSString *key in query){
            id val = query[key];
            if([val isKindOfClass:[NSString class]]){
                val = [val stringByAddingPercentEscapesUsingEncoding:encoding];
            }
            [requestString appendFormat:@"%@=%@&", key, val];
        }
        if (protocol==NANetworkProtocolGET){
            urlstring = [NSString stringWithFormat:@"%@?%@", urlstring, requestString];
        }else{
            requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlstring]];
    if(requestData)
        [req setHTTPBody:requestData];
    [req setHTTPMethod: method];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    NSLog(@"%s|%@|%@", __PRETTY_FUNCTION__, urlstring, query);
    return req;
}

@end
