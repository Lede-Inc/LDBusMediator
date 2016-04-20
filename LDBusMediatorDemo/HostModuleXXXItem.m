//
//  HostModuleXXXItem.m
//  LDBusMediator
//
//  Created by 庞辉 on 4/19/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import "HostModuleXXXItem.h"

@implementation HostModuleXXXItem
@synthesize itemName;
@synthesize itemAge;

-(nonnull NSString *)description{
    NSString *description = [NSString stringWithFormat:@"HostModule:itemName==%@,itemAge==%d", self.itemName, self.itemAge];
    return description;
}

@end
