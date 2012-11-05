//
//  NANetworkHelper.h
//  SK3
//
//  Created by nashibao on 2012/09/25.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NANetworkConfig.h"

/** GCDを利用したNetwork用ヘルパー
 */
@interface NANetworkGCDHelper : NSObject


/** 非同期リクエスト without json
 
 @param request リクエスト
 @param returnEncoding 返り値のエンコーディング．
 @param returnMain メインスレッドで返ってくるかどうか
 @param successHandler 成功時コールバック
 @param errorHandler 失敗時コールバック
 */
+ (void)sendAsynchronousRequest:(NSURLRequest *)request
                 returnEncoding:(NSStringEncoding)returnEncoding
                     returnMain:(BOOL)returnMain
                 successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                   errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;

/** json request wrapper
 
 @param request リクエスト
 @param jsonOption jsonのoption NSJSONReadingOptions
 @param returnEncoding 返り値のエンコーディング．
 @param returnMain メインスレッドで返ってくるかどうか
 @param successHandler 成功時コールバック
 @param errorHandler 失敗時コールバック
 */
+ (void)sendJsonAsynchronousRequest:(NSURLRequest *)request
                         jsonOption:(NSJSONReadingOptions)jsonOption
                     returnEncoding:(NSStringEncoding)returnEncoding
                         returnMain:(BOOL)returnMain
                     successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                       errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;

/** グローバルなエラーハンドラ
 
 @param errorHandler エラーハンドラ
 */
+ (void)setGlobalErrorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler;

@end
