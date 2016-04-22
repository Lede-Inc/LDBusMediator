//
//  UIViewController+NavigationTip.m
//  LDBusMediator
//
//  Created by 庞辉 on 4/22/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import "UIViewController+NavigationTip.h"
#import "LDBusMediatorTipViewController.h"


@implementation UIViewController (NavigationTip)

+(nonnull UIViewController *) paramsError{
    return [LDBusMediatorTipViewController paramsErrorTipController];
}


+(nonnull UIViewController *) notFound{
    return [LDBusMediatorTipViewController notFoundTipConctroller];
}


+(nonnull UIViewController *) notURLController{
    return [LDBusMediatorTipViewController notURLTipController];
}

@end
