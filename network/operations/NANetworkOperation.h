//
//  NANetworkOperation.h
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NABaseNetworkOperation.h"

#pragma mark TODO: 一部のparameterはpropertyにして関数を洗練しときたい．ショートカット
#pragma mark TODO: operationを拡張できるようにしたい. factory pattern的な

typedef enum NANetworkOperationQueingOption: NSInteger {
    //キャンセルしてからaddOperation
    NANetworkOperationQueingOptionCancel = 2,
    //古いのがあったら返すだけ
    NANetworkOperationQueingOptionReturnOld = 1,
    //先に入っているやつの終了を待つ
    //これはqueueの種類によって制御できる
    NANetworkOperationQueingOptionJustAdd = 0,
    NANetworkOperationQueingOptionDefault = 0,
} NANetworkOperationQueingOption;

typedef void (^VOID_BLOCK)(void);
typedef void (^SUCCESS_BLOCK)(id op, id data);
typedef void (^FAIL_BLOCK)(id op, NSError *err);

@interface NANetworkOperation : NABaseNetworkOperation

@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) SUCCESS_BLOCK success_block;

@property (strong, nonatomic) FAIL_BLOCK fail_block;

@property (strong, nonatomic) VOID_BLOCK cancel_block;

@property (strong, nonatomic) VOID_BLOCK finish_block;

+ (NANetworkOperation *)sendJsonAsynchronousRequest:(NSURLRequest *)request
                                         jsonOption:(NSJSONReadingOptions)jsonOption
                                     returnEncoding:(NSStringEncoding)returnEncoding
                                         returnMain:(BOOL)returnMain
                                              queue:(NSOperationQueue *)queue
                                         identifier:(NSString *)identifier
                                 identifierMaxCount:(NSInteger)identifierMaxCount
                                 queueingOption:(NANetworkOperationQueingOption)queueingOption
                                     successHandler:(void(^)(NANetworkOperation *op, id data))successHandler
                                       errorHandler:(void(^)(NANetworkOperation *op, NSError *err))errorHandler;


+ (NANetworkOperation *)sendAsynchronousRequest:(NSURLRequest *)request
                                 returnEncoding:(NSStringEncoding)returnEncoding
                                     returnMain:(BOOL)returnMain
                                          queue:(NSOperationQueue *)queue
                                     identifier:(NSString *)identifier
                             identifierMaxCount:(NSInteger)identifierMaxCount
                                 queueingOption:(NANetworkOperationQueingOption)queueingOption
                                 successHandler:(void(^)(NANetworkOperation *op, id data))successHandler
                                   errorHandler:(void(^)(NANetworkOperation *op, NSError *err))errorHandler;

+ (NSArray *)getOperationsByIdentifier:(NSString *)identifier;
+ (NSArray *)cancelByIdentifier:(NSString *)identifier handler:(void (^)(void))handler;

@end
