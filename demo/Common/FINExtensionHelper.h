//
//  FINExtensionHelper.h
//  finclip_custom_demo
//
//  Created by Haley on 2020/12/3.
//

#import <Foundation/Foundation.h>
#import <WechatOpenSDK/WXApi.h>

@interface FINExtensionHelper : NSObject<WXApiDelegate>

+ (instancetype)sharedHelper;

- (void)registerCustomApis;

@end

