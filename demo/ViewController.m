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
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
    [btn1 setTitle:@"打开绘图小程序" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor grayColor]];
    [btn1 addTarget:self action:@selector(onCanvasClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 200, 40)];
    [btn2 setTitle:@"打开官方小程序" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor grayColor]];
    [btn2 addTarget:self action:@selector(onDemoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 40)];
    [btn3 setTitle:@"我的对账单" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setBackgroundColor:[UIColor grayColor]];
    [btn3 addTarget:self action:@selector(onProfileClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
}

- (void)onCanvasClick:(id)sender
{
    NSString *appId = @"5facb3a52dcbff00017469bd";
    // 打开小程序
    [[FATClient sharedClient] startRemoteApplet:appId startParams:nil InParentViewController:self completion:^(BOOL result, NSError *error) {
        NSLog(@"result:%d---error:%@", result, error);
    }];
}

- (void)onDemoClick:(id)sender {
    
    NSString *appId = @"5fa214a29a6a7900019b5cc1";
    // 打开小程序
    [[FATClient sharedClient] startRemoteApplet:appId startParams:nil InParentViewController:self completion:^(BOOL result, NSError *error) {
        NSLog(@"result:%d---error:%@", result, error);
    }];
}

- (void)onProfileClick:(id)sender {
    
    NSString *appId = @"5fa215459a6a7900019b5cc3";
    // 打开小程序
    [[FATClient sharedClient] startRemoteApplet:appId startParams:nil InParentViewController:self completion:^(BOOL result, NSError *error) {
        NSLog(@"result:%d---error:%@", result, error);
    }];
}
@end
