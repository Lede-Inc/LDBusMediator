//
//  LDBusMediatorTipViewController.h
//  LDBusMediator
//
//  Created by 庞辉 on 4/22/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDBusMediatorTipViewController : UIViewController

@property (nonatomic, readonly) BOOL isparamsError;
@property (nonatomic, readonly) BOOL isNotURLSupport;
@property (nonatomic, readonly) BOOL isNotFound;

+(nonnull UIViewController *)paramsErrorTipController;

+(nonnull UIViewController *)notURLTipController;

+(nonnull UIViewController *)notFoundTipConctroller;

-(void)showDebugTipController:(nonnull NSURL *)URL
               withParameters:(nullable NSDictionary *)parameters;

@end
