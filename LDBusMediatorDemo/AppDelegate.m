//
//  AppDelegate.m
//  LDBusMediator
//
//  Created by 庞辉 on 4/14/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import "AppDelegate.h"
#import "LDBusMediator.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UITabBarController *rootTabBarController = [[UITabBarController alloc] init];

    //navTab1
    UINavigationController *navTab1 = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];

    //navTab2
    UIViewController *viewController2 = [LDBusMediator viewControllerForURL:[NSURL URLWithString:@"productScheme://ADetail"]];
    viewController2.title = @"navTab2";
    viewController2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:0];
    UINavigationController *navTab2 = [[UINavigationController alloc] initWithRootViewController:viewController2];

    rootTabBarController.viewControllers = @[navTab1, navTab2];


    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = rootTabBarController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [LDBusMediator routeURL:url withParameters:options];
}

@end
