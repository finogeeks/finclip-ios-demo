//
//  FinScanStartViewController.m
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/30.
//

#import "FinScanStartViewController.h"
#import <FinApplet/FinApplet.h>
#import "FinQRCodeScanViewController.h"

@interface FinScanStartViewController ()

@end

@implementation FinScanStartViewController

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
    FinQRCodeScanViewController *scanVC = [[FinQRCodeScanViewController alloc] init];
    scanVC.scanCompletion = ^(NSString *qrcode) {
        if (![qrcode containsString:@"/runtime/applet/"]) {
            NSLog(@"不能识别的二维码");
            return;
        }
        FATAppletQrCodeRequest *req = [FATAppletQrCodeRequest new];
        req.qrCode = qrcode;
        [[FATClient sharedClient] startAppletWithQrCodeRequest:req inParentViewController:self requestBlock:nil completion:nil closeCompletion:nil];
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}


@end
