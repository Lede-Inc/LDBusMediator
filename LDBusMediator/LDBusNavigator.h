//
//  LDBusNavigator.h
//  LDBusMediator
//
//  Created by 庞辉 on 4/15/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    NavigationModeNone = 0,
    NavigationModePush,     //push a viewController in NavigationController
    NavigationModePresent,  //present a viewController in NavigationController
    NavigationModeShare     //pop to the viewController already in NavigationController or tabBarController
}NavigationMode;


/**
 * @class LDBusNavigator
 *  busMediator内在支持的的导航器
 */
@interface LDBusNavigator : NSObject

/**
 * 一个应用一个统一的navigator
 */
+(nonnull LDBusNavigator *)navigator;


/**
 * 设置通用的拦截跳转方式；
 */
-(void)setHookRouteBlock:(BOOL (^__nullable)(UIViewController *__nonnull controller, UIViewController *__nullable baseViewController, NavigationMode routeMode)) routeBlock;

/**
 * 在BaseViewController下展示URL对应的Controller
 *  @param controller   当前需要present的Controller
 *  @param baseViewController 展示的BaseViewController
 *  @param routeMode  展示的方式
 */
-(void)showURLController:(nonnull UIViewController *)controller
      baseViewController:(nullable UIViewController *)baseViewController
               routeMode:(NavigationMode)routeMode;

@end



/**
 * 外部不能调用该类别中的方法，仅供Busmediator中调用
 */
@interface LDBusNavigator (HookRouteBlock)

-(void)hookShowURLController:(nonnull UIViewController *)controller
      baseViewController:(nullable UIViewController *)baseViewController
               routeMode:(NavigationMode)routeMode;

@end
