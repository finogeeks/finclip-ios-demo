//
//  FinManageViewController.m
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/29.
//

#import "FinManageViewController.h"
#import <FinApplet/FinApplet.h>

@interface FinManageViewController ()<FATAppletLogDelegate>

@end

@implementation FinManageViewController

- (instancetype)init {
    if (self = [super init]) {
        NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [patchs objectAtIndex:0];
        NSString *logDir = [documentsDirectory stringByAppendingPathComponent:@"ABC_FinClip_LogFiles"];
        NSLog(@"记录日志的路径是：%@", logDir);

        //开启不同level的日志可以看到不同的log
        [[FATClient sharedClient].logManager initLogWithLogDir:logDir logLevel:FATLogLevelDebug consoleLog:YES];
        
        //也可以通过这个api打开vconsole查看js的输出
        [FATClient sharedClient].config.enableAppletDebug = FATBOOLStateTrue;
        
        //如果想自行收集log，实现该代理即可。
        //[FATClient sharedClient].logDelegate = self;
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
    request.appletId = @"5f72e3559a6a7900019b5baa";//微信官方小程序

    [[FATClient sharedClient] startAppletWithRequest:request InParentViewController:self completion:nil closeCompletion:nil];
}

- (void)logMessage:(NSString *)message {
    NSLog(@"logMessage:%@", message);
}

- (void)dealloc {
    //关闭log
    [[FATClient sharedClient].logManager closeLog];
    
    //关闭vconsole
    [FATClient sharedClient].config.enableAppletDebug = FATBOOLStateUndefined;
}
@end
