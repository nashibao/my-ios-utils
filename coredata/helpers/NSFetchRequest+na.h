//
//  NSFetchRequest+na.h
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest (na)

- (void)updateWithEqualProps:(NSDictionary *)equalProps;
- (void)updateWithProps:(NSArray *)props;

@end
