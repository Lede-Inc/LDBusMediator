//
//  LDMediator.m
//  LDBusMediator
//
//  Created by 庞辉 on 4/8/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import "LDBusMediator.h"
#import "LDBusNavigator.h"
#import "LDBusConnectorPrt.h"

NSString* const kLDRouteViewControllerKey = @"LDRouteViewController";
NSString *__nonnull const kLDRouteModeKey = @"kLDRouteType";

//全部保存各个模块的connector实例
static NSMutableDictionary *g_connectorMap = nil;


@implementation LDBusMediator

#pragma mark - 向总控制中心注册挂接点

+(void)registerConnector:(nullable id<LDBusConnectorPrt>)connector{
    if (!connector || ![connector conformsToProtocol:@protocol(LDBusConnectorPrt)]) {
        return;
    }

    if (g_connectorMap == nil){
        g_connectorMap = [[NSMutableDictionary alloc] initWithCapacity:5];
    }

    NSString *connectorClsStr = NSStringFromClass([connector class]);
    if ([g_connectorMap objectForKey:connectorClsStr] == nil) {
        [g_connectorMap setObject:connector forKey:connectorClsStr];
    }
}


#pragma mark - 页面跳转接口

+(BOOL)routeURL:(nullable NSURL *)URL{
    return [self routeURL:URL withParameters:nil];
}


+(BOOL)routeURL:(nullable NSURL *)URL withParameters:(nullable NSDictionary *)params{
    if(!URL || !g_connectorMap || g_connectorMap.count <= 0) return NO;

    BOOL success = NO;
    NSDictionary *userParams = [self userParametersWithURL:URL andParameters:params];
    for(NSString *connectorKey in g_connectorMap.allKeys){
        id<LDBusConnectorPrt> connector = [g_connectorMap objectForKey:connectorKey];
        if([connector respondsToSelector:@selector(connectToOpenURL:params:)]){
            id returnObj = [connector connectToOpenURL:URL params:userParams];
            if(returnObj && ([returnObj class] == [UIViewController class] || [returnObj isKindOfClass:[UIViewController class]])){
                if([returnObj class] != [UIViewController class]){
                    [LDBusNavigator showURLController:returnObj baseViewController:params[kLDRouteViewControllerKey] routeMode:params[kLDRouteModeKey]?[params[kLDRouteModeKey] intValue]:NavigationModePush];
                }
                success = YES;
                break;
            }
        }
    }

    return success;
}


+(nullable UIViewController *)viewControllerForURL:(nullable NSURL *)URL{
    return [self viewControllerForURL:URL withParameters:nil];
}


+(nullable UIViewController *)viewControllerForURL:(nullable NSURL *)URL withParameters:(nullable NSDictionary *)params{
    if(!URL || !g_connectorMap || g_connectorMap.count <= 0) return nil;

    UIViewController *returnObj = nil;
    NSDictionary *userParams = [self userParametersWithURL:URL andParameters:params];
    for(NSString *connectorKey in g_connectorMap.allKeys){
        id<LDBusConnectorPrt> connector = [g_connectorMap objectForKey:connectorKey];
        if([connector respondsToSelector:@selector(connectToOpenURL:params:)]){
            returnObj = [connector connectToOpenURL:URL params:userParams];
            if(returnObj && ([returnObj class] == [UIViewController class] || [returnObj isKindOfClass:[UIViewController class]])){
                break;
            }
        }
    }

    return returnObj;
}


/**
 * 从url获取query参数放入到参数列表中
 */
+(NSDictionary *)userParametersWithURL:(nullable NSURL *)URL andParameters:(nullable NSDictionary *)params{
    NSArray *pairs = [URL.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *userParams = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *key = [kv objectAtIndex:0];
            NSString *value = [self URLDecodedString:[kv objectAtIndex:1]];
            [userParams setObject:value forKey:key];
        }
    }
    [userParams addEntriesFromDictionary:params];
    return [NSDictionary dictionaryWithDictionary:userParams];
}


/**
 * 对url的value部分进行urlDecoding
 */
+(NSString *)URLDecodedString:(NSString *)urlString
{
    NSString *result = urlString;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (__bridge CFStringRef)urlString,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8);
#else
    result = [urlString stringByRemovingPercentEncoding];
#endif
    return result;
}


#pragma mark - 服务调用接口

+(nullable id)serviceForProtocol:(nullable Protocol *)protocol{
    if(!protocol || !g_connectorMap || g_connectorMap.count <= 0) return nil;

    id returnServiceImp = nil;
    for(NSString *connectorKey in g_connectorMap.allKeys){
        id<LDBusConnectorPrt> connector = [g_connectorMap objectForKey:connectorKey];
        if([connector respondsToSelector:@selector(connectToHandleProtocol:)]){
            returnServiceImp = [connector connectToHandleProtocol:protocol];
            if(returnServiceImp){
                break;
            }
        }
    }

    return returnServiceImp;
}

@end
