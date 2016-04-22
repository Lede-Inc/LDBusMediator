//
//  LDBusMediatorTipViewController.m
//  LDBusMediator
//
//  Created by 庞辉 on 4/22/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import "LDBusMediatorTipViewController.h"

@interface LDBusMediatorTipViewController ()

@property (nonatomic, readwrite) BOOL isparamsError;
@property (nonatomic, readwrite) BOOL isNotURLSupport;
@property (nonatomic, readwrite) BOOL isNotFound;

@property (nonatomic, readwrite) NSString *showText;

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIButton *returnButton;

@end

@implementation LDBusMediatorTipViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        _isparamsError = NO;
        _isNotURLSupport = NO;
        _isNotFound = NO;
    }
    return self;
}

+(nonnull UIViewController *)paramsErrorTipController{
    LDBusMediatorTipViewController *controller = [[LDBusMediatorTipViewController alloc] init];
    controller.isparamsError = YES;
    return (UIViewController *)controller;
}


+(nonnull UIViewController *)notURLTipController{
    LDBusMediatorTipViewController *controller = [[LDBusMediatorTipViewController alloc] init];
    controller.isNotURLSupport = YES;
    return (UIViewController *)controller;
}

+(nonnull UIViewController *)notFoundTipConctroller{
    LDBusMediatorTipViewController *controller = [[LDBusMediatorTipViewController alloc] init];
    controller.isNotFound = YES;
    return (UIViewController *)controller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];

    _valueLabel = [[UILabel alloc] init];
    _valueLabel.font = [UIFont systemFontOfSize:16];
    _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textColor = [UIColor whiteColor];
    _valueLabel.frame = CGRectMake(10.0f, 50.0f, self.view.frame.size.width-20, self.view.frame.size.height-100.0f);
    [self.view addSubview:_valueLabel];

    _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _returnButton.layer.cornerRadius = 4.0f;
    [_returnButton setBackgroundColor:[UIColor grayColor]];
    [_returnButton addTarget:self action:@selector(didTappedReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [_returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [_returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _returnButton.frame = CGRectMake((self.view.frame.size.width-100)/2, self.view.frame.size.height-75, 100,50);
    [self.view addSubview:_returnButton];


    //show 显示
    _valueLabel.numberOfLines = [_showText componentsSeparatedByString:@"\n"].count + 1;
    _valueLabel.text = _showText;
}


-(void)showDebugTipController:(nonnull NSURL *)URL
               withParameters:(nullable NSDictionary *)parameters{
    NSString *errorString = @"";
    if (_isparamsError) {
        errorString = @"params error!!!";
    }

    if (_isNotURLSupport) {
        errorString = @"can not support return a url-based controller!!!";
    }

    if (_isNotFound) {
        errorString = @"can not found url!!!";
    }

    self.showText = [NSString stringWithFormat:@"open url error: %@\n\nurlString:\n\t%@\n\nparameters:\n%@",errorString, URL, parameters];

    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(rootViewController.presentedViewController){
        [rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [rootViewController presentViewController:self animated:YES completion:nil];
        }];
    } else {
     [rootViewController presentViewController:self animated:YES completion:nil];
    }
}


- (void)didTappedReturnButton:(UIButton *)button
{
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (self.parentViewController) {
            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
