//
//  AppDelegate.m
//  demo
//
//  Created by 杨涛 on 2020/2/6.
//  Copyright © 2020 finogeeks. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FINExtensionHelper.h"
#import "FINDemoClientHelper.h"

#import <FinApplet/FinApplet.h>
#import <WechatOpenSDK/WXApi.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // servers.plist维护了不同应用，初始化finclip的参数（因为微信支付需要绑定一个可用的账号）
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"servers" ofType:@"plist"];
    NSDictionary *servers = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *data = servers[bundleId];
    NSString *appKey = data[@"appKey"];
    NSString *appSecret = data[@"appSecret"];
    NSString *apiServer = data[@"apiServer"];
    NSString *apiPrefix = data[@"apiPrefix"];
    FATApiCryptType cryptType = [data[@"cryptType"] isEqualToString:@"MD5"] ? FATApiCryptTypeMD5 : FATApiCryptTypeSM;
    
    FATConfig *config = [FATConfig configWithAppSecret:appSecret appKey:appKey];
    config.apiServer = apiServer;
    config.apiPrefix = apiPrefix;
    config.cryptType = cryptType;
    [[FATClient sharedClient] initWithConfig:config error:nil];
    [[FATClient sharedClient] setEnableLog:YES];
    
    [FATClient sharedClient].delegate = [FINDemoClientHelper sharedHelper];
    // 注入自定义api
    [[FINExtensionHelper sharedHelper] registerCustomApis];
    
    // 该appID【wx85663af68a0cbbc8】绑定的应用为凡泰助手，若要生效，请修改BundleID为com.finogeeks.mop.finosprite
    [WXApi registerApp:@"wx85663af68a0cbbc8" universalLink:apiServer];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    if ([url.scheme isEqualToString:@"wx85663af68a0cbbc8"]) {
        return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate> _Nullable)[FINExtensionHelper sharedHelper]];
    }
    return YES;
}

@end
