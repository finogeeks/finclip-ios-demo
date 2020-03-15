# 五行代码让你的App运行小程序


## 1、 修改Podfile文件，增加FinApplet依赖

```
source 'https://github.com/CocoaPods/Specs.git'
pod 'FinApplet'
```
## 2、初始化 SDK **五行代码完成初始化**

在工程的 AppDelegate 中的以下方法中，调用 SDK 的初始化方法。

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    NSString *appKey = @"SDKKEY";
    FATConfig *config = [FATConfig configWithAppSecret:@"SECRET" appKey:appKey];
    config.apiServer = @"https://mp.finogeeks.com"; 
    config.apiPrefix = @"/api/v1/mop";
    [[FATClient sharedClient] initWithConfig:config error:nil];
    
    return YES;
}
```

## 3、打开小程序

```
NSString *appId = @"小程序id";
// 打开小程序
[[FATClient sharedClient] startRemoteApplet:appId startParams:nil InParentViewController:self completion:^(BOOL result, NSError *error) {
    NSLog(@"result:%d---error:%@", result, error);
}];
```

* **SDKKEY** 和 **Secret** 可以从前面部署的社区版的管理后台获取。
* **apiServer** 为这里是小程序生态后端的服务地址也就是前文所输入的**IP:端口**。
* **小程序id** 为在管理后台上架的小程序appid
* 上述的参数可以在前文服务器部署的后台界面上获取，亦可以在没有部署服务端的情况下在[https://mp.finogeeks.com](https://mp.finogeeks.com)快速注册，免费获取。
* 具体的操作方法请参考 [iOS集成](https://mp.finogeeks.com/mop/document/runtime-sdk/sdk-integrate/ios.html)

