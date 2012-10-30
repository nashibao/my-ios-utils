//
//  TestChild.h
//  na_ios_test
//
//  Created by nashibao on 2012/10/30.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TestParent;

@interface TestChild : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) TestParent *parent;

@end
