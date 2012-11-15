//
//  NASelectFormValue.m
//  SK3
//
//  Created by nashibao on 2012/09/27.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASelectFormValue.h"

@implementation NASelectFormValue

@synthesize value = _value;

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

- (void)setValue:(id)value{
    _value = value;
    if(value){
        id selectedObject = nil;
        for(id val in self.selects){
            if([value isEqual:val[self.value_key]]){
                selectedObject = val;
                break;
            }
        }
        if(selectedObject){
            _selectedIndexPath = [NSIndexPath indexPathForRow:[self.selects indexOfObject:selectedObject] inSection:0];
            _selectedLabel = selectedObject[self.label_key];
        }else{
            _selectedLabel = nil;
            _selectedIndexPath = nil;
        
        }
    }else{
        _selectedLabel = nil;
        _selectedIndexPath = nil;
    }
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath{
    _selectedIndexPath = selectedIndexPath;
    id val = nil;
    if(_selectedIndexPath){
        val = self.selects[_selectedIndexPath.row];
    }
    if(val){
        _selectedLabel = val[self.label_key];
        _value = val[self.value_key];
    }else{
        _selectedLabel = @"";
        _value = nil;
    }
}

@end
