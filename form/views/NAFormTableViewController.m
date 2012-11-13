//
//  NAFormTableViewController.m
//  SK3
//
//  Created by nashibao on 2012/10/15.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFormTableViewController.h"

#import "NAFormValue.h"

#import "NASelectFormTableViewController.h"

#import "NAMultipleSelectFormTableViewController.h"

@interface NAFormTableViewController ()

@end

@implementation NAFormTableViewController

- (void)formCell:(NAFormCell *)cell inTableViewController:(UITableViewController *)tableViewController
    modifiedData:(id)modifiedData
       formValue:(NAFormValue *)formValue{
    [self changeFormValue:formValue newValue:modifiedData];
    [self willActionBackedByRow:formValue];
}

/** keyboardのNextでfocus移動が出来るかどうかなど．
 reloadTableが途中で挟まれる場合、TextFieldなどに渡したフォーカスは捨てられる．
 */
- (BOOL)enableNextFocus{
    return YES;
}

- (void)formCell:(NAFormCell *)cell inTableViewController:(UITableViewController *)tableViewController nextFocus:(BOOL)focus formValue:(NAFormValue *)formValue{
    if([self enableNextFocus]){
        NAFormValue *nextFormValue = [self nextFormValue:formValue];
        if(nextFormValue)
            [nextFormValue focus:YES];
    }
}

- (void)changeFormValue:(NAFormValue *)formValue newValue:(id)newValue{
    [formValue setValue:newValue];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath row:(id)row{
    id data = row;
    if([cell isKindOfClass:[NAFormCell class]]){
        NAFormCell *fcell = (NAFormCell *)cell;
        [fcell setDelegate:self];
//        [fcell setIndexPath:indexPath];
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
            id data = row;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    id row = [self rowAtIndexPath:indexPath];
    NAFormTableSelectActionType actionType = NAFormTableSelectActionTypeNone;
    if ([row isKindOfClass:[NAFormValue class]]) {
        NAFormValue *formValue = (NAFormValue *)row;
        actionType = formValue.actionType;
    }else{
        actionType = [row[@"actionType"] integerValue];
    }
    if(actionType){
//        ここを上書きすれば、新しいアクションを追加できる
        switch (actionType) {
            case NAFormTableSelectActionTypeOpenSelectTable:{
                NASelectFormTableViewController *selectTableViewController = [[NASelectFormTableViewController alloc] initWithStyle:UITableViewStylePlain];
                selectTableViewController.formValue = row;
                [selectTableViewController setParentTableViewController:self];
                [self.navigationController pushViewController:selectTableViewController animated:YES];
                break;
            }
            case NAFormTableSelectActionTypeOpenMultipleSelectTable:{
                NAMultipleSelectFormTableViewController *selectTableViewController = [[NAMultipleSelectFormTableViewController alloc] initWithStyle:UITableViewStylePlain];
                selectTableViewController.formValue = row;
                [selectTableViewController setParentTableViewController:self];
                [self.navigationController pushViewController:selectTableViewController animated:YES];
                break;
            }
            default:
                break;
        }
    }
}


@end
