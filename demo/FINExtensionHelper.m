//
//  FINExtensionHelper.m
//  finclip_custom_demo
//
//  Created by Haley on 2020/12/3.
//

#import "FINExtensionHelper.h"
#import <FinApplet/FinApplet.h>

@implementation FINExtensionHelper

+ (void)registerCustomApis
{
    [[FATClient sharedClient] registerExtensionApi:@"onNative" handle:^(id param, FATExtensionApiCallback callback) {
       
        NSString *inputText = @"床前明月光，疑是地上霜。举头望明月，低头思故乡。";
        callback(FATExtensionCodeSuccess, @{@"text":inputText});
    }];
    
    [[FATClient sharedClient] fat_registerWebApi:@"user_define_native" handle:^(id param, FATExtensionApiCallback callback) {
        
        NSString *inputText = @"鹅鹅鹅，曲项向天歌，白毛浮绿水，红掌拨清波。";
        callback(FATExtensionCodeSuccess, @{@"text":inputText});
    }];
}

@end
