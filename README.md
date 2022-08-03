<p align="center">
    <a href="https://www.finclip.com?from=github">
    <img width="auto" src="https://www.finclip.com/mop/document/images/logo.png">
    </a>
</p>

<p align="center"> 
    <strong>FinClip iOS DEMO</strong></br>
<p>
<p align="center"> 
        本项目提供在 iOS 环境中运行小程序的 DEMO 样例
<p>

<p align="center"> 
	👉 <a href="https://www.finclip.com?from=github">https://www.finclip.com/</a> 👈
</p>

<div align="center">

<a href="#"><img src="https://img.shields.io/badge/%E4%B8%93%E5%B1%9E%E5%BC%80%E5%8F%91%E8%80%85-20000%2B-brightgreen"></a>
<a href="#"><img src="https://img.shields.io/badge/%E5%B7%B2%E4%B8%8A%E6%9E%B6%E5%B0%8F%E7%A8%8B%E5%BA%8F-6000%2B-blue"></a>
<a href="#"><img src="https://img.shields.io/badge/%E5%B7%B2%E9%9B%86%E6%88%90%E5%B0%8F%E7%A8%8B%E5%BA%8F%E5%BA%94%E7%94%A8-75%2B-yellow"></a>
<a href="#"><img src="https://img.shields.io/badge/%E5%AE%9E%E9%99%85%E8%A6%86%E7%9B%96%E7%94%A8%E6%88%B7-2500%20%E4%B8%87%2B-orange"></a>

<a href="https://www.zhihu.com/org/finchat"><img src="https://img.shields.io/badge/FinClip--lightgrey?logo=zhihu&style=social"></a>
<a href="https://www.finclip.com/blog/"><img src="https://img.shields.io/badge/FinClip%20Blog--lightgrey?logo=ghost&style=social"></a>



</div>

<p align="center">

<div align="center">

