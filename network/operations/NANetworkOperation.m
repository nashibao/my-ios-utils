//
//  NANetworkOperation.m
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NANetworkOperation.h"

#import "NSOperationQueue+na.h"

@implementation NANetworkOperation

static NSMutableDictionary *_operations_with_id = nil;

+ (void)load{
    [super load];
    _operations_with_id = [[NSMutableDictionary alloc] init];
}

+ (NANetworkOperation *)sendJsonAsynchronousRequest:(NSURLRequest *)request
                                         jsonOption:(NSJSONReadingOptions)jsonOption
                                     returnEncoding:(NSStringEncoding)returnEncoding
                                         returnMain:(BOOL)returnMain
                                              queue:(NSOperationQueue *)queue
                                         identifier:(NSString *)identifier
                                 identifierMaxCount:(NSInteger)identifierMaxCount
                                     queueingOption:(NANetworkOperationQueingOption)queueingOption
                                     successHandler:(void(^)(NANetworkOperation *op, id data))successHandler
                                       errorHandler:(void(^)(NANetworkOperation *op, NSError *err))errorHandler{
    return [self _sendAsynchronousRequest:request isJson:YES jsonOption:jsonOption returnEncoding:returnEncoding returnMain:returnMain queue:queue identifier:identifier identifierMaxCount:identifierMaxCount queueingOption:queueingOption successHandler:successHandler errorHandler:errorHandler];
}

+ (NANetworkOperation *)sendAsynchronousRequest:(NSURLRequest *)request
                                 returnEncoding:(NSStringEncoding)returnEncoding
                                     returnMain:(BOOL)returnMain
                                          queue:(NSOperationQueue *)queue
                                     identifier:(NSString *)identifier
                             identifierMaxCount:(NSInteger)identifierMaxCount
                                 queueingOption:(NANetworkOperationQueingOption)queueingOption
                                 successHandler:(void(^)(NANetworkOperation *op, id data))successHandler
                                   errorHandler:(void(^)(NANetworkOperation *op, NSError *err))errorHandler{
    return [self _sendAsynchronousRequest:request isJson:NO jsonOption:0 returnEncoding:returnEncoding returnMain:returnMain queue:queue identifier:identifier identifierMaxCount:identifierMaxCount queueingOption:queueingOption successHandler:successHandler errorHandler:errorHandler];
}

+ (NANetworkOperation *)_sendAsynchronousRequest:(NSURLRequest *)request
                                          isJson:(BOOL)isJson
                                         jsonOption:(NSJSONReadingOptions)jsonOption
                                     returnEncoding:(NSStringEncoding)returnEncoding
                                         returnMain:(BOOL)returnMain
                                              queue:(NSOperationQueue *)queue
                                      identifier:(NSString *)identifier
                              identifierMaxCount:(NSInteger)identifierMaxCount
                                  queueingOption:(NANetworkOperationQueingOption)queueingOption
                                     successHandler:(void(^)(NANetworkOperation *op, id data))successHandler
                                       errorHandler:(void(^)(NANetworkOperation *op, NSError *err))errorHandler{
    if(!identifierMaxCount)
        identifierMaxCount = 1;
    NANetworkOperation *op = nil;
    NSMutableArray *operations = _operations_with_id[identifier];
    if([operations count] > 0){
        if(queueingOption == NANetworkOperationQueingOptionReturnOld){
            op = [operations lastObject];
            return op;
        }else if(queueingOption == NANetworkOperationQueingOptionCancel){
            if([operations count] >= identifierMaxCount)
                [self cancelByIdentifier:identifier handler:nil];
        }
    }
    
    op = [[[self class] alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successHandler failure:errorHandler isJson:isJson jsonOption:jsonOption returnMain:returnMain returnEncoding:returnEncoding];
    NSOperationQueue *_queue = queue ?: [NSOperationQueue globalBackgroundQueue];
    [_queue addOperation:op];
    [op setIdentifier:identifier];
    operations = _operations_with_id[identifier] ?: [@[] mutableCopy];
    [operations addObject:op];
    _operations_with_id[identifier] = operations;
    
    return op;
}

+ (NSArray *)getOperationsByIdentifier:(NSString *)identifier{
    return _operations_with_id[identifier];
}

+ (NSArray *)cancelByIdentifier:(NSString *)identifier handler:(void (^)(void))handler{
    NSArray *operations = [self getOperationsByIdentifier:identifier];
    if(operations){
        __block NSInteger cnt = 0;
        NSInteger maxcnt = [operations count];
        for (NANetworkOperation *op in operations) {
            op.finish_block = ^{
                cnt += 1;
                if(maxcnt == cnt){
                    NSLog(@"%s|%@", __PRETTY_FUNCTION__, @"cancelled!!");
                    if(handler)
                        handler();
                }
            };
            [op cancel];
        }
    }
    return operations;
}

- (void)setCompletionBlockWithSuccess:(void (^)(id operation, id responseObject))success
failure:(void (^)(id operation, NSError *error))failure isJson:(BOOL)isJson jsonOption:(NSJSONReadingOptions)jsonOption returnMain:(BOOL)returnMain returnEncoding:(NSStringEncoding)returnEncoding{
    __block __weak NANetworkOperation *wself = self;
    self.success_block = success;
    self.fail_block = failure;
    self.completionBlock = ^{
        NSMutableArray *operations = _operations_with_id[wself.identifier];
        [operations removeObject:wself];
        if ([wself isCancelled]) {
            if(wself.cancel_block)
                wself.cancel_block();
            if(wself.finish_block)
                wself.finish_block();
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
                }else{
                    response = [[NSString alloc] initWithData:response encoding:returnEncoding];
                }
            }
        }
        if(_err){
            if(wself.fail_block){
                if(returnMain){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        wself.fail_block(wself, wself.error);
                    });
                }else{
                    wself.fail_block(wself, wself.error);
                }
            }
        }else{
            if(wself.success_block){
                if(returnMain){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        wself.success_block(wself, response);
                    });
                }else{
                    wself.success_block(wself, response);
                }
            }
        }
        if(wself.finish_block)
            wself.finish_block();
    };
    
}

@end
