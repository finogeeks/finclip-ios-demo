//
//  FinDelegateViewController.m
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/30.
//

#import "FinDelegateViewController.h"
#import <FinApplet/FinApplet.h>

@interface FinDelegateViewController ()<FATAppletLifeCycleDelegate>

@end

@implementation FinDelegateViewController

- (instancetype)init {
    if (self = [super init]) {
        //设置FATAppletLifeCycleDelegate代理
        [FATClient sharedClient].lifeCycleDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    [button setTitle: NSLocalizedString(@"打开小程序", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.center = self.view.center;

}

- (void)click {
    FATAppletRequest *request = [[FATAppletRequest alloc] init];
    request.appletId = @"5f72e3559a6a7900019b5baa";//微信官方小程序

    [[FATClient sharedClient] startAppletWithRequest:request InParentViewController:self completion:nil closeCompletion:nil];
}

#pragma mark 小程序生命周期 ------------------------------
/**
 小程序打开完成的事件
 @param appletInfo 小程序info
 @param error 错误对象
 */
- (void)appletInfo:(FATAppletInfo *)appletInfo didOpenCompletion:(NSError *)error {
    NSLog(@"小程序打开完成的事件");
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 小程序关闭完成的事件
 @param appletInfo 小程序info
 @param error 错误对象
 */
- (void)appletInfo:(FATAppletInfo *)appletInfo didCloseCompletion:(NSError *)error {
    NSLog(@"小程序关闭完成的事件");
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 小程序初始化完成，冷启动时首页显示出来的事件
 @param appletInfo 小程序info
 @param error 错误对象
 */
- (void)appletInfo:(FATAppletInfo *)appletInfo initCompletion:(NSError *)error {
    NSLog(@"小程序初始化完成");
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 小程序进入活跃状态的事件
 @param appletInfo 小程序info
 @param error 错误对象
 */
- (void)appletInfo:(FATAppletInfo *)appletInfo didActive:(NSError *)error {
    NSLog(@"小程序进入活跃状态的事件");
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 小程序进入非活跃状态的事件
 @param appletInfo 小程序info
 @param error 错误对象
 */
- (void)appletInfo:(FATAppletInfo *)appletInfo resignActive:(NSError *)error {
    NSLog(@"小程序进入非活跃状态的事件");
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 小程序出错的事件
 @param appletInfo 小程序info
 @param error 错误对象
 */
- (void)appletInfo:(FATAppletInfo *)appletInfo didFail:(NSError *)error {
    NSLog(@"小程序出错的事件");
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 小程序被销毁的事件
 @param appletInfo 小程序info
 @param error 错误对象
 */
- (void)appletInfo:(FATAppletInfo *)appletInfo dealloc:(NSError *)error {
    NSLog(@"小程序被销毁的事件");
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
