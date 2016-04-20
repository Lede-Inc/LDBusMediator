//
//  ModuleAXXXItemPrt.h
//  LDBusMediator
//
//  Created by 庞辉 on 4/19/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @protocol ModuleAXXXServicePrt (model协议)
 *  ModuleA对外开放的xxxItem，将数据向外传递，或者将数据通过参数传入调用服务
 */
@protocol ModuleAXXXItemPrt <NSObject>

@required
@property(nonatomic, readwrite) NSString *__nonnull itemName;
@property(nonatomic, readwrite) int itemAge;

-(nonnull NSString *)description;


@optional
-(nonnull instancetype)initWithItemName:(nonnull NSString *)itemName
                                itemAge:(int)itemAge;



@end
