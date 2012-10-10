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
    [op setCompletionBlockWithSuccess:successHandler failure:errorHandler isJson:YES jsonOption:jsonOption];
    return op;
}

+ (NANetworkOperation *)sendAsynchronousRequest:(NSURLRequest *)request
                                 returnEncoding:(NSStringEncoding)returnEncoding
                                     returnMain:(BOOL)returnMain
                                 successHandler:(void(^)(NANetworkOperation *op, id data))successHandler
                                   errorHandler:(void(^)(NANetworkOperation *op, NSError *err))errorHandler{
    NANetworkOperation *op = [[[self class] alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successHandler failure:errorHandler isJson:NO jsonOption:0];
    return op;
}

- (void)setCompletionBlockWithSuccess:(void (^)(NANetworkOperation *operation, id responseObject))success
failure:(void (^)(NANetworkOperation *operation, NSError *error))failure isJson:(BOOL)isJson jsonOption:(NSJSONReadingOptions)jsonOption{
    __block __weak NANetworkOperation *wself = self;
    self.completionBlock = ^{
        if ([wself isCancelled]) {
            return;
        }
        
        if (self.error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(wself, wself.error);
                });
            }
        } else {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    id response = wself.responseData;
                    if(isJson){
                        NSError *jsonErr = nil;
                        response = [NSJSONSerialization JSONObjectWithData:response options:jsonOption error:&jsonErr];
                        if(jsonErr){
                            failure(wself, jsonErr);
                            return;
                        }
                    }
                    success(wself, response);
                });
            }
        }
    };
    
}

@end
