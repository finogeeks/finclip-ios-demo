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

### 第二步 五行代码完成SDK初始化
在工程的 `AppDelegate` 中的以下方法中，调用 SDK 的初始化方法。
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    NSString *appKey = @"SDKKEY";
    FATConfig *config = [FATConfig configWithAppSecret:@"SECRET" appKey:appKey];
    config.apiServer = @"https://api.finclip.com"; 
    config.apiPrefix = @"/api/v1/mop";
    [[FATClient sharedClient] initWithConfig:config error:nil];
    
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

微信扫描下面二维码，邀请进官方微信交流群（加好友备注：finclip 咨询），获取更多精彩内容。<br>
<img width="150px" src="https://finclip-homeweb-1251849568.cos.ap-guangzhou.myqcloud.com/images/ldy111.jpg">

## Stargazers
[![Stargazers repo roster for @finogeeks/finclip-ios-demo](https://reporoster.com/stars/finogeeks/finclip-ios-demo)](https://github.com/finogeeks/finclip-ios-demo/stargazers)

## Forkers
[![Forkers repo roster for @finogeeks/finclip-ios-demo](https://reporoster.com/forks/finogeeks/finclip-ios-demo)](https://github.com/finogeeks/finclip-ios-demo/network/members)
