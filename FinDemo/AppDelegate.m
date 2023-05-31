//
//  AppDelegate.m
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/29.
//

#import "AppDelegate.h"
#import <FinApplet/FinApplet.h>


static NSString *sdkKey1 = @"22LyZEib0gLTQdU3MUauATBwgfnTCJjdr7FCnywmAEM=";
static NSString *sdkSecret1 = @"bdfd76cae24d4313";
static NSString *apiServer1 = @"https://api.finclip.com";
//static NSString *sdkKey1 = @"";
//static NSString *sdkKey1 = @"";




@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[NSClassFromString(@"ViewController") new]];
    [self.window makeKeyAndVisible];

    NSMutableArray *storeArrayM = [NSMutableArray array];
    FATStoreConfig *storeConfig = [[FATStoreConfig alloc] init];
    storeConfig.sdkKey = sdkKey1;
    storeConfig.sdkSecret = sdkSecret1;
    storeConfig.apiServer = apiServer1;
    storeConfig.cryptType = FATApiCryptTypeSM;
    [storeArrayM addObject:storeConfig];
       
    FATConfig *config = [FATConfig configWithStoreConfigs:storeArrayM];
    /*
     注意：小程序的其他操作必须放在FATClient初始化之后，否则失效！！！
     */
    BOOL result = [[FATClient sharedClient] initWithConfig:config error:nil];
    NSLog(@"注册SDK%@！！！！", result? @"成功" : @"失败");

    return YES;
}




@end
