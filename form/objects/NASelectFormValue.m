//
//  NASelectFormValue.m
//  SK3
//
//  Created by nashibao on 2012/09/27.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASelectFormValue.h"

@implementation NASelectFormValue

- (id)init{
    self = [super init];
    if(self){
        self.label_key = @"label";
        self.value_key = @"value";
    }
    return self;
}

- (NSString *)stringValue{
    if(self.cachedStringValue)
        return self.cachedStringValue;
    return self.selectedLabel;
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath{
    _selectedIndexPath = selectedIndexPath;
    id val = nil;
    if(_selectedIndexPath){
        val = self.selects[_selectedIndexPath.row];
    }
    if(val){
        _selectedLabel = val[self.label_key];
        self.value = val[self.value_key];
    }else{
        _selectedLabel = @"";
        self.value = nil;
    }
}

@end
