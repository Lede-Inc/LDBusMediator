//
//  AppDelegate.m
//  LDBusMediator
//
//  Created by 庞辉 on 4/14/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import "AppDelegate.h"
#import "LDBusMediator.h"

/**
 * 用于满足配置到TabController的URL-Controller的直接share跳转
 * 任何URL-Controller均可以配置到TabController中
 * 业务端routeURL跳转时，如果URL对应的controller在tabController中，直接跳转到对应Tab
 * tip: 注意配置到tabController中的Controller所属Class不能重复
 */
static NSMutableDictionary *rootTabClassesDic = nil;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[LDBusNavigator navigator] setHookRouteBlock:^BOOL(UIViewController * _Nonnull controller, UIViewController * _Nullable baseViewController, NavigationMode routeMode) {
        UIViewController *tabController = [self isViewControllerInTabContainer:controller];
        if (tabController) {
            [[LDBusNavigator navigator] showURLController:tabController baseViewController:baseViewController routeMode:NavigationModeNone];
            return YES;
        } else {
            return NO;
        }
    }];
    // Override point for customization after application launch.
    return YES;
}

-(UIViewController *)isViewControllerInTabContainer:(UIViewController *)controller{
    if (rootTabClassesDic == nil) {
        rootTabClassesDic = [[NSMutableDictionary alloc] initWithCapacity:2];
        UIViewController *rootViewContoller = [UIApplication sharedApplication].delegate.window.rootViewController;
        if (rootViewContoller && [rootViewContoller isKindOfClass:[UITabBarController class]]) {
            NSArray *tabControllers = ((UITabBarController *)rootViewContoller).viewControllers;
            [tabControllers enumerateObjectsUsingBlock:^(UIViewController *_Nonnull viewController, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([viewController isKindOfClass:[UINavigationController class]]) {
                    viewController = [((UINavigationController *)viewController).viewControllers objectAtIndex:0];
                }

                [rootTabClassesDic setObject:viewController forKey:NSStringFromClass([viewController class])];
            }];
        }
    }

    if (rootTabClassesDic && rootTabClassesDic.count > 0) {
        NSString *controllerKey = NSStringFromClass([controller class]);
        if (controllerKey) {
            return [rootTabClassesDic objectForKey:controllerKey];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
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
