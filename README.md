# iOS工程 readme



<a name="ulvpb"></a>
## 🤩 FinClip是什么?
有没有想过，能把一个已经开发好的微信小程序，放到你自己的APP里面运行？<br />想象一下，你只需要开发一次，就能把这个业务模块同时放到微信、自有App<br />甚至！你都不用开发业务，直接拖下来一个做好的业务模块，放到自己App里面，嘿！跑起来了！<br />听起来是不是有点不可思议？<br />没关系，这就是FinClip，帮助你实现这个不可思议！<br />

<a name="y9LBK"></a>
## 🤔 你要怎么做？<br />
只需要三个步骤：

1. get一个小程序！你可以：<br />自己开发一个微信小程序<br />or 在我们的 [小程序生态圈](https://mp.finogeeks.com/#/ecosystem) 中挑一个小程序（支持直接下载代码包）<br />or 直接使用我们提供的项目：[https://github.com/finogeeks/miniprogram-demo](https://github.com/finogeeks/miniprogram-demo)）
1. 把finclip SDK集成到你的APP里面
1. 登录[FinClip小程序开放平台](https://finclip.com/#/home)，完成关联

然后，见证奇迹，看看这个微信小程序直接在你的App里面运行起来的效果吧！<br />

<a name="TaX3b"></a>
## 🔜 五行代码让你的App运行小程序
<a name="Te1LR"></a>
### 1、 修改Podfile文件，增加FinApplet依赖
```
source 'https://github.com/CocoaPods/Specs.git'
pod 'FinApplet'
```
<a name="axnzO"></a>
### 2、初始化 SDK 五行代码完成初始化
在工程的 AppDelegate 中的以下方法中，调用 SDK 的初始化方法。
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    NSString *appKey = @"SDKKEY";
    FATConfig *config = [FATConfig configWithAppSecret:@"SECRET" appKey:appKey];
    config.apiServer = @"https://api.finclip.com"; 
    config.apiPrefix = @"/api/v1/mop";
    [[FATClient sharedClient] initWithConfig:config error:nil];
    
    return YES;
}
```
<a name="zYJ7X"></a>
### 3、打开小程序
```
NSString *appId = @"小程序id";
// 打开小程序
[[FATClient sharedClient] startRemoteApplet:appId startParams:nil InParentViewController:self completion:^(BOOL result, NSError *error) {
    NSLog(@"result:%d---error:%@", result, error);
}];
```
以上涉及的参数在本项目中，均已有配置；clone下来之后，**不需要改sdk key和应用id**，直接运行即可<br />❌ 不要修改包名、key、secret、AppID ❌<br />
<br />但如果你需要把这些内容更改为自己的信息，你可以：<br />

- **SDKKEY** 和 **Secret** 可以从[ FinClip开放平台](https://finclip.com/#/home) 获取，你也可以直接点击进入[注册页面](https://finclip.com/#/register)
- 进入平台后，在【应用管理】页面添加你自己的包名后，点击【复制】即可获得key\secret\apisever字段<br />
- **apiServer** 和 **apiPrefix **是固定字段，请直接参考本demo
- **小程序id** 为在管理后台上架的小程序AppID，需要在【小程序管理】中创建并在【应用管理】中关联 <br />（与微信小程序ID不一样哦！这里是特指finclip平台的ID）



<a name="GZU3P"></a>
## 📚 想要通关全程？这里是全程攻略
直接跑demo虽然快，不过快速通关总会留下各种遗憾。<br />来吧，跟随全程攻略，了解一下“让App运行小程序”的全貌吧：
<a name="Ri882"></a>
### 1、FinClip 平台是什么？

- Finclip平台是凡泰极客旗下的一款可私有化的小程序开放平台<br />
- 凡泰极客借鉴微信、支付宝等主流小程序平台技术，进一步打造出可私有化的小程序开放平台产品 —— FinClip，该平台主要由两个客户端组成，一个是运营端，负责审核小程序内容，确保小程序的内容符合合规要求；另一个是企业端，负责开发小程序及小程序上下架管理。
- FinClip 面向全行业发布，尤其适合金融业及其他需要自建数字化生态以及实现业务场景敏捷迭代的行业，帮助合作伙伴构建一个安全、合规、可控的小程序生态。
<a name="sx7EX"></a>
### 2、FinClip 平台的特色？

- 多端上线：同一小程序可以同步上线多个宿主端（即小程序可上线的 APP），为开发者节省大量的人力和时间。
- 合规引流：解决“行业应用嵌入第三方网络空间”的安全合规问题，合规引流，连接金融服务场景。
- 方便快捷：相较于 APP，小程序开发周期短，开发成本低等特性让更多的开发者能够轻松、快速的参与到开发过程中，实现快速上线，快速起量。
- 优质体验：小程序拥有优于现有 H5 页面的用户体验，帮助企业/机构获取更多渠道用户，同时节省获客成本。
- 部署方式：满足合规监管多种部署方式，支持私有化部署、混合部署、行业云部署。
<a name="l5pz3"></a>
### 3、FinClip 有哪些典型案例？
（如需了解更多案例，可以与小助手联系呀）<br />
![Yippi](https://www-cdn.finclip.com/images/yippi.jpeg)
<a name="l352x"></a>
## ⛳️ 获得更多指引
✅ 部署一套私有化社区版：[https://www.finclip.com/mop/document/quickstart/Community-Edition.html](https://www.finclip.com/mop/document/quickstart/Community-Edition.html)<br />✅ 了解iOS相关API：[https://www.finclip.com/mop/document/runtime-sdk/sdk-api/ios.html](https://www.finclip.com/mop/document/runtime-sdk/sdk-api/ios.html)<br />✅ 了解更多iOS常见问题：[https://www.finclip.com/mop/document/faq/SDK/iOS-SDK.html](https://www.finclip.com/mop/document/faq/SDK/iOS-SDK.html)<br />

<a name="9K1zU"></a>
## ☎️ 与我们联系
如想进入FinClip小程序技术群交流探讨，或了解更多使用场景，请添加小助手微信。<br />![](https://cdn.nlark.com/yuque/0/2021/png/679837/1612498062501-9cb75ea0-7567-46ac-a62c-1ad3397246fb.png#align=left&display=inline&height=213&margin=%5Bobject%20Object%5D&originHeight=611&originWidth=573&size=0&status=done&style=none&width=200)
