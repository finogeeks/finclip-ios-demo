//
//  AppDelegate.m
//  demo
//
//  Created by 杨涛 on 2020/2/6.
//  Copyright © 2020 finogeeks. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import <FinApplet/FinApplet.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *appKey = @"22LyZEib0gLTQdU3MUauAVUHSFDdTToYDWCqr0AgPGwA";
    FATConfig *config = [FATConfig configWithAppSecret:@"8c5c3c26420b7e66" appKey:appKey];
    config.apiServer = @"https://mp.finogeeks.com";
    config.apiPrefix = @"/api/v1/mop";
    
    [[FATClient sharedClient] initWithConfig:config error:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
