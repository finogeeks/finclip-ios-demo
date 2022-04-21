//
//  FCQRCodeScanViewController.h
//  FinoSprite
//
//  Created by Haley on 2019/12/6.
//  Copyright © 2019 finogeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScanCompletion)(NSString *qrcode);

@interface FCQRCodeScanViewController : UIViewController

@property (nonatomic, copy) ScanCompletion scanCompletion;

@end

