//
//  MyTest.m
//  na_ios_test
//
//  Created by nashibao on 2012/10/11.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "MyTest.h"

#import "NANetworkGCDHelper.h"

@implementation MyTest

- (void)testGCD {
    [self prepare];
    
    NSURLRequest *req = [NANetworkGCDHelper requestTo:@"https://www.google.co.jp/" query:@{} protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    [NANetworkGCDHelper sendAsynchronousRequest:req
                                 returnEncoding:NSShiftJISStringEncoding
                                     returnMain:YES successHandler:^(NSURLResponse *resp, id data) {
                                         GHTestLog(@"success: %@", data);
                                         [self notify:kGHUnitWaitStatusSuccess];
                                     } errorHandler:^(NSURLResponse *resp, NSError *err) {
                                         GHTestLog(@"error: %@", err);
                                         [self notify:kGHUnitWaitStatusFailure];
                                     }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}
@end
