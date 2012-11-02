//
//  NASyncQueryObject.h
//  SK3
//
//  Created by nashibao on 2012/11/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NARestDriverProtocol.h"

typedef void(^COMPLETE_HANDLER)(NSError *err);
typedef void(^SAVE_HANDLER)();

@interface NASyncQueryObject : NSObject
@property (strong, nonatomic) NSDictionary *query;
@property (nonatomic) NSInteger pk;
@property (strong, nonatomic) NSManagedObjectID *objectID;
@property (nonatomic) Class modelkls;
@property (strong, nonatomic) NSDictionary *options;
@property (nonatomic, copy) COMPLETE_HANDLER completeHandler;
@property (nonatomic, copy) SAVE_HANDLER saveHandler;
@property (strong, nonatomic) NSString *rpcName;
@property (nonatomic) NARestType restType;

+ (NASyncQueryObject *)query:(NSDictionary *)query
                          pk:(NSInteger)pk
                    objectID:(NSManagedObjectID *)objectID
                       model:(Class)model
                     options:(NSDictionary *)options
             completeHandler:(COMPLETE_HANDLER)completeHandler
                 saveHandler:(SAVE_HANDLER)saveHandler;

+ (NASyncQueryObject *)query:(NSDictionary *)query
                       model:(Class)model
                     options:(NSDictionary *)options
             completeHandler:(COMPLETE_HANDLER)completeHandler
                 saveHandler:(SAVE_HANDLER)saveHandler;

@end
