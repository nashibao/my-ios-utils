//
//  NAFormValueCellRowData.h
//  SK3
//
//  Created by nashibao on 2012/11/13.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NAFormValue.h"

#import "NAFormTableViewController.h"

@interface NAFormValueCellRowData : NSObject

@property (strong, nonatomic) NAFormValue *formValue;
@property (strong, nonatomic) NSString *cellIdentifier;
@property (nonatomic) FormTableSelectActionType actionType;
@property (strong, nonatomic) void(^backBlock)(id);

- (id)initWithFormValue:(NAFormValue *)formValue
         cellIdentifier:(NSString *)cellIdentifier
             actionType:(FormTableSelectActionType)actionType
              backBlock:(void(^)(id value))backBlock;

@end
