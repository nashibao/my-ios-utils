//
//  NAMultipleSelectValue.m
//  SK3
//
//  Created by nashibao on 2012/10/31.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAMultipleSelectFormValue.h"

@implementation NAMultipleSelectFormValue

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

//valueはvalueのNSArray
- (void)setValue:(id)value{
    _value = value;
    _selectedLabel = nil;
    _selectedIndexPaths = nil;
    if(value){
        NSMutableArray * selectedObjects = [@[] mutableCopy];
        for(id tempval in value){
            for(id val in self.selects){
                if([tempval isEqual:val[self.value_key]]){
                    [selectedObjects addObject:val];
                    break;
                }
            }
        }
        if([selectedObjects count] > 0){
            _selectedLabel = @"";
            _selectedIndexPaths = [@[] mutableCopy];
            for (id val in selectedObjects) {
                [_selectedIndexPaths addObject:[NSIndexPath indexPathForRow:[self.selects indexOfObject:val] inSection:0]];
                _selectedLabel = [NSString stringWithFormat:@"%@%@,",_selectedLabel,val[self.label_key]];
            }
        }
    }
}

- (void)setSelectedIndexPaths:(NSMutableArray *)selectedIndexPaths{
    _selectedIndexPaths = selectedIndexPaths;
    _value = nil;
    _selectedLabel = nil;
    if(_selectedIndexPaths && [_selectedIndexPaths count] > 0){
        NSMutableArray *tempvalue = [@[] mutableCopy];
        _selectedLabel = @"";
        for (NSIndexPath * indexPath in selectedIndexPaths) {
            id val = self.selects[indexPath.row];
            [tempvalue addObject:val[self.value_key]];
            _selectedLabel = [NSString stringWithFormat:@"%@%@,", _selectedLabel, val[self.label_key]];
        }
        _value = tempvalue;
    }
}

@end
