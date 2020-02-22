//
//  ViewController.m
//  demo
//
//  Created by 杨涛 on 2020/2/6.
//  Copyright © 2020 finogeeks. All rights reserved.
//

#import "ViewController.h"
#import <FinApplet/FinApplet.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
    [btn setTitle:@"打开小程序" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onTestClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)onTestClick:(id)sender {
    
    NSString *appId = @"5e3c0950188211000141e9ac";
    // 打开小程序
    [[FATClient sharedClient] startRemoteApplet:appId startParams:nil InParentViewController:self completion:^(BOOL result, NSError *error) {
        NSLog(@"result:%d---error:%@", result, error);
    }];
}

@end
