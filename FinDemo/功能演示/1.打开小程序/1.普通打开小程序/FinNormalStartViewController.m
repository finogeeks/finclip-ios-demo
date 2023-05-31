//
//  FinNormalStartViewController.m
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/30.
//

#import "FinNormalStartViewController.h"
#import <FinApplet/FinApplet.h>

@interface FinNormalStartViewController ()

@end

@implementation FinNormalStartViewController

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

@end
