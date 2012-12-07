//
//  UITableView+na.m
//  SK3
//
//  Created by nashibao on 2012/11/30.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "UITableView+na.h"

@implementation UITableView (na)

- (void)scrollToBottomWithAnimated:(BOOL)animated{
    NSInteger sectioncnt = [self numberOfSections] -1;
    if(sectioncnt > -1){
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self numberOfRowsInSection:sectioncnt]-1 inSection:sectioncnt] atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
}

@end
