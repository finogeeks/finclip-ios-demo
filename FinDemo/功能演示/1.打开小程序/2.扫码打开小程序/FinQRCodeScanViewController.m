//
//  FinQRCodeScanViewController.m
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/30.
//

#import "FinQRCodeScanViewController.h"

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <FinApplet/FinApplet.h>

@interface FinQRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) FinQRScanView *scanView;
@end

@implementation FinQRCodeScanViewController


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

- (FinQRScanView *)scanView
{
    if (!_scanView) {
        _scanView = [[FinQRScanView alloc] initWithFrame:self.view.bounds];
    }
    return _scanView;
}

@end

const CGFloat scanner_borderWidth = 1.0;  /** 扫描器边框宽度 */
const CGFloat scanner_cornerWidth = 3.0;  /** 扫描器棱角宽度 */
const CGFloat scanner_cornerLength = 20.0;    /** 扫描器棱角长度 */
const CGFloat scanner_lineHeight = 1.0;   /** 扫描器线条高度 */
const CGFloat tipLab_height = 50.0;    /** 扫描器下方提示文字高度 */

static NSString *scannerLineAnmationKey = @"ScannerLineAnmationKey"; /** 扫描线条动画Key值 */

@interface FinQRScanView ()

@property (nonatomic, strong) UIColor *scannerBorderColor;

@property (nonatomic, strong) UIColor *scannerCornerColor;

@property (nonatomic, strong) UIImageView *scannerLine;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation FinQRScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scanner_width = 0.7 * frame.size.width;
        _scanner_x = (frame.size.width - _scanner_width) / 2;
        _scanner_y = 100;
        
        _scannerBorderColor = [UIColor whiteColor];
        _scannerCornerColor = [UIColor colorWithRed:66/255.0f green:134/255.0 blue:246/255.0 alpha:1.0];
        
        [self p_initSubViews];
    }
    return self;
}

- (void)p_initSubViews
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.scannerLine];
    
    [self addSubview:self.tipLabel];
}


- (void)p_startScannerLineAnimation
{
    [self.scannerLine.layer removeAllAnimations];
    
    CABasicAnimation *lineAnimation = [CABasicAnimation  animationWithKeyPath:@"transform"];
    lineAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, _scanner_width - scanner_lineHeight, 1)];
    lineAnimation.duration = 4;
    lineAnimation.repeatCount = MAXFLOAT;
    [self.scannerLine.layer addAnimation:lineAnimation forKey:scannerLineAnmationKey];
    // 重置动画运行速度为1.0
    self.scannerLine.layer.speed = 1.0;
}

- (void)p_pauseScannerLineAnimation
{
    // 取出当前时间，转成动画暂停的时间
    CFTimeInterval pauseTime = [self.scannerLine.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    self.scannerLine.layer.timeOffset = pauseTime;
    // 将动画的运行速度设置为0， 默认的运行速度是1.0
    self.scannerLine.layer.speed = 0;
}

- (void)p_addActivityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.center = self.center;
        [self addSubview:_activityIndicator];
    }
    
    [_activityIndicator startAnimating];
}

- (void)p_removeActivityIndicator
{
    if (_activityIndicator) {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 半透明区域
    [[UIColor colorWithWhite:0 alpha:0.7] setFill];
    UIRectFill(rect);
    
    // 透明区域
    CGRect scanner_rect = CGRectMake(_scanner_x, _scanner_y, _scanner_width, _scanner_width);
    [[UIColor clearColor] setFill];
    UIRectFill(scanner_rect);
    
    // 边框
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(_scanner_x, _scanner_y, _scanner_width, _scanner_width)];
    borderPath.lineCapStyle = kCGLineCapRound;
    borderPath.lineWidth = scanner_borderWidth;
    [_scannerBorderColor set];
    [borderPath stroke];
    
    for (int index = 0; index < 4; index++) {
        UIBezierPath *tempPath = [UIBezierPath bezierPath];
        tempPath.lineWidth = scanner_cornerWidth;
        [_scannerCornerColor set];
        switch (index) {
                // 左上角
            case 0:
                [tempPath moveToPoint:CGPointMake(_scanner_x + scanner_cornerLength, _scanner_y)];
                [tempPath addLineToPoint:CGPointMake(_scanner_x, _scanner_y)];
                [tempPath addLineToPoint:CGPointMake(_scanner_x, _scanner_y + scanner_cornerLength)];
                break;
                // 右上角
            case 1:
                [tempPath moveToPoint:CGPointMake(_scanner_x + _scanner_width - scanner_cornerLength, _scanner_y)];
                [tempPath addLineToPoint:CGPointMake(_scanner_x + _scanner_width, _scanner_y)];
                [tempPath addLineToPoint:CGPointMake(_scanner_x + _scanner_width, _scanner_y + scanner_cornerLength)];
                break;
                // 左下角
            case 2:
                [tempPath moveToPoint:CGPointMake(_scanner_x, _scanner_y + _scanner_width - scanner_cornerLength)];
                [tempPath addLineToPoint:CGPointMake(_scanner_x, _scanner_y + _scanner_width)];
                [tempPath addLineToPoint:CGPointMake(_scanner_x + scanner_cornerLength, _scanner_y + _scanner_width)];
                break;
                // 右下角
            case 3:
                [tempPath moveToPoint:CGPointMake(_scanner_x + _scanner_width - scanner_cornerLength, _scanner_y + _scanner_width)];
                [tempPath addLineToPoint:CGPointMake(_scanner_x + _scanner_width, _scanner_y + _scanner_width)];
                [tempPath addLineToPoint:CGPointMake(_scanner_x + _scanner_width, _scanner_y + _scanner_width - scanner_cornerLength)];
                break;
        }
        [tempPath stroke];
    }
    
}

- (UIImage *)fin_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - setter && getter
- (UIImageView *)scannerLine
{
    if (!_scannerLine) {
        _scannerLine = [[UIImageView alloc] initWithFrame:CGRectMake(_scanner_x + 5, _scanner_y, _scanner_width - 10, scanner_lineHeight)];
        UIColor *tinColor = [UIColor colorWithRed:66/255.0f green:134/255.0 blue:246/255.0 alpha:1.0];
        _scannerLine.image = [self fin_imageWithColor:tinColor];
    }
    
    return _scannerLine;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _scanner_y + _scanner_width, self.frame.size.width, 50)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.text = @"将二维码放入框内，即可自动扫描";
    }
    return _tipLabel;
}

@end
