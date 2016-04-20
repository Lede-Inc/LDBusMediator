//
//  LDBusConnectorPtr.h
//  LDBusMediator
//
//  Created by 庞辉 on 4/14/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  LDBusConnectorPtr挂接点协议
 *
 *  每个业务模块在对外开放的挂接点实现这个协议，以便被BusMediator发现和调度
 */
@class UIViewController;
@protocol LDBusConnectorPrt <NSObject>


@optional

/**
 * 业务模块挂接中间件，注册自己能够处理的url，完成url的跳转；
 * 如果url跳转需要回传数据，则传入实现了数据接收的调用者；
 *  @param url          跳转到的URL，通常为 ntescaipiao://connector/relativePath
 *  @param params       伴随url的的调用参数
 *  @param responseDelg url回调的响应对象
 *  @return (1)nil 表示不能处理，（2）UIViewController的实例，自行处理present （3）UIViewController的派生实例，交给中间件present
 */
- (UIViewController *)connectToOpenURL:(NSURL *)URL params:(NSDictionary *)params;


/**
 * 业务模块挂接中间件，注册自己提供的service，实现服务接口的调用；
 * 
 * 通过protocol协议找到组件中对应的服务实现，生成一个服务单例；
 * 传递给调用者进行protocol接口中属性和方法的调用；
 */
- (id)connectToHandleProtocol:(Protocol *)servicePrt;



@end

