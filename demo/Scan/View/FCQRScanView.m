//
//  FCQRScanView.m
//  FinoSprite
//
//  Created by Haley on 2019/12/6.
//  Copyright © 2019 finogeeks. All rights reserved.
//

#import "FCQRScanView.h"

const CGFloat scanner_borderWidth = 1.0;  /** 扫描器边框宽度 */
const CGFloat scanner_cornerWidth = 3.0;  /** 扫描器棱角宽度 */
const CGFloat scanner_cornerLength = 20.0;    /** 扫描器棱角长度 */
const CGFloat scanner_lineHeight = 1.0;   /** 扫描器线条高度 */
const CGFloat tipLab_height = 50.0;    /** 扫描器下方提示文字高度 */

static NSString *scannerLineAnmationKey = @"ScannerLineAnmationKey"; /** 扫描线条动画Key值 */

@interface FCQRScanView ()

@property (nonatomic, strong) UIColor *scannerBorderColor;

@property (nonatomic, strong) UIColor *scannerCornerColor;

@property (nonatomic, strong) UIImageView *scannerLine;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation FCQRScanView

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
