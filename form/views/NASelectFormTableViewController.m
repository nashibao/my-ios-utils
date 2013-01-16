//
//  NASelectFormTableViewController.m
//  SK3
//
//  Created by nashibao on 2012/10/31.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NASelectFormTableViewController.h"


@interface NASelectFormTableViewController ()

@end

@implementation NASelectFormTableViewController

#pragma mark - Table view data source

- (void)setupTableViewController{
    [super setupTableViewController];
    self.cellStyle = UITableViewCellStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self.formValue selectedIndexPath]){
        self.selectedIndexPath = [self.formValue selectedIndexPath];
        [self.navigationItem setTitle:self.formValue.label];
        [self.tableView scrollToRowAtIndexPath:self.selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [_parentTableViewController willActionBacked:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.formValue selects] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_formValue setSelectedIndexPath:indexPath];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    [cell.textLabel setText:(_formValue.selects[indexPath.row][_formValue.label_key])];
    if(_formValue.selects[indexPath.row][_formValue.value_key] == _formValue.value){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

- (void)initializeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier{
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumFontSize = 12.0f;
}


@end
