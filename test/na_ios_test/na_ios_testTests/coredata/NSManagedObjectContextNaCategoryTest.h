//
//  NSManagedObjectContextNaCategoryTest.h
//  na_ios_test
//
//  Created by nashibao on 2012/10/30.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "NAAsyncOCUnit.h"

#import "NAModelController.h"

#import "TestParent.h"

#import "TestChild.h"

#import "NSManagedObject+na.h"

@interface NSManagedObjectContextNaCategoryTest : SenTestCase

@property (strong, nonatomic) NAModelController *modelController;

@end
