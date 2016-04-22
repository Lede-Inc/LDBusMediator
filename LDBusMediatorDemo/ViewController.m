//
//  ViewController.m
//  LDBusMediator
//
//  Created by 庞辉 on 4/19/16.
//  Copyright © 2016 casa. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LayoutMethods.h"

#import "LDBusMediator.h"
#import "ModuleAXXXServicePrt.h"
#import "HostModuleXXXItem.h"

NSString * const kCellIdentifier = @"kCellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView fill];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //LDBusMediator Call
    if (indexPath.row == 0) {
        //presentViewController
        [LDBusMediator routeURL:[NSURL URLWithString:@"ntescaipiao://ADetail11"] withParameters:@{kLDRouteModeKey:@(NavigationModePresent)}];
    }

    if (indexPath.row == 1) {
        if([LDBusMediator canRouteURL:[NSURL URLWithString:@"ntescaipiao://ADetail"]]){
            [LDBusMediator routeURL:[NSURL URLWithString:@"ntescaipiao://ADetail"]];
        }
    }

    if (indexPath.row == 2) {
        [LDBusMediator routeURL:[NSURL URLWithString:@"ntescaipiao://ADetail"] withParameters:@{@"image":[UIImage imageNamed:@"image"]}];
    }

    if (indexPath.row == 3) {
        [LDBusMediator routeURL:[NSURL URLWithString:@"ntescaipiao://ADetail"] withParameters:@{@"image":@""}];
    }

    if (indexPath.row == 4) {
        [[LDBusMediator serviceForProtocol:@protocol(ModuleAXXXServicePrt)] moduleA_showAlertWithMessage:@"casa" cancelAction:nil confirmAction:^(NSDictionary *info) {
            NSLog(@"%@", info);
        }];
    }

    if(indexPath.row == 5){
        id<ModuleAXXXItemPrt> item = [[LDBusMediator serviceForProtocol:@protocol(ModuleAXXXServicePrt)] moduleA_getItemWithName:@"philonpang" age:30];
        [[LDBusMediator serviceForProtocol:@protocol(ModuleAXXXServicePrt)] moduleA_showAlertWithMessage:[item description] cancelAction:nil confirmAction:nil];
    }

    if (indexPath.row == 6) {
        HostModuleXXXItem *item = [[HostModuleXXXItem alloc] init];
        item.itemName = @"hostModule";
        item.itemAge = 9000;
        [[LDBusMediator serviceForProtocol:@protocol(ModuleAXXXServicePrt)] moduleA_deliveAprotocolModel:item];
    }

    if (indexPath.row == 7) {
        UIViewController *controller = [LDBusMediator viewControllerForURL:[NSURL URLWithString:@"ntescaipiao://ADetail"]];
        if (controller) {
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - getters and setters
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = @[@"present detail view controller", @"push detail view controller", @"present image", @"present image when error", @"service: show alert", @"service:get protcol model", @"service: set protocol model", @"get url controller"];
    }
    return _dataSource;
}
@end
