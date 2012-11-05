//
//  NAFRCTableWithAppendViewController.h
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NAFRCTableViewController.h"

typedef enum NAFRCTableWithAppendSectionType: NSUInteger{
    NAFRCTableWithAppendSectionTypePRE,
    NAFRCTableWithAppendSectionTypeMIDDLE,
    NAFRCTableWithAppendSectionTypePOST,
} NAFRCTableWithAppendSectionType;



@interface NAFRCTableWithAppendViewController : NAFRCTableViewController

/*
 二重arrayでデータが入る
 */
@property (strong, nonatomic) NSArray *preAppendRows;
@property (strong, nonatomic) NSArray *postAppendRows;

- (NSArray *)appendSectionTypeAt:(NSInteger)section;

- (NSString *)appendTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)_section pre:(BOOL)pre;

- (UITableViewCell *)appendTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)_indexPath pre:(BOOL)pre;

@end
