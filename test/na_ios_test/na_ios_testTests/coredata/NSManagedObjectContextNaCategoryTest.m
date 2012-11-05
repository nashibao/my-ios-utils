//
//  NSManagedObjectContextNaCategoryTest.m
//  na_ios_test
//
//  Created by nashibao on 2012/10/30.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "NSManagedObjectContextNaCategoryTest.h"

#import "NAAsyncOCUnit.h"

#import "NAModelController.h"

#import "TestParent.h"

#import "TestChild.h"

#import "NSManagedObject+na.h"

@implementation NSManagedObjectContextNaCategoryTest

- (void)setUp
{
    [super setUp];
    
    //    modelcontroller作成
    self.modelController = [[NAModelController alloc] init];
    
    //    (test時だけbundle指定が必要)
    self.modelController.name = @"testmodel";
    self.modelController.bundle = [NSBundle bundleForClass:[TestParent class]];
    [self.modelController setup];
    
    //    modelへの設定
    [TestParent setMainContext:_modelController.mainContext];
    
    //    古いデータの削除
    [TestParent delete_all];
    
    [TestParent save];
}

- (void)tearDown
{
    [TestParent delete_all];
    
    [TestParent save];
    
    [super tearDown];
}

/** カテゴリ同期メソッドテスト
 */
- (void)testSyncMethods
{
    
    //    mo作成
    TestParent *pa1 = [TestParent create:@{@"name": @"test"} options:nil];
    
    STAssertTrue([pa1 isKindOfClass:[TestParent class]], @"返り値はそれ自体");
    
    NSArray *mos = [TestParent filter:nil options:nil];
    
    STAssertTrue([mos count] == 1, @"filter test");
    
    STAssertEqualObjects([mos objectAtIndex:0], pa1, @"同じコンテクストだから同じはず？");
    
    TestParent *pa2 = [TestParent get:@{@"name": @"test"} options:nil];
    
    STAssertEqualObjects(pa1, pa2, @"get test");
    
    TestParent *pa3 = [TestParent get_or_create:@{@"name": @"test"} options:nil];
    
    STAssertEqualObjects(pa3, pa1, @"unique制約");
    
    TestParent *pa4 = [TestParent create:@{@"name": @"test2"} options:nil];
    
    STAssertFalse(pa1 == pa4, @"create test");
    
    mos = [TestParent filter:nil options:nil];
    
    STAssertTrue([mos count] == 2, @"filter test");
    
    mos = [TestParent filter:@{@"name": @"test"} options:nil];
    
    STAssertTrue([mos count] == 1, @"filter test");
    
    [TestParent delete_all];
    
    mos = [TestParent filter:nil options:nil];
    
    STAssertTrue([mos count] == 0, @"delete test");
}

/** カテゴリ非同期メソッドテスト
 */
- (void)testAsyncMethods
{
    STAsynchronousTestStart(asynccreate);
    
    [TestParent create:@{@"name": @"test"} options:nil complete:^(id mo) {
        TestParent *pa = (TestParent *)mo;
        STAssertTrue([pa isKindOfClass:[TestParent class]], @"async create");
        STAssertTrue([@"test" isEqualToString:[pa name]], nil);
        STAsynchronousTestDone(asynccreate);
    }];
    
    STAsynchronousTestWait(asynccreate, 0.5);
    
    [TestParent create:@{@"name": @"test2"} options:nil];
    
    //    saveをしないとcontextがマージされない！！
    [TestParent save];
    
    STAsynchronousTestStart(asyncget);
    
    [TestParent get:@{@"name": @"test"} options:nil complete:^(id mo) {
        TestParent *pa = (TestParent *)mo;
        STAssertTrue([@"test" isEqualToString:[pa name]], nil);
        STAsynchronousTestDone(asyncget);
    }];
    
    STAsynchronousTestWait(asyncget, 0.5);
    
    NSArray *mos = [TestParent filter:nil options:nil];
    STAssertTrue([mos count] == 2, nil);
    
    STAsynchronousTestStart(asyncfilter);
    
    [TestParent filter:nil options:nil complete:^(NSArray *mos) {
        NSLog(@"%s|%d", __PRETTY_FUNCTION__, [mos count]);
        STAssertTrue([mos count] == 2, nil);
        STAsynchronousTestDone(asyncfilter);
    }];
    
    STAsynchronousTestWait(asyncfilter, 0.5);
    
    STAsynchronousTestStart(asyncgetcreate);
    
    [TestParent get_or_create:@{@"name": @"test"} options:nil complete:^(id mo) {
        TestParent *pa1 = (TestParent *)mo;
        NSArray *mos = [TestParent filter:nil options:nil];
        STAssertTrue([mos count] == 2, nil);
        
        TestParent *pa = [TestParent get:@{@"name": @"test"} options:nil];
        TestParent *pa2 = (TestParent *)[[TestParent mainContext] objectWithID:pa1.objectID];
        STAssertTrue(pa == pa2, nil);
        STAsynchronousTestDone(asyncgetcreate);
    }];
    
    STAsynchronousTestWait(asyncgetcreate, 0.5);
    
    STAsynchronousTestStart(asynccreate2);
    
    [TestParent get_or_create:@{@"name": @"test3"} options:nil complete:^(id mo) {
        NSArray *mos = [TestParent filter:nil options:nil];
        STAssertTrue([mos count] == 3, nil);
        STAsynchronousTestDone(asynccreate2);
    }];
    
    STAsynchronousTestWait(asynccreate2, 0.5);
}

@end
