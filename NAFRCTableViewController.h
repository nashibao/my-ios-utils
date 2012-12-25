//
//  NAFRCTableViewController.h
//  SK3
//
//  Created by nashibao on 2012/09/28.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "NATableViewController.h"

/*
 template tableviewcontroller class which use with a frc.
 
 you should use this by subclassing this.
 
 to use this, these two lines are needed.
 self.fetchedResultsController = frc;
 frc.delegate = self;
 */
@interface NAFRCTableViewController : NATableViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withMO:(NSManagedObject *)mo;

@end
