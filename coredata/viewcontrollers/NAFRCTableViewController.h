//
//  NAFRCTableViewController.h
//  SK3
//
//  Created by nashibao on 2012/09/28.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAFRCTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) UITableViewCellStyle cellStyle;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end
