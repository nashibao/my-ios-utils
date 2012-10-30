//
//  TestParent.h
//  na_ios_test
//
//  Created by nashibao on 2012/10/30.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TestChild;

@interface TestParent : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *childs;
@end

@interface TestParent (CoreDataGeneratedAccessors)

- (void)addChildsObject:(TestChild *)value;
- (void)removeChildsObject:(TestChild *)value;
- (void)addChilds:(NSSet *)values;
- (void)removeChilds:(NSSet *)values;

@end
