//
//  AppDelegate.m
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/29.
//

#import "AppDelegate.h"
#import <FinApplet/FinApplet.h>

/*
 初始化SDK配置。
 注意：bundleid与sdkKey、sdkSecret强相关，所以如果只修改bundleid不改其他配置会导致初始化SDK失败
 */
static NSString *sdkKey1 = @"22LyZEib0gLTQdU3MUauATBwgfnTCJjdr7FCnywmAEM=";
static NSString *sdkSecret1 = @"bdfd76cae24d4313";
static NSString *apiServer1 = @"https://api.finclip.com";

static NSString *sdkKey2 = @"";
static NSString *sdkSecret2 = @"";
static NSString *apiServer2 = @"";


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[NSClassFromString(@"ViewController") new]];
    [self.window makeKeyAndVisible];

    NSMutableArray *storeArrayM = [NSMutableArray array];
    FATStoreConfig *storeConfig1 = [[FATStoreConfig alloc] init];
    storeConfig1.sdkKey = sdkKey1;
    storeConfig1.sdkSecret = sdkSecret1;
    storeConfig1.apiServer = apiServer1;
    storeConfig1.cryptType = FATApiCryptTypeSM;
    [storeArrayM addObject:storeConfig1];
    
    /*
     如果有多个服务器，也可以多注册一组配置，但是要注意多个配置都成功时,初始化SDK才会成功
     */
//    FATStoreConfig *storeConfig2 = [[FATStoreConfig alloc] init];
//    storeConfig2.sdkKey = sdkKey2;
//    storeConfig2.sdkSecret = sdkSecret2;
//    storeConfig2.apiServer = apiServer2;
//    storeConfig2.cryptType = FATApiCryptTypeSM;
//    [storeArrayM addObject:storeConfig2];
       
    FATConfig *config = [FATConfig configWithStoreConfigs:storeArrayM];
    /*
     注意：小程序的其他操作必须放在FATClient初始化之后，否则失效！！！
     */
    BOOL result = [[FATClient sharedClient] initWithConfig:config error:nil];
    NSLog(@"注册SDK%@！！！！", result? @"成功" : @"失败");

    return YES;
}




@end
