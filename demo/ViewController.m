//
//  ViewController.m
//  demo
//
//  Created by 杨涛 on 2020/2/6.
//  Copyright © 2020 finogeeks. All rights reserved.
//

#import "ViewController.h"
#import <FinApplet/FinApplet.h>
#import <WechatOpenSDK/WXApi.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *appletList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_loadData];
    
    [self p_initSubViews];
}

- (void)p_initSubViews {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    headerView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)p_loadData {
    // 配置小程序列表
    self.appletList = [[NSMutableArray alloc] init];
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    NSString *appName = [bundleId componentsSeparatedByString:@"."].lastObject;
    if (![appName isEqualToString:@""]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:appName ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in array) {
            [self.appletList addObject:dict];
        }
    }
    [self.tableView reloadData];
}

// 原生向小程序发送的事件
- (void)sendCustomEvent {
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
            [[FATClient sharedClient].nativeViewManager sendCustomEventWithDetail:@{@"timestamp":@(timestamp)} completion:^(id result, NSError *error) {
                NSLog(@"sendCustomEventW:%@", error);
            }];
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appletList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    NSDictionary *dict = self.appletList[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.appletList[indexPath.row];
    NSString *appId = dict[@"appId"];
    NSDictionary *startParams = dict[@"startParams"];
    
    [[FATClient sharedClient] startRemoteApplet:appId startParams:startParams InParentViewController:self completion:^(BOOL result, NSError *error) {
        if ([appId isEqualToString:@"60c5bbf99e094f00015079ee"]) {
            [self sendCustomEvent];
        }
    }];
}

@end
