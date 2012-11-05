//
//  NAFRCTableWithAppendViewController.m
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFRCTableWithAppendViewController.h"

@interface NAFRCTableWithAppendViewController ()

@end

@implementation NAFRCTableWithAppendViewController

#pragma mark - Table view data source

- (NSArray *)appendSectionTypeAt:(NSInteger)section{
    NSArray *sections = [self.fetchedResultsController sections];
    NSInteger middle_length = [sections count];
    NSInteger start = 0;
    if(_preAppendRows){
        if(section < [_preAppendRows count]){
            return @[@(NAFRCTableWithAppendSectionTypePRE), @(section)];
        }
        start = [_preAppendRows count];
    }
    if(middle_length > 0){
        if(section < start + middle_length){
            return @[@(NAFRCTableWithAppendSectionTypeMIDDLE), @(section-start)];
        }
        start += middle_length;
    }
    if(_postAppendRows){
        if(section < start + [_postAppendRows count]){
            return @[@(NAFRCTableWithAppendSectionTypePOST), @(section - start)];
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger cnt = [super numberOfSectionsInTableView:tableView];
    if(_preAppendRows)
        cnt += [_preAppendRows count] ;
    if(_postAppendRows)
        cnt += [_postAppendRows count];
    return cnt;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *temp = [self appendSectionTypeAt:section];
    switch ([temp[0] integerValue]) {
        case NAFRCTableWithAppendSectionTypeMIDDLE:
            return [super tableView:tableView numberOfRowsInSection:[temp[1] integerValue]];
            break;
            
        case NAFRCTableWithAppendSectionTypePRE:
            return [_preAppendRows[[temp[1] integerValue]] count];
            break;
            
        case NAFRCTableWithAppendSectionTypePOST:
            return [_postAppendRows[[temp[1] integerValue]] count];
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *temp = [self appendSectionTypeAt:section];
    switch ([temp[0] integerValue]) {
        case NAFRCTableWithAppendSectionTypeMIDDLE:{
            return [super tableView:tableView titleForHeaderInSection:[temp[1] integerValue]];
            break;
        }
            
        case NAFRCTableWithAppendSectionTypePRE:
            return [self appendTableView:tableView titleForHeaderInSection:[temp[1] integerValue] pre:YES];
            break;
            
        case NAFRCTableWithAppendSectionTypePOST:
            return [self appendTableView:tableView titleForHeaderInSection:[temp[1] integerValue] pre:NO];
            break;
            
        default:
            break;
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)_indexPath
{
    
    NSArray *temp = [self appendSectionTypeAt:_indexPath.section];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_indexPath.row inSection:[temp[1] integerValue]];
    switch ([temp[0] integerValue]) {
        case NAFRCTableWithAppendSectionTypeMIDDLE:{
            return [super tableView:tableView cellForRowAtIndexPath:indexPath];
            break;
        }
            
        case NAFRCTableWithAppendSectionTypePRE:
            return [self appendTableView:tableView cellForRowAtIndexPath:indexPath pre:YES];
            break;
            
        case NAFRCTableWithAppendSectionTypePOST:
            return [self appendTableView:tableView cellForRowAtIndexPath:indexPath pre:NO];
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSString *)appendTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)_section pre:(BOOL)pre{
    return @"";
}

- (UITableViewCell *)appendTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)_indexPath pre:(BOOL)pre{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if(!cell){
        cell = [[self.cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:self.cellIdentifier];
        [cell setAccessoryType:self.cellAccessoryType];
    }
    id obj = nil;
    if(pre){
        obj = self.preAppendRows[_indexPath.section][_indexPath.row];
    }else{
        obj = self.postAppendRows[_indexPath.section][_indexPath.row];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", obj]];
    return cell;
}

@end
