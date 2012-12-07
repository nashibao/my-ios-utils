//
//  NAArrayTableViewController.m
//  SK3
//
//  Created by nashibao on 2012/10/12.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAArrayTableViewController.h"

#import "NATableViewCell.h"

@interface NAArrayTableViewController ()

@end

@implementation NAArrayTableViewController

- (NSString *)sectionHeaderTitle:(id)section{
    return section[@"header"];
}
- (NSString *)sectionFooterTitle:(id)section{
    return section[@"footer"];
}
- (NSArray *)sectionRows:(id)section{
    return section[@"rows"];
}

//- 
- (NAFormTableSelectActionType)rowActionType:(id)row{
    if([row isKindOfClass:[NAFormValue class]]){
        NAFormValue *formValue = (NAFormValue *)row;
        return formValue.actionType;
    }
    return [row[@"actionType"] integerValue];
}

- (NSString *)rowCellIdentifier:(id)row{
    if([row isKindOfClass:[NAFormValue class]]){
        NAFormValue *formValue = (NAFormValue *)row;
        return formValue.cellIdentifier;
    }
    if(row)
        return row[@"cellIdentifier"];
    return nil;
}

- (id)rowAtIndexPath:(NSIndexPath *)indexPath{
    return [self sectionRows:self.sections[indexPath.section]][indexPath.row];
}

- (id)indexPathOfRow:(id)row{
    NSIndexPath *ipth = nil;
    NSInteger sectionidx = 0;
    for (NSDictionary *section in self.sections) {
        NSArray *rows = [self sectionRows:section];
        NSInteger rowidx = [rows indexOfObject:row];
        if(rowidx!=NSNotFound){
            ipth = [NSIndexPath indexPathForRow:rowidx inSection:sectionidx];
            break;
        }
        sectionidx += 1;
    }
    return ipth;
}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self sectionRows:_sections[section]] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self sectionHeaderTitle:_sections[section]];
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [self sectionFooterTitle:_sections[section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    id row = [self rowAtIndexPath:indexPath];
    
    NSString *cellIdentifier = [self rowCellIdentifier:row];
    if(!cellIdentifier)
        cellIdentifier = self.cellIdentifier;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[self.cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:cellIdentifier];
        [cell setAccessoryType:self.cellAccessoryType];
        [self initializeCell:cell atIndexPath:indexPath reuseIdentifier:cellIdentifier row:row];
    }
    
    if([cell isKindOfClass:[NATableViewCell class]]){
        id data = row;
        [(NATableViewCell *)cell setData:data];
    }
    
//    void (^updateCellBlock)(UITableViewCell *, NSIndexPath *) = row[@"updateCell"];
//    if(updateCellBlock){
//        updateCellBlock(cell, indexPath);
//    }
    
    [self updateCell:cell atIndexPath:indexPath row:row];
    
    return cell;
}

- (void)initializeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier row:(id)row{
    [self initializeCell:cell atIndexPath:indexPath reuseIdentifier:reuseIdentifier];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath row:(id)row{
    if([cell isKindOfClass:[NATableViewCell class]]){
        NATableViewCell *nacell = (NATableViewCell *)cell;
        nacell.data = row;
    }
    [self updateCell:cell atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    id row = [self rowAtIndexPath:indexPath];
    [self willSelectByRow:row];
}

- (void)willSelectByRow:(id)row{
    
}

- (void)willActionBacked:(UITableViewController *)controller{
    if(self.selectedIndexPath){
        id row = [self rowAtIndexPath:self.selectedIndexPath];
        [self willActionBackedByRow:row];
    }
}

- (void)willActionBackedByRow:(id)row{
    [self.tableView reloadData];
}

@end
