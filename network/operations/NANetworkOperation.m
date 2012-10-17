//
//  NANetworkOperation.m
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NANetworkOperation.h"

#import "NSOperationQueue+na.h"

#import "NANetworkActivityIndicatorManager.h"

#import "Reachability.h"

@implementation NANetworkOperation

static NSMutableArray *__all_operations__ = nil;
static NSMutableArray *__waiting_operations__ = nil;
static NSMutableArray *__waiting_queues__ = nil;
static NSMutableDictionary *_operations_with_id = nil;
static Reachability *__reach__ = nil;

#warning 本当は呼び出しもとのスレッドは決めておいた方がいいな．lockはかけたくないしmainはいやだから、globalBackgroundThreadがあるといいけど?gcdのglobal background queueを使うか．

+ (void)load{
    [super load];
    _operations_with_id = [[NSMutableDictionary alloc] init];
    __all_operations__ = [@[] mutableCopy];
    __waiting_operations__ = [@[] mutableCopy];
    __waiting_queues__ = [@[] mutableCopy];
    __reach__ = [Reachability reachabilityWithHostname:@"www.google.com"];
    __reach__.reachableBlock = ^(Reachability *reach){
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, @"Reachable!!");
//        waiting -> queue
        int opcnt = 0;
        for (NANetworkOperation *op in __waiting_operations__) {
            id queue =__waiting_queues__[opcnt];
            opcnt += 1;
            if([queue isKindOfClass:[NSOperationQueue class]]){
                [queue addOperation:op];
            }else{
                [op resume];
            }
        }
        [__waiting_operations__ removeAllObjects];
        [__waiting_queues__ removeAllObjects];
    };
    __reach__.unreachableBlock = ^(Reachability *reach){
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, @"Unreachable!!");
//        all -> waiting
        for (NANetworkOperation *op in __all_operations__) {
            [op pause];
            if([__waiting_operations__ indexOfObject:op]==NSNotFound){
                [__waiting_operations__ addObject:op];
                [__waiting_queues__ addObject:[NSNull null]];
            }
        }
    };
    [__reach__ startNotifier];
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
    
    [[NANetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    op = [[[self class] alloc] initWithRequest:request];
    [__all_operations__ addObject:op];
    [op setCompletionBlockWithSuccess:successHandler failure:errorHandler isJson:isJson jsonOption:jsonOption returnMain:returnMain returnEncoding:returnEncoding];
    NSOperationQueue *_queue = queue ?: [NSOperationQueue globalBackgroundQueue];
    [op setIdentifier:identifier];
    operations = _operations_with_id[identifier] ?: [@[] mutableCopy];
    [operations addObject:op];
    _operations_with_id[identifier] = operations;
    [op checkIdentifierStart];
    
    if([__reach__ isReachable]){
        [_queue addOperation:op];
    }else{
        [__waiting_operations__ addObject:op];
        [__waiting_queues__ addObject:_queue];
    }
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
        [__all_operations__ removeObject:wself];
        NSMutableArray *operations = _operations_with_id[wself.identifier];
        [operations removeObject:wself];
        NSUInteger temp_index = [__waiting_operations__ indexOfObject:wself];
        if(temp_index != NSNotFound){
            [__waiting_operations__ removeObjectAtIndex:temp_index];
            [__waiting_queues__ removeObjectAtIndex:temp_index];
        }
        [wself checkIdentifierFinish];
        if ([wself isCancelled]) {
            if(wself.cancel_block)
                wself.cancel_block();
            if(wself.finish_block)
                wself.finish_block();
            [[NANetworkActivityIndicatorManager sharedManager] decrementActivityCount];
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
            [[NANetworkActivityIndicatorManager sharedManager] decrementActivityCountWithError:[NSString stringWithFormat:@"%@", _err]];
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
            [[NANetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }
        if(wself.finish_block)
            wself.finish_block();
    };
    
}

- (void)checkIdentifierStart{
    if(self.identifier){
        NSMutableArray *operations = _operations_with_id[self.identifier];
        if([operations count] == 1){
            [[NSNotificationCenter defaultCenter] postNotificationName:NANetworkOperationIdentifierStart object:self.identifier];
        }
    }
}

- (void)checkIdentifierFinish{
    if(self.identifier){
        NSMutableArray *operations = _operations_with_id[self.identifier];
        if([operations count] == 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:NANetworkOperationIdentifierEnd object:self.identifier];
        }
    }
}

@end
