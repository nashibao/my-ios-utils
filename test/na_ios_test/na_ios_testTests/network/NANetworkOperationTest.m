//
//  NANetworkOperationTest.m
//  na_ios_test
//
//  Created by nashibao on 2012/10/29.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "NANetworkOperationTest.h"
#import "NAAsyncOCUnit.h"

#import "NANetworkGCDHelper.h"

#import "NANetworkOperation.h"

#import "NSURLRequest+na.h"

@implementation NANetworkOperationTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

/**
 単純な突っ込みテスト
 */
- (void)testJustSend
{
    STAsynchronousTestStart(test);
    NSURLRequest *req = [NSURLRequest request:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testjustsend" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionReturnOld successHandler:^(NANetworkOperation *op, id data) {
        STAssertTrue(YES, @"testSendAsynchronousRequest success");
        STAsynchronousTestDone(test);
    } errorHandler:^(NANetworkOperation *op, NSError *err) {
        STAssertTrue(NO, @"testSendAsynchronousRequest error");
        STAsynchronousTestDone(test);
    }];
    
    STAsynchronousTestWait(test, 0.5);
}

/**
 キャンセルの確認
 NANetworkOperationQueingOptionReturnOld
 */
- (void)testCancel1
{
    NSURLRequest *req = [NSURLRequest request:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    
    NANetworkOperation *op1 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel1" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionReturnOld successHandler:nil errorHandler:nil];
    
    NANetworkOperation *op2 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel1" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionReturnOld successHandler:nil errorHandler:nil];
    
    STAssertEqualObjects(op1, op2, @"新しく作る代わりに古いのがかえってくるはず");
}

/**
 キャンセルの確認
 NANetworkOperationQueingOptionReturnOld
 */
- (void)testCancel2
{
    NSURLRequest *req = [NSURLRequest request:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    NANetworkOperation *op1 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel2" identifierMaxCount:2 options:nil queueingOption:NANetworkOperationQueingOptionReturnOld successHandler:nil errorHandler:nil];
    
    NANetworkOperation *op2 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel2" identifierMaxCount:2 options:nil queueingOption:NANetworkOperationQueingOptionReturnOld successHandler:nil errorHandler:nil];
    
    NANetworkOperation *op3 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel2" identifierMaxCount:2 options:nil queueingOption:NANetworkOperationQueingOptionReturnOld successHandler:nil errorHandler:nil];
    
    NANetworkOperation *op4 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel2" identifierMaxCount:2 options:nil queueingOption:NANetworkOperationQueingOptionReturnOld successHandler:nil errorHandler:nil];
    
    STAssertFalse(op1 == op2, @"二つ作られるはず");
    STAssertEqualObjects(op3, op2, @"1,2が作られて、3はつくられずに古いのがかえってくる");
    STAssertEqualObjects(op3, op4, @"1,2が作られて、4はつくられずに古いのがかえってくる");
}

/**
 キャンセルの確認
 NANetworkOperationQueingOptionJustAdd
 */
- (void)testCancel3
{
    NSURLRequest *req = [NSURLRequest request:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    NANetworkOperation *op1 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel3" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionJustAdd successHandler:nil errorHandler:nil];
    
    NANetworkOperation *op2 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel3" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionJustAdd successHandler:nil errorHandler:nil];
    
    STAssertFalse(op1 == op2, @"二つ作られるはず");
}

/**
 キャンセルの確認
 NANetworkOperationQueingOptionJustAdd
 */
- (void)atestCancel4
{
    NSURLRequest *req = [NSURLRequest request:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    NANetworkOperation *op1 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel4" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionCancel successHandler:nil errorHandler:nil];
    
    NANetworkOperation *op2 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel4" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionCancel successHandler:nil errorHandler:nil];
    
    STAssertFalse(op1 == op2, @"二つ作られるはず");
    STAssertTrue([op1 isCancelled], @"一つ目がキャンセルされているはず");
}

/**
 キャンセルの確認
 NANetworkOperationQueingOptionJustAdd
 */
- (void)testCancel5
{
    
    STAsynchronousTestStart(test);
    NSURLRequest *req = [NSURLRequest request:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    NANetworkOperation *op1 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel5" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionJustAdd successHandler:^(NANetworkOperation *op, id data) {
        STAssertTrue(NO, @"ここまでこないはず");
    } errorHandler:^(NANetworkOperation *op, NSError *err) {
        STAssertTrue(NO, @"cancelはerrorHandlerにくる？いや、こない");
    }];
    
    NANetworkOperation *op2 = [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testCancel5" identifierMaxCount:1 options:nil queueingOption:NANetworkOperationQueingOptionJustAdd successHandler:^(NANetworkOperation *op, id data) {
        STAssertTrue(NO, @"ここまでこないはず");
    } errorHandler:^(NANetworkOperation *op, NSError *err) {
        STAssertTrue(NO, @"cancelはerrorHandlerにくる？いや、こない");
    }];
    
    [NANetworkOperation cancelByIdentifier:@"testCancel5" handler:^{
        NSArray *ops = [NANetworkOperation getOperationsByIdentifier:@"testCancel5"];
        NSLog(@"%s|%d", __PRETTY_FUNCTION__, [ops count]);
        STAssertTrue([ops count] == 0, @"キャンセル後は全てなくなっているはず");
        STAsynchronousTestDone(test);
    }];
    
    STAssertTrue([op1 isCancelled], @"一つ目がキャンセルされているはず");
    STAssertTrue([op2 isCancelled], @"一つ目がキャンセルされているはず");
    
    
    STAsynchronousTestWait(test, 0.5);
}

/** reachabilityのテストをしたいが．．breakpointでやるしかないな．
 */
//- (void)testReachability
//{
//    STAsynchronousTestStart(test);
//    NSURLRequest *req = [NANetworkGCDHelper requestTo:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
//    
//    [NANetworkOperation sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:YES queue:nil identifier:@"testReachability" identifierMaxCount:1 queueingOption:NANetworkOperationQueingOptionJustAdd successHandler:^(NANetworkOperation *op, id data) {
//        STAssertTrue(YES, @"これでOK");
//        STAsynchronousTestDone(test);
//    } errorHandler:^(NANetworkOperation *op, NSError *err) {
//        STAssertTrue(NO, @"エラーははかずにresumeしてほしい");
//        STAsynchronousTestDone(test);
//    }];
//    
//    NSLog(@"%s|%@", __PRETTY_FUNCTION__, @"ここでブレークポイント");
//    
//    STAsynchronousTestWait(test, 0.5);
//}




@end
