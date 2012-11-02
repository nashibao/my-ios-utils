//
//  NASyncQueryObject.m
//  SK3
//
//  Created by nashibao on 2012/11/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASyncQueryObject.h"

@implementation NASyncQueryObject

+ (NASyncQueryObject *)query:(NSDictionary *)query
                          pk:(NSInteger)pk
                    objectID:(NSManagedObjectID *)objectID
                       model:(Class)model
                     options:(NSDictionary *)options
             completeHandler:(COMPLETE_HANDLER)completeHandler
                 saveHandler:(SAVE_HANDLER)saveHandler{
    NASyncQueryObject *qo = [[NASyncQueryObject alloc] init];
    qo.query = query;
    qo.pk = pk;
    qo.objectID = objectID;
    qo.modelkls = model;
    qo.options = options;
    qo.completeHandler = completeHandler;
    qo.saveHandler = saveHandler;
    return qo;
}

#warning -1を何か定数に置き換える？
+ (NASyncQueryObject *)query:(NSDictionary *)query
                       model:(Class)model
                     options:(NSDictionary *)options
             completeHandler:(COMPLETE_HANDLER)completeHandler
                 saveHandler:(SAVE_HANDLER)saveHandler{
    return [self query:query pk:-1 objectID:nil model:model options:options completeHandler:completeHandler saveHandler:saveHandler];
}

@end
