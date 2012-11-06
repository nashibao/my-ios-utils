//
//  AppDelegate.m
//  na_ios_test
//
//  Created by nashibao on 2012/10/29.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//

#import "AppDelegate.h"

#import "TestFRCTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    TestFRCTableViewController *masterViewController = [[TestFRCTableViewController alloc] initWithNibName:@"TestFRCTableViewController" bundle:nil];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
//    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
