//
//  NAFormValueCellRowData.m
//  SK3
//
//  Created by nashibao on 2012/11/13.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormValueCellRowData.h"

@implementation NAFormValueCellRowData

- (id)initWithFormValue:(NAFormValue *)formValue
         cellIdentifier:(NSString *)cellIdentifier
             actionType:(FormTableSelectActionType)actionType
              backBlock:(void(^)(id value))backBlock{
    self = [super init];
    if(self){
        self.formValue = formValue;
        self.cellIdentifier = cellIdentifier;
        self.actionType = actionType;
        self.backBlock = backBlock;
    }
    return self;
}

@end
