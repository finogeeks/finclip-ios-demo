//
//  AppDelegate.m
//  demo
//
//  Created by 杨涛 on 2020/2/6.
//  Copyright © 2020 finogeeks. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "FINExtensionHelper.h"
#import "FINDemoClientHelper.h"

#import <FinApplet/FinApplet.h>
#import <FinAppletBDMap/FinAppletBDMap.h>
#import <FinAppletGDMap/FinAppletGDMap.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"servers" ofType:@"plist"];
    NSDictionary *servers = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *array = servers[bundleId];
    NSMutableArray *configs = [NSMutableArray array];
    for (NSDictionary *data in array) {
        NSString *appKey = data[@"appKey"];
        NSString *appSecret = data[@"appSecret"];
        NSString *apiServer = data[@"apiServer"];
        FATApiCryptType cryptType = [data[@"cryptType"] isEqualToString:@"MD5"] ? FATApiCryptTypeMD5 : FATApiCryptTypeSM;
        FATStoreConfig *storeConfig = [[FATStoreConfig alloc] init];
        storeConfig.sdkKey = appKey;
        storeConfig.sdkSecret = appSecret;
        storeConfig.apiServer = apiServer;
        storeConfig.cryptType = cryptType;
        [configs addObject:storeConfig];
    }
    
    FATConfig *config = [FATConfig configWithStoreConfigs:configs];
    [[FATClient sharedClient] initWithConfig:config error:nil];
    // 设置Log日志
    [[FATClient sharedClient].logManager initLogWithLogDir:nil logLevel:FATLogLevelVerbose consoleLog:YES];
    
    [FATClient sharedClient].delegate = [FINDemoClientHelper sharedHelper];
    // 注入自定义api
    [[FINExtensionHelper sharedHelper] registerCustomApis];
    
//    // 注册百度地图
//    [FATBDMapComponent setBDMapAppKey:@"申请的key"];
//    // 注册高德地图
//    [FATGDMapComponent setGDMapAppKey:@"申请的key"];
    
    // 注册微信SDK
    // 调试微信登录和微信支付时，需要修改bundleId，并配置跟bundleId匹配的微信 appKey、universalLink
//    [WXApi registerApp:@"微信开放sdk的key" universalLink:@"微信开放sdk的universalLink"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return [WXApi handleOpenURL:url delegate:[FINExtensionHelper sharedHelper]];
}

@end
