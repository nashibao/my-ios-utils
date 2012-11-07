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

@interface NARestQueryObject : NSObject
@property (strong, nonatomic) NSDictionary *query;
@property (nonatomic) NSInteger pk;
@property (strong, nonatomic) NSManagedObjectID *objectID;
@property (nonatomic) Class modelkls;
@property (strong, nonatomic) NSDictionary *options;
@property (nonatomic, copy) COMPLETE_HANDLER completeHandler;
@property (strong, nonatomic) NSString *rpcName;
@property (nonatomic) NARestType restType;

+ (NARestQueryObject *)query:(NSDictionary *)query
                          pk:(NSInteger)pk
                    objectID:(NSManagedObjectID *)objectID
                       model:(Class)model
                     options:(NSDictionary *)options
             completeHandler:(COMPLETE_HANDLER)completeHandler;

+ (NARestQueryObject *)query:(NSDictionary *)query
                       model:(Class)model
                     options:(NSDictionary *)options
             completeHandler:(COMPLETE_HANDLER)completeHandler;

@end
