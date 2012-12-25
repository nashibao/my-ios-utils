//
//  TestFRCTableViewController.m
//  na_ios_test
//
//  Created by nashibao on 2012/11/06.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "EventFRCTableViewController.h"

#import "NSManagedObject+na.h"

#import "Event.h"

@implementation EventFRCTableViewController

- (void)initialize{
    [super initialize];
    
//    frcの設定
    NSFetchedResultsController *frc = [Event controllerWithEqualProps:@{}
                                                                sorts:@[@"date"]
                                                              context:nil o
                                                               ptions:nil];
    [frc performFetch:nil];
    self.fetchedResultsController = frc;
}

//- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withMO:(NSManagedObject *)mo{
////    表示のカスタム
//}

- (IBAction)addEvent:(id)sender{
    //    dataの更新
    [Event create:@{@"date": [NSDate date]} options:nil complete:^(id mo) {
        
        //        ここで更新(メインスレッド)
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
    }];
}

@end
