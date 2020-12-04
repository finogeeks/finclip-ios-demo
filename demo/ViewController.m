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
    [self.tableView reloadData];
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
            
    }];
}

@end
