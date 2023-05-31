//
//  FinCustomApiViewController.m
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/30.
//

#import "FinCustomApiViewController.h"
#import <FinApplet/FinApplet.h>

@interface FinCustomApiViewController ()

@end

@implementation FinCustomApiViewController

/*
 有时候我们需要app提供超出微信小程序体系的能力，能可以通过自定义api提供。
 
 详细教程可以参考https://www.finclip.com/mop/document/runtime-sdk/ios/api/api-custom.html#_1-1-%E6%B3%A8%E5%86%8C%E5%B0%8F%E7%A8%8B%E5%BA%8F%E5%BC%82%E6%AD%A5api
 */

- (instancetype)init {
    if (self = [super init]) {
        //注册自定义api（异步）。param是入参
        [[FATClient sharedClient] registerExtensionApi:@"finclipLogin" handler:^(FATAppletInfo *appletInfo, id param, FATExtensionApiCallback callback) {
            NSLog(@"自定义api入参：%@", param);
            
            //出参
            NSDictionary *outParam = @{
                @"token" : @"abcdefg",
                @"name" : @"小明",
                @"url" : [NSString stringWithFormat:@"这是新的url:%@", param[@"url"]?:@""]
            };
            
            //返回成功和出参
            callback(FATExtensionCodeSuccess, outParam);
        }];
        
        
        //可以打开vconsole观看小程序的log输出
        [FATClient sharedClient].config.enableAppletDebug = FATBOOLStateTrue;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    [button setTitle: NSLocalizedString(@"打开小程序", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.center = self.view.center;

}

- (void)click {
    FATAppletRequest *request = [[FATAppletRequest alloc] init];
    request.appletId = @"64756ffed21d34000194b307";//小程序代码可见finclipLogin.zip

    [[FATClient sharedClient] startAppletWithRequest:request InParentViewController:self completion:nil closeCompletion:nil];
}

- (void)dealloc {
    //关闭vconsole
    [FATClient sharedClient].config.enableAppletDebug = FATBOOLStateUndefined;
}
@end
