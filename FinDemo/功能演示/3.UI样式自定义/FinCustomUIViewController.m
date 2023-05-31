//
//  FinCustomUIViewController.m
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/30.
//

#import "FinCustomUIViewController.h"
#import <FinApplet/FinApplet.h>

//需要继承FATBaseLoadingView
@interface LoadingView : FATBaseLoadingView

@end

@implementation LoadingView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //修改小程序标题的颜色
    self.titleLabel.textColor = [UIColor redColor];
    
    //修改loading页的logo
    self.loadingView.iconImageView.image = [UIImage imageNamed:@"AppIcon"];
}
@end


@implementation FinCustomUIViewController
/*
 详情参考https://www.finclip.com/mop/document/runtime-sdk/custom-ui/set-loading.html
 */
- (instancetype)init {
    if (self = [super init]) {
        //自定义loading页面的样式
        [FATClient sharedClient].config.baseLoadingViewClass = @"LoadingView";
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

- (void)dealloc {
    //取消自定义样式
    [FATClient sharedClient].config.baseLoadingViewClass = nil;
}

@end

