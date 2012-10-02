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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:self.cellStyle reuseIdentifier:CellIdentifier];
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

# pragma mark frc delegates

//frc delegateは重くなるな．．

//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//    NSLog(@"%s",__FUNCTION__);
//    UITableView *tableView;
//    if(controller == self.fetchedResultsController){
//        tableView = self.tableView;
//    }else{
//        tableView = self.searchDisplayController.searchResultsTableView;
//    }
//    NSLog(@"%s:%d",__FUNCTION__,sectionIndex);
//    switch(type) {
//        case NSFetchedResultsChangeInsert:
//            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            
//            NSLog(@"%s",__FUNCTION__);
//            
//            break;
//        case NSFetchedResultsChangeMove:
//            
//            
//            NSLog(@"%s",__FUNCTION__);
//            
//            break;
//    }
//}
//
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
//       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
//      newIndexPath:(NSIndexPath *)newIndexPath {
//    UITableView *tableView;
//    if(controller == self.fetchedResultsController){
//        tableView = self.tableView;
//    }else{
//        tableView = self.searchDisplayController.searchResultsTableView;
//    }
//    
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//        case NSFetchedResultsChangeUpdate:{
//            NSManagedObject *mo = anObject;
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            [self updateCell:cell atIndexPath:indexPath withMO:mo];
//            break;
//        }
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//    }
//}
//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    if(controller == self.fetchedResultsController){
//        [self.tableView beginUpdates];
//    }else{
//        [self.searchDisplayController.searchResultsTableView beginUpdates];
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    if(controller == self.fetchedResultsController){
//        [self.tableView endUpdates];
//    }else{
//        [self.searchDisplayController.searchResultsTableView endUpdates];
//    }
//}

@end
