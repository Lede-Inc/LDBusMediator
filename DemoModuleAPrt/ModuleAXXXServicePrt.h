//
//  ModuleAServicePrt.h
//  LDBusMediator
//
//  Created by 庞辉 on 4/19/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleAXXXItemPrt.h"

/**
 * ModeuleA 协议说明：
 * (1)每个业务组件中的协议部分有两种：一种是服务协议，其他组件可以通过Mediator拿到对外开放的服务实例调用服务协议；一种是Model协议，服务协议中的接口可以给其他组件一个协议化对象,其他组件也可以组装一个协议化对象通过参数传入；
 *
 * (2)为了防止不同的组件协议重名，服务协议的命名为“组件前缀＋服务名字＋ServicePrt.h”;Model协议的命名为“组件前缀＋Model名字＋ItemPrt.h”;(ServicePrt和ItemPrt只是建议，通常情况下遵守，特殊情况灵活对待)
 *
 * (3)业务组件的协议集合是根据其他组件调用需求抽象而出，一般和业务组件实现一一对应；特殊情况遇到Account协议对应CPAccount组件和HYGAccount组件两个实现，从协议命名上可以灵活对待，对于业务组件来说只依赖Account协议集合，具体需要哪个实现，则需要在Podfile中引入CPAccount或者HYGAccount；
 *
 * (4)为了方便业务组件实现和协议集合的版本对应，需要保证协议集合的大版本（如x.y）和业务组件的大版本（如x.y.z）中的x保持一致；协议集合中一般没有补丁版本的迭代，当其他业务组件调用需要增加接口进行兼容版本升级（y+1）,减少或者修改接口则需要协议集合和业务组件中的x同时＋1（x+1）； 如果自身业务组件升级不能影响对外协议接口的调用，升级版本主要为补丁版本迭代（z＋1）或 兼容版本升级（y＋1)；
 * 
 * (5)组件协议集合 单独通过一个Git地址进行管理，单独配置podspec，单独通过协议的版本仓库进行管理；所有的协议集合的git统一放到Git的一个组中进行管理；
 */


/**
 * @protocol ModuleAXXXServicePrt (服务协议)
 *  ModuleA对外开放的xxxService，向外提供XXX服务，所有接口需要require实现
 */
@protocol  ModuleAXXXServicePrt <NSObject>

@required
//服务接口1: 传入Message显示一个alert，并提供cancel和confirm的回调，这个例子是同步回调
//如果是异步回调，有实现这个接口的Impl自己去控制，保证多线程安全
-(void)moduleA_showAlertWithMessage:(nonnull NSString *)message
                       cancelAction:(void(^__nullable)(NSDictionary *__nonnull info))cancelAction
                      confirmAction:(void(^__nullable)(NSDictionary *__nonnull info))confirmAction;


//服务接口2: 提供外部组件一个协议化对象
-(nonnull id<ModuleAXXXItemPrt>)moduleA_getItemWithName:(nonnull NSString *)name
                                                    age:(int)age;


//服务接口3: 外部组件调用服务传入一个协议化对象
-(void)moduleA_deliveAprotocolModel:(nonnull id<ModuleAXXXItemPrt>)item;

@end
