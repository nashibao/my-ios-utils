//
//  NAFormTableViewController.m
//  SK3
//
//  Created by nashibao on 2012/10/15.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormTableViewController.h"

#import "NAFormValue.h"

@interface NAFormTableViewController ()

@end

@implementation NAFormTableViewController

- (void)formCell:(NAFormCell *)cell inTableViewController:(UITableViewController *)tableViewController
    modifiedData:(id)modifiedData
       formValue:(NAFormValue *)formValue
       indexPath:(NSIndexPath *)indexPath{
    [self changeFormValue:formValue newValue:modifiedData];
}

- (void)formCell:(NAFormCell *)cell inTableViewController:(UITableViewController *)tableViewController nextFocus:(BOOL)focus formValue:(NAFormValue *)formValue indexPath:(NSIndexPath *)indexPath{
    NAFormValue *nextFormValue = [self nextFormValue:formValue];
    if(nextFormValue)
        [nextFormValue focus:YES];
}

- (void)changeFormValue:(NAFormValue *)formValue newValue:(id)newValue{
    [formValue setValue:newValue];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath row:(id)row{
    id data = [self rowData:row];
    if([cell isKindOfClass:[NAFormCell class]]){
        NAFormCell *fcell = (NAFormCell *)cell;
        [fcell setDelegate:self];
        if([data isKindOfClass:[NAFormValue class]]){
            [fcell setFormValue:(NAFormValue *)data];
        }
    }
}

- (NAFormValue *)nextFormValue:(NAFormValue *)formValue{
    NAFormValue *_formValue = nil;
    NAFormValue *nextFormValue = nil;
    for (id section in self.sections) {
        NSArray *rows = [self sectionRows:section];
        for (id row in rows) {
            id data = [self rowData:row];
            if([data isKindOfClass:[NAFormValue class]]){
                if(_formValue){
                    nextFormValue = data;
                    return nextFormValue;
                }else{
                    if(data==formValue){
                        _formValue = data;
                    }
                }
            }
        }
    }
    return nil;
}

@end
