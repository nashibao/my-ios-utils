//
//  NAFRCDelegateTableViewController.m
//  SK3
//
//  Created by nashibao on 2012/10/02.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFRCDelegateTableViewController.h"

@interface NAFRCDelegateTableViewController ()

@end

@implementation NAFRCDelegateTableViewController

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"%s",__FUNCTION__);
    UITableView *tableView;
    if(controller == self.fetchedResultsController){
        tableView = self.tableView;
    }else{
        tableView = self.searchDisplayController.searchResultsTableView;
    }
    NSLog(@"%s:%d",__FUNCTION__,sectionIndex);
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            
            NSLog(@"%s",__FUNCTION__);
            
            break;
        case NSFetchedResultsChangeMove:
            
            
            NSLog(@"%s",__FUNCTION__);
            
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView;
    if(controller == self.fetchedResultsController){
        tableView = self.tableView;
    }else{
        tableView = self.searchDisplayController.searchResultsTableView;
    }
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:{
            NSManagedObject *mo = anObject;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [self updateCell:cell atIndexPath:indexPath withMO:mo];
            break;
        }
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if(controller == self.fetchedResultsController){
        [self.tableView beginUpdates];
    }else{
        [self.searchDisplayController.searchResultsTableView beginUpdates];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if(controller == self.fetchedResultsController){
        [self.tableView endUpdates];
    }else{
        [self.searchDisplayController.searchResultsTableView endUpdates];
    }
}

@end
