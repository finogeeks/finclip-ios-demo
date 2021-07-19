//
//  ViewController.m
//  demo
//
//  Created by 杨涛 on 2020/2/6.
//  Copyright © 2020 finogeeks. All rights reserved.
//

#import "ViewController.h"
#import <FinApplet/FinApplet.h>

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

- (void)p_initSubViews
{
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

- (void)p_loadData
{
    NSDictionary *startParams = nil;
    self.appletList = [[NSMutableArray alloc] init];

    [self.appletList addObject:@{@"appId":@"5facb3a52dcbff00017469bd",@"title":@"绘图小程序"}];
    [self.appletList addObject:@{@"appId":@"5fa214a29a6a7900019b5cc1",@"title":@"官方示例小程序"}];
    [self.appletList addObject:@{@"appId":@"5fa215459a6a7900019b5cc3",@"title":@"对账单"}];
    // FAT接口测试小程序
    [self.appletList addObject:@{@"appId":@"5fc8934aefb8c600019e9747",@"title":@"自定义小程序API示例"}];
    
    startParams = @{
                    @"path" : @"/pages/webview/webview"
                    };
    [self.appletList addObject:@{@"appId":@"5fc8934aefb8c600019e9747",@"title":@"自定义H5 API示例", @"startParams":startParams}];
    [self.appletList addObject:@{@"appId":@"60c5bbf99e094f00015079ee",@"title":@"原生向小程序发送事件"}];
    //登录授权示例需要原生App注入相关方法
    [self registAppletLoginApi];
    [self.appletList addObject:@{@"appId":@"60f051ea525ea10001c0bd22",@"title":@"小程序登录授权示例"}];
    [self.tableView reloadData];
}

- (void)sendCustomEvent
{
    if (@available(iOS 10.0, *)) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
            [[FATClient sharedClient].nativeViewManager sendCustomEventWithDetail:@{@"timestamp":@(timestamp)} completion:^(id result, NSError *error) {
                NSLog(@"sendCustomEventW:%@", error);
            }];
        }];
    }
}

- (void)registAppletLoginApi {
    //注入获取用户信息
    [[FATClient sharedClient]registerExtensionApi:@"getUserProfile" handle:^(id param, FATExtensionApiCallback callback) {
        NSDictionary *userInfo = @{@"nickName":@"张三",@"avatarUrl":@"",@"gender":@1,@"country":@"中国",@"province":@"广东省",@"city":@"深圳",@"language":@"zh_CN"};
        NSDictionary *resDic = @{@"userInfo":userInfo};
        callback(FATExtensionCodeSuccess,resDic);
    }];
    
    //注入登录方法
    [[FATClient sharedClient]registerExtensionApi:@"login" handle:^(id param, FATExtensionApiCallback callback) {
        //回调给小程序结果
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"是否同意授权登录？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            callback(FATExtensionCodeSuccess,@{@"desc":@"登录成功"});
            
        }];
        [alertVC addAction:agreeAction];
        UIAlertAction *refuseAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            callback(FATExtensionCodeSuccess,@{@"desc":@"登录失败"});
        }];
        [alertVC addAction:refuseAction];
        if (self.presentedViewController) {
            [self.presentedViewController presentViewController:alertVC animated:YES completion:^{
                        
            }];
        } else {
            [self presentViewController:alertVC animated:YES completion:^{
                        
            }];
        }
        
        

    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appletList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    NSDictionary *dict = self.appletList[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