[官方网站](https://www.finclip.com/) | [示例小程序](https://www.finclip.com/#/market) | [开发文档](https://www.finclip.com/mop/document/) | [部署指南](https://www.finclip.com/mop/document/introduce/quickStart/cloud-server-deployment-guide.html) | [SDK 集成指南](https://www.finclip.com/mop/document/introduce/quickStart/intergration-guide.html) | [API 列表](https://www.finclip.com/mop/document/develop/api/overview.html) | [组件列表](https://www.finclip.com/mop/document/develop/component/overview.html) | [隐私承诺](https://www.finclip.com/mop/document/operate/safety.html)

</div>

-----
## 🤔 FinClip 是什么?

有没有**想过**，开发好的微信小程序能放在自己的 APP 里直接运行，只需要开发一次小程序，就能在不同的应用中打开它，是不是很不可思议？

有没有**试过**，在自己的 APP 中引入一个 SDK ，应用中不仅可以打开小程序，还能自定义小程序接口，修改小程序样式，是不是觉得更不可思议？

这就是 FinClip ，就是有这么多不可思议！

## ⚙️ 操作步骤
### 第一步 修改 Podfile 文件，增加 FinApplet 依赖
```pod
source 'https://github.com/CocoaPods/Specs.git'
pod 'FinApplet'
```

### 第二步 完成SDK初始化
在工程的 `AppDelegate` 中的以下方法中，调用 SDK 的初始化方法。
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	// 需要添加至App中的代码--start
    NSMutableArray *storeArrayM = [NSMutableArray array];
    FATStoreConfig *storeConfig = [[FATStoreConfig alloc] init];
    storeConfig.sdkKey = @"您的sdkKey信息";
    storeConfig.sdkSecret = @"您的sdkSecret信息";
    storeConfig.apiServer = @"服务器域名";
    storeConfig.apmServer = @"apm统计事件的域名";
    [storeArrayM addObject:storeConfig];
    
    FATConfig *config = [FATConfig configWithStoreConfigs:storeArrayM];
    [[FATClient sharedClient] initWithConfig:config error:nil];
    // 需要添加至App中的代码--end
    
    return YES;
}
```

### 第三步打开小程序
```objc
NSString *appId = @"小程序id";
// 打开小程序
[[FATClient sharedClient] startRemoteApplet:appId startParams:nil InParentViewController:self completion:^(BOOL result, NSError *error) {
    NSLog(@"result:%d---error:%@", result, error);
}];
```

- **SDK KEY** 和 **SDK SECRET** 可以从 [FinClip](https://finclip.com/#/home)  获取，点 [这里](https://finclip.com/#/register) 注册账号；
- 进入平台后，在「应用管理」页面添加你自己的包名后，点击「复制」即可获得  key\secret\apisever 字段；
- **apiServer** 和 **apiPrefix** 是固定字段，请直接参考本 DEMO ；
- **小程序 ID** 是管理后台上架的小程序 APP ID，需要在「小程序管理」中创建并在「应用管理」中关联；
> 小程序 ID 与 微信小程序ID 不一样哦！（这里是特指 FinClip 平台的 ID ）

## 📋 Demo功能介绍
**微信登录**

微信登录是通过自定义api注入`login`来实现的，需要依赖微信开放SDK。
可参考`FINExtensionHelper` 中 注册的`login`的逻辑。

**微信支付**

微信支付也是通过自定义api注入`requestPayment`来实现的，需要依赖微信开放SDK。
可参考`FINExtensionHelper` 中 注册的`requestPayment`的逻辑。

**百度地图**

小程序中的Map组件默认是使用系统的Map以及相关api来实现的。您也可以选择使用百度地图的Map组件。我们在Demo里已经添加了`FinAppletBDMap`的依赖，它是我们基于百度地图做的扩展SDK。

如果要使用百度地图版本的Map组件，则只需要在初始化FinClip SDK成功后，调用`[FATBDMapComponent setBDMapAppKey:@"申请的key"];`即可。
可参考`AppDelegate`的`application:didFinishLaunchingWithOptions:`方法里的注册百度地图。

**高德地图**

同理，如果选择使用高德地图的Map组件。我们在Demo里也已经添加了`FinAppletGDMap`的依赖，它是我们基于高德地图做的扩展SDK。

如果要使用高德地图版本的Map组件，则只需要在初始化FinClip SDK成功后，调用`[FATGDMapComponent setGDMapAppKey:@"申请的key"];`即可。
可参考`AppDelegate`的`application:didFinishLaunchingWithOptions:`方法里的注册高德地图。

## 📋 集成文档
[点击这里](https://www.finclip.com/mop/document/introduce/quickStart/intergration-guide.html#_1-ios-%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90) 查看 iOS 快速集成文档

## 🔗 常用链接
以下内容是您在 FinClip 进行开发与体验时，常见的问题与指引信息

- [FinClip 官网](https://www.finclip.com/#/home)
- [示例小程序](https://www.finclip.com/#/market)
- [文档中心](https://www.finclip.com/mop/document/)
- [SDK 部署指南](https://www.finclip.com/mop/document/introduce/quickStart/intergration-guide.html)
- [小程序代码结构](https://www.finclip.com/mop/document/develop/guide/structure.html)
- [iOS 集成指引](https://www.finclip.com/mop/document/runtime-sdk/ios/ios-integrate.html)
- [Android 集成指引](https://www.finclip.com/mop/document/runtime-sdk/android/android-integrate.html)
- [Flutter 集成指引](https://www.finclip.com/mop/document/runtime-sdk/flutter/flutter-integrate.html)

## ☎️ 联系我们
微信扫描下面二维码，关注官方公众号 **「凡泰极客」**，获取更多精彩内容。<br>
<img width="150px" src="https://www.finclip.com/mop/document/images/ic_qr.svg">

微信扫描下面二维码，加入官方微信交流群，获取更多精彩内容。<br>
<img width="150px" src="https://www-cdn.finclip.com/images/qrcode/qrcode_shequn_text.png">

## Stargazers
[![Stargazers repo roster for @finogeeks/finclip-ios-demo](https://reporoster.com/stars/finogeeks/finclip-ios-demo)](https://github.com/finogeeks/finclip-ios-demo/stargazers)

## Forkers
[![Forkers repo roster for @finogeeks/finclip-ios-demo](https://reporoster.com/forks/finogeeks/finclip-ios-demo)](https://github.com/finogeeks/finclip-ios-demo/network/members)
