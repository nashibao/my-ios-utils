//
//  NANetworkHelper.m
//  SK3
//
//  Created by nashibao on 2012/09/25.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NANetworkGCDHelper.h"

#import "NSOperationQueue+na.h"

#import "NANetworkActivityIndicatorManager.h"

typedef void (^ERROR_BLOCK)(NSURLResponse *resp, NSError *err);

@implementation NANetworkGCDHelper

static ERROR_BLOCK __global_error_block__;

NSInteger __networking__count__ = 0;

+ (void)_sendAsynchronousRequest:(NSURLRequest *)request returnEncoding:(NSStringEncoding)returnEncoding isJson:(BOOL)isJSON jsonOption:(NSJSONReadingOptions)jsonOption returnMain:(BOOL)returnMain successHandler:(void(^)(NSURLResponse *resp, id data))successHandler errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler{
    
    [[NANetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue globalBackgroundQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {
        NSError *_err = nil;
        id _result = nil;
        if([data length] > 0 && err == nil){
            if(isJSON){
                NSError *jsonErr;
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:jsonOption error:&jsonErr];
                if(jsonErr){
                    _err = jsonErr;
                }else{
                    _result = result;
                }
            }else{
                NSString *result = [[NSString alloc] initWithData:data encoding:returnEncoding];
                _result = result;
            }
        }else{
            _err = err;
        }
        if(_err || !_result){
            NSString *result = [[NSString alloc] initWithData:data encoding:returnEncoding];
            NSLog(@"%s|%@", __PRETTY_FUNCTION__, result);
            if(errorHandler){
                if(returnMain){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        errorHandler(resp, _err);
                    });
                }else{
                    errorHandler(resp, _err);
                }
            }
            if(__global_error_block__){
                dispatch_async(dispatch_get_main_queue(), ^{
                    __global_error_block__(resp, _err);
                });
            }
            [[NANetworkActivityIndicatorManager sharedManager] decrementActivityCountWithError:[NSString stringWithFormat:@"%@", _err] ?: @"no result"];
        }else{
            if(successHandler){
                if(returnMain){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        successHandler(resp, _result);
                    });
                }else{
                    successHandler(resp, _result);
                }
            }
            [[NANetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }
    }];
}

+ (NSURLRequest *)requestTo:(NSString *)baseURL query:(NSDictionary *)query protocol:(NANetworkProtocol)protocol encoding:(NSStringEncoding)encoding{
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

+ (void)sendJsonAsynchronousRequest:(NSURLRequest *)request jsonOption:(NSJSONReadingOptions)jsonOption returnEncoding:(NSStringEncoding)returnEncoding returnMain:(BOOL)returnMain successHandler:(void(^)(NSURLResponse *resp, id data))successHandler errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler{
    [self _sendAsynchronousRequest:request returnEncoding:returnEncoding isJson:YES jsonOption:jsonOption returnMain:returnMain successHandler:successHandler errorHandler:errorHandler];
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request returnEncoding:(NSStringEncoding)returnEncoding returnMain:(BOOL)returnMain successHandler:(void(^)(NSURLResponse *resp, id data))successHandler errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler{
    [self _sendAsynchronousRequest:request returnEncoding:returnEncoding isJson:NO jsonOption:NSJSONReadingAllowFragments returnMain:returnMain successHandler:successHandler errorHandler:errorHandler];
}

+ (void)setGlobalErrorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler{
    __global_error_block__ = errorHandler;
}

@end
