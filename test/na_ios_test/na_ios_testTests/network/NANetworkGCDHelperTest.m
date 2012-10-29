//
//  na_ios_testTests.m
//  na_ios_testTests
//
//  Created by nashibao on 2012/10/29.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//
#import "NANetworkGCDHelperTest.h"

#import "NANetworkGCDHelper.h"

#import "NAAsyncOCUnit.h"

@implementation NANetworkGCDHelperTest

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

- (void)testSendAsynchronousRequest
{
    STAsynchronousTestStart(test);
    NSURLRequest *req = [NANetworkGCDHelper requestTo:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    [NANetworkGCDHelper sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
        STAssertTrue(YES, @"success!!!!!");
        STAsynchronousTestDone(test);
    } errorHandler:^(NSURLResponse *resp, NSError *err) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
        STAssertTrue(NO, @"error!!!!!");
        STAsynchronousTestDone(test);
    }];
    STAsynchronousTestWait(test, 0.5);
}

- (void)testSendJSONAsynchronousRequest
{
    STAsynchronousTestStart(test);
    NSURLRequest *req = [NANetworkGCDHelper requestTo:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    [NANetworkGCDHelper sendJsonAsynchronousRequest:req jsonOption:NSJSONReadingAllowFragments returnEncoding:NSShiftJISStringEncoding returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, data);
        STAssertTrue(YES, @"success!!!!!");
        STAsynchronousTestDone(test);
    } errorHandler:^(NSURLResponse *resp, NSError *err) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
        STAssertTrue(YES, @"error!!!!!");
        STAsynchronousTestDone(test);
    }];
    STAsynchronousTestWait(test, 0.5);
}

@end
