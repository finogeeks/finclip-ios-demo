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
    
    NSString *appKey = @"22LyZEib0gLTQdU3MUauAWQrT5jdkwBnjD/4Rw9r+4kA";
    FATConfig *config = [FATConfig configWithAppSecret:@"2d74454cfc200f93" appKey:appKey];
    config.apiServer = @"http://10.104.58.240:8000";
    config.apiPrefix = @"/api/v1/mop";
    
    [[FATClient sharedClient] initWithConfig:config error:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
