//
//  NANetworkHelper.m
//  SK3
//
//  Created by nashibao on 2012/09/25.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NANetworkGCDHelper.h"

#import "NSOperationQueue+na.h"

@implementation NANetworkGCDHelper

NSInteger __networking__count__ = 0;

+ (void)networkStart{
    __networking__count__ += 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
}
+ (void)networkEnd{
    __networking__count__ -= 1;
    if(__networking__count__ == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    }
}

NSString *__domain__ = nil;

+ (void)setDomain:(NSString *)domain{
    __domain__ = domain;
}

+ (NSString *)getDomain{
    return __domain__;
}

+ (void)sendAsynchronousRequestByEndPoint:(NSString *)endpoint data:(NSDictionary *)data protocol:(NANetworkProtocol)protocol encoding:(NSStringEncoding)encoding returnEncoding:(NSStringEncoding)returnEncoding jsonOption:(NSJSONReadingOptions)jsonOption returnMain:(BOOL)returnMain successHandler:(void(^)(NSURLResponse *resp, id data))successHandler errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler{
    
    NSString *urlstring = [NSString stringWithFormat:@"%@%@", [self getDomain], endpoint];
	urlstring = [urlstring stringByAddingPercentEscapesUsingEncoding:encoding];
    NSMutableString *requestString = [[NSMutableString alloc] init];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlstring]];
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
    [req setHTTPMethod: method];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    if([data count] > 0){
        for(NSString *key in data){
            [requestString appendFormat:@"%@=%@&", key, data[key]];
        }
        NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        [req setHTTPBody:requestData];
    }
    [self networkStart];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue globalBackgroundQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {
        NSError *_err = nil;
        id _result = nil;
        if([data length] > 0 && err == nil){
            if(jsonOption){
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
        if(_err){
            if(errorHandler){
                if(returnMain){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        errorHandler(resp, _err);
                    });
                }else{
                    errorHandler(resp, _err);
                }
            }
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
        }
        [self networkEnd];
    }];
}

@end
