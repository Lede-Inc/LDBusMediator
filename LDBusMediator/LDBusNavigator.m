//
//  LDBusNavigator.m
//  LDBusMediator
//
//  Created by 庞辉 on 4/15/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import "LDBusNavigator.h"


@interface LDBusNavigator (){
    BOOL (^_routeBlock)(UIViewController * controller, UIViewController * baseViewController, NavigationMode routeMode);
}

@end


@implementation LDBusNavigator

+(LDBusNavigator *)navigator{
    static LDBusNavigator *rootNavigator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (rootNavigator == nil) {
            rootNavigator = [[LDBusNavigator alloc] init];
        }
    });

    return rootNavigator;
}

-(instancetype) init{
    self = [super init];
    if (self) {
        _routeBlock = nil;
    }
    return self;
}


/**
 * 设置通用的拦截跳转方式；
 */
-(void)setHookRouteBlock:(BOOL (^)(UIViewController *controller, UIViewController *baseViewController, NavigationMode routeMode)) routeBlock{
    _routeBlock  = routeBlock;
}


-(void)showURLController:(nonnull UIViewController *)controller
      baseViewController:(nullable UIViewController *)baseViewController
               routeMode:(NavigationMode)routeMode{
    if (routeMode == NavigationModeNone) {
        routeMode = NavigationModePush;
    }
    
    switch (routeMode) {
        case NavigationModePush:
            [self pushViewController:controller baseViewController:baseViewController];
            break;

        case NavigationModeShare:
            [self popToSharedViewController:controller baseViewController:baseViewController];
            break;

        case NavigationModePresent:
            [self presentedViewController:controller baseViewController:baseViewController];
            break;

        default:
            break;
    }

}


-(void)pushViewController:(nonnull UIViewController *)controller
       baseViewController:(nullable UIViewController *)baseViewController{
    if (!baseViewController) {
        baseViewController = [self topmostViewController];
    }
    if(baseViewController == nil) return;

    if ([baseViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)baseViewController pushViewController:controller animated:YES];
    }else if(baseViewController.navigationController){
        [baseViewController.navigationController pushViewController:controller animated:YES];
    }else{
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [baseViewController presentViewController:navController animated:YES completion:NULL];
    }
}


-(void)popToSharedViewController:(nonnull UIViewController *)controller
              baseViewController:(nullable UIViewController *)baseViewController{
    UIViewController *rootViewContoller = [UIApplication sharedApplication].delegate.window.rootViewController;
    if(!rootViewContoller) return;

    if([rootViewContoller isKindOfClass:[UITabBarController class]]){
        UITabBarController *rootTabController = (UITabBarController *)rootViewContoller;
        NSArray *viewControllers = rootTabController.viewControllers;
        NSInteger selectIndex = -1;
        for(int i = 0; i < viewControllers.count; i++){
            id tmpController = viewControllers[i];
            if([tmpController isKindOfClass:[UINavigationController class]]){
                if([self popToSharedViewController:controller InNavigationController:(UINavigationController *)tmpController]){
                    selectIndex = i;
                    break;
                }
            } else {
                if(tmpController == controller){
                    selectIndex = i;
                    break;
                }
            }
        }//for

        //选中变化的ViewController
        if(selectIndex != -1 && selectIndex != rootTabController.selectedIndex){
            if (rootTabController.delegate && [rootTabController.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
                [rootTabController.delegate tabBarController:rootTabController shouldSelectViewController:rootTabController.viewControllers[selectIndex]];
            }
            rootTabController.selectedIndex = selectIndex;
        }
    } else if([rootViewContoller isKindOfClass:[UINavigationController class]]){
        [self popToSharedViewController:controller InNavigationController:(UINavigationController *)rootViewContoller];
    } else {
        //当前已经在最上面一层了
        if(controller != rootViewContoller){
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
            [rootViewContoller presentViewController:navController animated:YES completion:NULL];
        }
    }
}


-(void)presentedViewController:(nonnull UIViewController *)controller
            baseViewController:(nullable UIViewController *)baseViewController{
    if(baseViewController == nil){
        baseViewController = [self topmostViewController];
    }

    if ([baseViewController isKindOfClass:[UITabBarController class]] ||
        [baseViewController isKindOfClass:[UINavigationController class]]) {
        return;
    }

    if (baseViewController.presentedViewController) {
        [baseViewController dismissViewControllerAnimated:NO completion:nil];
    }

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [baseViewController presentViewController:navController animated:YES completion:NULL];
}


-(BOOL)popToSharedViewController:(nonnull UIViewController *)controller InNavigationController:(nonnull UINavigationController *)navigationController{
    NSInteger count = navigationController.viewControllers.count;
    if(count == 0) return NO;

    BOOL success = NO;
    for (NSInteger i = count-1; i >= 0; i--) {
        UIViewController *tmpViewController = navigationController.viewControllers[i];
        if (tmpViewController.presentedViewController) {
            if ([tmpViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                if ([self popToSharedViewController:controller InNavigationController:(UINavigationController *)tmpViewController.presentedViewController]) {
                    [navigationController popToViewController:tmpViewController animated:NO];
                    success = YES;
                    break;
                }

            } else {
                if (tmpViewController.presentedViewController == controller) {
                    [navigationController popToViewController:tmpViewController animated:NO];
                    success = YES;
                    break;
                }
            }
        } else {
            if (tmpViewController == controller) {
                [navigationController popToViewController:tmpViewController animated:NO];
                success = YES;
                break;
            }
        }
    }

    return success;
}

- (UIViewController *)topmostViewController
{
    //rootViewController需要是TabBarController,排除正在显示FirstPage的情况
    UIViewController *rootViewContoller = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (!rootViewContoller || (![rootViewContoller isKindOfClass:[UITabBarController class]] && ![rootViewContoller isKindOfClass:[UINavigationController class]])) {
        return nil;
    }

    //当前显示哪个tab页
    UINavigationController *rootNavController = nil;
    if([rootViewContoller isKindOfClass:[UITabBarController class]]){
        rootNavController = (UINavigationController *) [(UITabBarController*)rootViewContoller selectedViewController];
    }else if([rootViewContoller isKindOfClass:[UINavigationController class]]){
        rootNavController = (UINavigationController *)rootViewContoller;
    } else {
        return rootViewContoller;
    }

    if (!rootNavController) {
        return nil;
    }

    UINavigationController *navController = rootNavController;
    while ([navController isKindOfClass:[UINavigationController class]]) {
        UIViewController *topViewController = [navController topViewController];
        if ([topViewController isKindOfClass:[UINavigationController class]]) { //顶层是个导航控制器，继续循环
            navController = (UINavigationController *) topViewController;
        } else {
            //是否有弹出presentViewControllr;
            UIViewController *presentedViewController = topViewController.presentedViewController;
            while (presentedViewController) {
                topViewController = presentedViewController;
                if ([topViewController isKindOfClass:[UINavigationController class]]) {
                    break;
                } else {
                    presentedViewController = topViewController.presentedViewController;
                }
            }
            navController = (UINavigationController *) topViewController;
        }
    }
    return (UIViewController *) navController;
}

@end


@implementation LDBusNavigator (HookRouteBlock)


-(void)hookShowURLController:(nonnull UIViewController *)controller
          baseViewController:(nullable UIViewController *)baseViewController
                   routeMode:(NavigationMode)routeMode{
    BOOL success = NO;
    if(_routeBlock){
        success = _routeBlock(controller, baseViewController, routeMode);
    }

    if (!success) {
        [self showURLController:controller baseViewController:baseViewController routeMode:routeMode];
    }
}

@end
