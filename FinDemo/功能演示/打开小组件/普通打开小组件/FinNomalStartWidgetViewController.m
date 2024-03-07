//
//  FinNomalStartWidgetViewController.m
//  FinDemo
//
//  Created by 滔 on 2024/3/7.
//

#import "FinNomalStartWidgetViewController.h"
#import <FinApplet/FinApplet.h>

@interface FinNomalStartWidgetViewController ()
@property (nonatomic,strong) UILabel *errorMsgLabel;
@property (nonnull,strong) UIView *loadingView;
@property (nonnull,strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation FinNomalStartWidgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"小组件示例";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self openWidget];
}

- (void)openWidget {
    FATWidgetRequest *widgetRequest = [[FATWidgetRequest alloc]init];
    widgetRequest.widgetId = @"65e82e0778df2c00015c21a4";
    widgetRequest.widgetServer = @"https://api.finclip.com";
    [self showLoading];
    [[FATClient sharedClient].widgetManager createWidget:widgetRequest parentViewController:self completion:^(FATWidgetView * _Nullable widgetView, FATError * _Nonnull error) {
        [self hideLoading];
        if (!error) {
            if (widgetView) {
                [self showWidgetView:widgetView];
            }
        }else {
            [self handleOpenWidgetFail:error];
        }
    }];
    
}

- (void)showWidgetView:(FATWidgetView *)widgetView {
    [self.view addSubview:widgetView];
    widgetView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topLayoutConstraint = [NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *leftLayoutConstraint = [NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *rightLayoutConstraint = [NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    NSLayoutConstraint *bottomLayoutConstraint = [NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    
    [self.view addConstraints:@[topLayoutConstraint,leftLayoutConstraint,rightLayoutConstraint,bottomLayoutConstraint]];

}

- (void)handleOpenWidgetFail:(FATError *)error {
    if (!self.errorMsgLabel) {
        self.errorMsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        self.errorMsgLabel.textColor = [UIColor blackColor];
        self.errorMsgLabel.font = [UIFont systemFontOfSize:14];
        self.errorMsgLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self.view addSubview:self.errorMsgLabel];
    self.errorMsgLabel.text = error.localizedDescription;
    self.errorMsgLabel.center = self.view.center;
}

- (void)showLoading {
    if (!self.loadingView) {
        UIView *loadingView = [[UIView alloc] init];
        loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        loadingView.layer.cornerRadius = 10;
        self.loadingView = loadingView;
    }
    
    [self.view addSubview:self.loadingView];
    self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *centerYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *widthLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:80];
    
    NSLayoutConstraint *heightLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:80];
    [self.view addConstraints:@[centerXLayoutConstraint,centerYLayoutConstraint,widthLayoutConstraint,heightLayoutConstraint]];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(20, 20, 40, 40);
    activityIndicator.color = [UIColor blackColor];
    self.activityIndicator = activityIndicator;
    [self.loadingView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    
}

- (void)hideLoading {
    [self.activityIndicator removeFromSuperview];
    [self.loadingView removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
