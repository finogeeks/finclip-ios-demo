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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // servers.plist维护了不同应用，初始化finclip的参数（因为微信支付需要绑定一个可用的账号）
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
    [[FATClient sharedClient] setEnableLog:YES];
    
    [FATClient sharedClient].delegate = [FINDemoClientHelper sharedHelper];
    // 注入自定义api
    [[FINExtensionHelper sharedHelper] registerCustomApis];
    
    if ([bundleId isEqualToString:@"com.finogeeks.mop.finosprite"]) {
        // 该appID【wx85663af68a0cbbc8】绑定的应用为凡泰助手，若要生效，请修改BundleID为com.finogeeks.mop.finosprite
        [WXApi registerApp:@"wx85663af68a0cbbc8" universalLink:@"https://www.finclip.com/finosprite/"];
    }
    
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
