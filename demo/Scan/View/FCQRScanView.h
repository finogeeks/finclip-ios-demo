//
//  FCQRScanView.h
//  FinoSprite
//
//  Created by Haley on 2019/12/6.
//  Copyright © 2019 finogeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCQRScanView : UIView

@property (nonatomic, assign) CGFloat scanner_width;
@property (nonatomic, assign) CGFloat scanner_x;
@property (nonatomic, assign) CGFloat scanner_y;

- (void)p_startScannerLineAnimation;

- (void)p_pauseScannerLineAnimation;

- (void)p_addActivityIndicator;

- (void)p_removeActivityIndicator;

@end

