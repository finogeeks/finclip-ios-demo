//
//  FinQRCodeScanViewController.h
//  FinDemo
//
//  Created by 胡健辉 on 2023/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ScanCompletion)(NSString *qrcode);

@interface FinQRCodeScanViewController : UIViewController
@property (nonatomic, copy) ScanCompletion scanCompletion;

@end

@interface FinQRScanView : UIView

@property (nonatomic, assign) CGFloat scanner_width;
@property (nonatomic, assign) CGFloat scanner_x;
@property (nonatomic, assign) CGFloat scanner_y;

- (void)p_startScannerLineAnimation;

- (void)p_pauseScannerLineAnimation;

- (void)p_addActivityIndicator;

- (void)p_removeActivityIndicator;

@end


NS_ASSUME_NONNULL_END
