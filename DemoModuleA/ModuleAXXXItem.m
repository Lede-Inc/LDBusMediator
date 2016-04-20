//
//  ModuleAXXXItem.m
//  LDBusMediator
//
//  Created by 庞辉 on 4/19/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import "ModuleAXXXItem.h"

/**
 * 注意：协议对象中对协议中定义的property需要提供setter或getter方法；其实就是协议中定义setter和getter方法，必须在协议对象中来实现；
 */
@implementation ModuleAXXXItem
@synthesize itemName = _itemName;
@synthesize itemAge = _itemAge;


-(nonnull instancetype)initWithItemName:(nonnull NSString *)itemName
                                itemAge:(int)itemAge{
    self = [self init];
    if (self) {
        self.itemName = itemName;
        self.itemAge = itemAge;
    }
    return self;
}


-(nonnull NSString *)description{
    NSString *description = [NSString stringWithFormat:@"MduleA:itemName==%@,itemAge==%d", self.itemName, self.itemAge];
    return description;
}

@end
