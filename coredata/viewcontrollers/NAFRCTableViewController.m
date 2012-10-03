//
//  NAFRCTableViewController.m
//  SK3
//
//  Created by nashibao on 2012/09/28.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFRCTableViewController.h"

@interface NAFRCTableViewController ()

@end

@implementation NAFRCTableViewController

- (void)initialize{
    [super initialize];
    self.isStaticTable = NO;
    self.cellStyle = UITableViewCellStyleDefault;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController sections];
    if([sections count]<=section)return 0;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([[self.fetchedResultsController sections] count]<=section) return nil;
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo name];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if(!cell){
        cell = [[self.cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:self.cellIdentifier];
    }
    
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *mo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath withMO:mo];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withMO:(NSManagedObject *)mo{
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",mo]];
}

@end
