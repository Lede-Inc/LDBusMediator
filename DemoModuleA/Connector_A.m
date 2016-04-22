//
//  Connector_A.m
//  LDBusMediator
//
//  Created by 庞辉 on 4/19/16.
//  Copyright © 2016 casa. All rights reserved.
//


//每个业务组件的connector依赖Busmediator部分
#import "Connector_A.h"
#import "LDBusMediator.h"

//每个业务组件依赖它对外开放的协议头文件
#import "ModuleAXXXServicePrt.h"

//connetor依赖业务组件具体实现
#import "DemoModuleADetailViewController.h"
#import "ModuleAXXXItem.h"


/**
 * 说明：对外开放的服务协议可以不在connector中实现，可以放到其他具体的服务实现类中，只需要在连接的时候根据协议名称返回服务实现类的实例即可；
 */
@interface Connector_A () <ModuleAXXXServicePrt>{
}

@end


@implementation Connector_A

#pragma mark - register connector

/**
 * 每个组件的实现必须自己通过load完成挂载；load只需要在挂载connector的时候完成当前connecotor的初始化，挂载量、挂载消耗、挂载所耗内存都在可控范围内；
 */
+(void)load{
    @autoreleasepool{
        [LDBusMediator registerConnector:[self sharedConnector]];
    }
}


+(nonnull Connector_A *)sharedConnector{
    static Connector_A *_sharedConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConnector = [[Connector_A alloc] init];
    });

    return _sharedConnector;
}


#pragma mark - LDBusConnectorPrt 

/**
 * (1)当调用方需要通过判断URL是否可导航显示界面的时候，告诉调用方该组件实现是否可导航URL；可导航，返回YES，否则返回NO；
 * (2)这个方法跟connectToOpenURL:params配套实现；如果不实现，则调用方无法判断某个URL是否可导航；
 */
-(BOOL)canOpenURL:(nonnull NSURL *)URL{
    if ([URL.host isEqualToString:@"ADetail"]) {
        return YES;
    }

    return NO;
}


/**
 * (1)通过connector向busMediator挂载可导航的URL，具体解析URL的host还是path，由connector自行决定；
 * (2)如果URL在本业务组件可导航，则从params获取参数，实例化对应的viewController进行返回；如果参数错误，则返回一个错误提示的[UIViewController paramsError]; 如果不需要中间件进行present展示，则返回一个[UIViewController notURLController],表示当前可处理；如果无法处理，返回nil，交由其他组件处理；
 * (3)需要在connector中对参数进行验证，不同的参数调用生成不同的ViewController实例；也可以通过参数决定是否自行展示，如果自行展示，则用户定义的展示方式无效；
 * (4)如果挂接的url较多，这里的代码比较长，可以将处理方法分发到当前connector的category中；
 */
- (nullable UIViewController *)connectToOpenURL:(nonnull NSURL *)URL params:(nullable NSDictionary *)params{
    //处理scheme://ADetail的方式
    // tip: url较少的时候可以通过if-else去处理，如果url较多，可以自己维护一个url和ViewController的map，加快遍历查找，生成viewController；
    if ([URL.host isEqualToString:@"ADetail"]) {
        DemoModuleADetailViewController *viewController = [[DemoModuleADetailViewController alloc] init];
        if (params[@"key"] != nil) {
            viewController.valueLabel.text = params[@"key"];
        } else if(params[@"image"]) {
            id imageObj = params[@"image"];
            if (imageObj && [imageObj isKindOfClass:[UIImage class]]) {
                viewController.valueLabel.text = @"this is image";
                viewController.imageView.image = params[@"image"];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewController animated:YES completion:nil];
                return [UIViewController notURLController];
            } else {
                viewController.valueLabel.text = @"no image";
                viewController.imageView.image = [UIImage imageNamed:@"noImage"];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewController animated:YES completion:nil];
                return [UIViewController notURLController];
            }
        } else {
            // nothing to do
        }
        return viewController;
    }


    else {
        // nothing to to
    }

    return nil;
}


/**
 * （1)通过connector向BusMediator挂接可处理的Protocol，根据Protocol获取当前组件中可处理protocol的服务实例；
 *  (2)具体服务协议的实现可放到其他类实现文件中，只需要在当前connetor中引用，返回一个服务实例即可；
 *  (3)如果不能处理，返回一个nil；
 */
- (nullable id)connectToHandleProtocol:(nonnull Protocol *)servicePrt{
    if (servicePrt == @protocol(ModuleAXXXServicePrt)) {
        return [[self class] sharedConnector];
    }
    return nil;
}


#pragma mark - ModuleAServicePrt

/**
 * 下面三个接口都是组件A向外提供服务的协议实现，当前的服务接口都是同步的，如果是异步回调要注意在服务显示中对多线程进行兼容处理（主要是Block的对应）；
 */
-(void)moduleA_showAlertWithMessage:(nonnull NSString *)message
                       cancelAction:(void(^__nullable)(NSDictionary *__nonnull info))cancelAction
                      confirmAction:(void(^__nullable)(NSDictionary *__nonnull info))confirmAction{
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelAction) {
            cancelAction(@{@"alertAction":action});
        }
    }];

    UIAlertAction *confirmAlertAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmAction) {
            confirmAction(@{@"alertAction":action});
        }
    }];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"alert from Module A" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAlertAction];
    [alertController addAction:confirmAlertAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}


-(nonnull id<ModuleAXXXItemPrt>)moduleA_getItemWithName:(nonnull NSString *)name
                                                    age:(int)age{
    ModuleAXXXItem *item = [[ModuleAXXXItem alloc] initWithItemName:name itemAge:age];
    return item;
}


-(void)moduleA_deliveAprotocolModel:(nonnull id<ModuleAXXXItemPrt>)item{
    NSString *showText =[item description];
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAlertAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:nil];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Module A展示外部传入" message:showText preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAlertAction];
    [alertController addAction:confirmAlertAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}


@end
