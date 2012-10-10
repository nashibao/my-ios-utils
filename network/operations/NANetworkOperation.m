//
//  NANetworkOperation.m
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NANetworkOperation.h"

@implementation NANetworkOperation

+ (NANetworkOperation *)sendJsonAsynchronousRequest:(NSURLRequest *)request
                                         jsonOption:(NSJSONReadingOptions)jsonOption
                                 returnEncoding:(NSStringEncoding)returnEncoding
                                     returnMain:(BOOL)returnMain
                                 successHandler:(void(^)(NANetworkOperation *op, id data))successHandler
                                   errorHandler:(void(^)(NANetworkOperation *op, NSError *err))errorHandler{
    NANetworkOperation *op = [[[self class] alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successHandler failure:errorHandler isJson:YES jsonOption:jsonOption returnMain:returnMain];
    return op;
}

+ (NANetworkOperation *)sendAsynchronousRequest:(NSURLRequest *)request
                                 returnEncoding:(NSStringEncoding)returnEncoding
                                     returnMain:(BOOL)returnMain
                                 successHandler:(void(^)(NANetworkOperation *op, id data))successHandler
                                   errorHandler:(void(^)(NANetworkOperation *op, NSError *err))errorHandler{
    NANetworkOperation *op = [[[self class] alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successHandler failure:errorHandler isJson:NO jsonOption:0 returnMain:returnMain];
    return op;
}

- (void)setCompletionBlockWithSuccess:(void (^)(NANetworkOperation *operation, id responseObject))success
failure:(void (^)(NANetworkOperation *operation, NSError *error))failure isJson:(BOOL)isJson jsonOption:(NSJSONReadingOptions)jsonOption returnMain:(BOOL)returnMain{
    __block __weak NANetworkOperation *wself = self;
    self.completionBlock = ^{
        if ([wself isCancelled]) {
            return;
        }
        NSError *_err = nil;
        id response = nil;
        if (self.error) {
            if (failure) {
                _err = wself.error;
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(wself, wself.error);
                });
            }
        } else {
            if (success) {
                response = wself.responseData;
                if(isJson){
                    NSError *jsonErr = nil;
                    response = [NSJSONSerialization JSONObjectWithData:response options:jsonOption error:&jsonErr];
                    if(jsonErr){
                        _err = jsonErr;
                    }
                }
            }
        }
        if(_err){
            if(returnMain){
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(wself, wself.error);
                });
            }else{
                failure(wself, wself.error);
            }
        }else{
            if(returnMain){
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(wself, response);
                });
            }else{
                success(wself, response);
            }
        }
    };
    
}

@end
