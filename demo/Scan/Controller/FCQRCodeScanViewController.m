//
//  FCQRCodeScanViewController.m
//  FinoSprite
//
//  Created by Haley on 2019/12/6.
//  Copyright © 2019 finogeeks. All rights reserved.
//

#import "FCQRCodeScanViewController.h"
#import "FCQRScanView.h"

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <FinApplet/FinApplet.h>

@interface FCQRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) FCQRScanView *scanView;

@end

@implementation FCQRCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_initNavigationBar];
    
    [self p_addNotifications];
    
    [self p_initSubView];
    
    [self p_checkCameraStatus:^(BOOL granted) {
        if (granted) {
            [self p_initCameraSession];
        } else {
            [self p_showAlert:@"请在”设置-隐私-相机”选项中，允许访问你的相机" btnTitle:@"确定"];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self p_resumeScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self p_pauseScanning];
}

#pragma mark - ovverride
- (void)updateNavigationBar
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - private methods
- (void)p_initNavigationBar
{
    self.title = @"扫一扫";
}

- (void)p_addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)p_initSubView
{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.scanView];
}

- (void)p_initCameraSession
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) {
        return;
    }
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!deviceInput) {
        return;
    }
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 配置扫描区域
    metadataOutput.rectOfInterest = CGRectMake(_scanView.scanner_y / self.view.frame.size.height, _scanView.scanner_x / self.view.frame.size.width, _scanView.scanner_width / self.view.frame.size.height, _scanView.scanner_width / self.view.frame.size.width);
    
    self.session = [[AVCaptureSession alloc] init];
    
    [self.session canSetSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
    
    if ([self.session canAddOutput:metadataOutput]) {
        [self.session addOutput:metadataOutput];
    }
    
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    videoPreviewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:videoPreviewLayer atIndex:0];
    
    [self.session startRunning];
}

- (void)p_showAlert:(NSString *)title btnTitle:(NSString *)btnTitle
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)p_checkCameraStatus:(void (^)(BOOL granted))completion
{
    AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (cameraStatus) {
        case AVAuthorizationStatusAuthorized:
        {
           if (completion) {
                completion(true);
            }
        }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            if (completion) {
                completion(true);
            }
        }
            break;
        default:
        {
            if (completion) {
                completion(false);
            }
        }
            break;
    }
}

/// 恢复扫一扫功能
- (void)p_resumeScanning
{
    [self.session startRunning];
    [self.scanView p_startScannerLineAnimation];
}

/// 暂停扫一扫功能
- (void)p_pauseScanning
{
    [self.session stopRunning];
    [self.scanView p_pauseScannerLineAnimation];
}

#pragma mark - QRCode handler
- (void)handleQrCode:(NSString *)qrCode
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.scanCompletion) {
        self.scanCompletion(qrCode);
    }
}

#pragma mark - notification handler
- (void)appDidBecomeActive
{
    [self p_resumeScanning];
}

- (void)appWillResignActive
{
    [self p_pauseScanning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && metadataObjects.count > 0) {
    
        [self p_pauseScanning];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        [self handleQrCode:[obj stringValue]];
    } else {
        
    }
}

#pragma mark - setter && getter

- (FCQRScanView *)scanView
{
    if (!_scanView) {
        _scanView = [[FCQRScanView alloc] initWithFrame:self.view.bounds];
    }
    return _scanView;
}



@end
