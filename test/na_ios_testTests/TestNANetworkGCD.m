//
//  TestNANetworkGCD.m
//  na_ios_test
//
//  Created by nashibao on 2012/10/11.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "TestNANetworkGCD.h"

#import "NANetworkGCDHelper.h"

@implementation TestNANetworkGCD

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

- (void)test
{
    NSURLRequest *req = [NANetworkGCDHelper requestTo:@"http://google.com" query:@{} protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    STAssertTrue([req isKindOfClass:[NSURLRequest class]], @"not NSURLRequest class");
}

@end
