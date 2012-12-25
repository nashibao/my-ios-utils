//
//  NASyncQueryObject.m
//  SK3
//
//  Created by nashibao on 2012/11/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NARestQueryObject.h"

@implementation NARestQueryObject

+ (NARestQueryObject *)query:(NSDictionary *)query
                          pk:(NSInteger)pk
                    objectID:(NSManagedObjectID *)objectID
                       model:(Class)model
                    maskType:(NAProgressHUDMaskType)maskType
                     options:(NSDictionary *)options
             completeHandler:(COMPLETE_HANDLER)completeHandler{
    NARestQueryObject *qo = [[NARestQueryObject alloc] init];
    qo.query = query;
    qo.pk = pk;
    qo.objectID = objectID;
    qo.modelkls = model;
    qo.options = options;
    qo.maskType = maskType;
    qo.completeHandler = completeHandler;
    return qo;
}

#warning -1を何か定数に置き換える？
+ (NARestQueryObject *)query:(NSDictionary *)query
                       model:(Class)model
                    maskType:(NAProgressHUDMaskType)maskType
                     options:(NSDictionary *)options
             completeHandler:(COMPLETE_HANDLER)completeHandler{
    return [self query:query pk:-1 objectID:nil model:model maskType:maskType options:options completeHandler:completeHandler];
}

- (BOOL)nomap{
    if(self.options && self.options[@"nomap"] && [self.options[@"nomap"] boolValue]){
        return YES;
    }
    return NO;
}

@end
