//
//  Connector_A.h
//  LDBusMediator
//
//  Created by 庞辉 on 4/19/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDBusConnectorPrt.h"


/**
 * 业务组件挂接点说明：
 *
 * (1)每个业务组件的实现自定义一个挂接点，挂接点遵循中间件规定的connector协议；在挂接点需要连接上可导航的url，协议的服务承载实例；
 *
 * (2)通过挂接点＋协议的方式，组件的实现部分不用对外披露任何头文件；
 */


/**
 * @class Connector_A 
 *  业务组件A的connector
 */
@interface Connector_A : NSObject <LDBusConnectorPrt>

@end
