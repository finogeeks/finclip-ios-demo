//
//  FinStartAppletViewController.m
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/29.
//

#import "FinStartAppletViewController.h"

@interface FinStartAppletViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FinStartAppletViewController

static NSString *cellID = @"cellid";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = @[
        @{@"title" : @"普通打开小程序", @"class" : @"FinNormalStartViewController"},
        @{@"title" : @"扫码打开小程序", @"class" : @"FinScanStartViewController"},
    ].mutableCopy;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    UIViewController *vc = [NSClassFromString(dic[@"class"]) new];
    vc.title = dic[@"title"];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
