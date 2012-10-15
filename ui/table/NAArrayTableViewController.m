//
//  NAArrayTableViewController.m
//  SK3
//
//  Created by nashibao on 2012/10/12.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAArrayTableViewController.h"

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

- (id)rowData:(id)row{
    return row[@"data"];
}

- (NSString *)rowCellIdentifier:(id)row{
    if(row)
        return row[@"cell"];
    return nil;
}

- (id)rowAtIndexPath:(NSIndexPath *)indexPath{
    return [self sectionRows:self.sections[indexPath.section]][indexPath.row];
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
    
    [self updateCell:cell atIndexPath:indexPath row:row];
    
    return cell;
}

- (void)initializeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier row:(id)row{
    [self initializeCell:cell atIndexPath:indexPath reuseIdentifier:reuseIdentifier];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath row:(id)row{
    [self updateCell:cell atIndexPath:indexPath];
}

@end
