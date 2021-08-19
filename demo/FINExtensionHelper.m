//
//  FINExtensionHelper.m
//  finclip_custom_demo
//
//  Created by Haley on 2020/12/3.
//

#import "FINExtensionHelper.h"
#import <FinApplet/FinApplet.h>
#import <WechatOpenSDK/WXApi.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@interface FINExtensionHelper () <WXApiDelegate>

// 支付时，支付的回调是异步的，故这里将小程序的回调持有，在适当的时机调用（用户可根据自己的场景自行实现自己调用的逻辑）
@property (nonatomic, copy) FATExtensionApiCallback callback;

@end

static FINExtensionHelper *instance = nil;

@implementation FINExtensionHelper

+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FINExtensionHelper alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copy {
    return instance;
}

// 注入自定义api
- (void)registerCustomApis {
    [[FATClient sharedClient] registerExtensionApi:@"onNative" handle:^(id param, FATExtensionApiCallback callback) {
        NSString *inputText = @"床前明月光，疑是地上霜。举头望明月，低头思故乡。";
        callback(FATExtensionCodeSuccess, @{@"text":inputText});
    }];
    
    [[FATClient sharedClient] fat_registerWebApi:@"user_define_native" handle:^(id param, FATExtensionApiCallback callback) {
        NSString *inputText = @"鹅鹅鹅，曲项向天歌，白毛浮绿水，红掌拨清波。";
        callback(FATExtensionCodeSuccess, @{@"text":inputText});
    }];
    
    // 注入获取用户信息
    [[FATClient sharedClient] registerExtensionApi:@"getUserProfile" handle:^(id param, FATExtensionApiCallback callback) {
        NSDictionary *userInfo = @{@"nickName":@"张三",@"avatarUrl":@"",@"gender":@1,@"country":@"中国",@"province":@"广东省",@"city":@"深圳",@"language":@"zh_CN"};
        NSDictionary *resDic = @{@"userInfo":userInfo};
        callback(FATExtensionCodeSuccess,resDic);
    }];
    // 注入登录方法
    [[FATClient sharedClient] registerExtensionApi:@"login" handle:^(id param, FATExtensionApiCallback callback) {
        // 处理小程序登录逻辑后，调用小程序回调
        // 登录成功回调示例
        callback(FATExtensionCodeSuccess,@{@"desc":@"登录成功"});
    }];
    // 注入微信支付方法
    __weak typeof(self) weakSelf = self;
    [[FATClient sharedClient] registerExtensionApi:@"requestPayment" handle:^(id param, FATExtensionApiCallback callback) {
        // 支付调用，调用结果通过回调通告小程序
        [weakSelf getTestPayment:callback];
    }];
}

#pragma mark - WXPay
// 模拟向服务请求支付订单
- (void)getTestPayment:(FATExtensionApiCallback)callback {
    NSString *urlString = @"https://finclip-testing.finogeeks.club/mop/wechat-auth/api/order";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:url];
    requset.HTTPMethod = @"POST";
    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:requset completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            NSString *appId = @"wx85663af68a0cbbc8";
            NSString *partnerId = @"1600932850";
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *prepayId = dict[@"data"][@"prepay_id"];
            NSString *nonceStr = @"5K8264ILTKCH16CQ2502SI8ZNMTM67VS"; // 随机字符串，这里就不模拟了
            UInt32 timeStamp = [[NSDate date] timeIntervalSince1970];
            NSString *text = [NSString stringWithFormat:@"%@\n%ld\n%@\n%@\n", appId, (long)timeStamp, nonceStr, prepayId];
            NSString *sign = [weakSelf sha256:text];
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = partnerId;
            request.prepayId = prepayId;
            request.package = @"Sign=WXPay";
            request.nonceStr = nonceStr;
            request.timeStamp = timeStamp;
            request.sign= sign;
            dispatch_async(dispatch_get_main_queue(), ^{
                [WXApi sendReq:request completion:^(BOOL success) {
                    if (success) {
                        weakSelf.callback = callback;
                    } else {
                        callback(FATExtensionCodeFailure, nil);
                    }
                }];
            });
            return;
        }
        callback(FATExtensionCodeFailure, nil);
    }];
    [task resume];
}

// 签名加密（正常是放在后台处理，由上面的请求接口返回
- (NSString *)sha256:(NSString *)shaStr {
    NSData *data = [shaStr dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSData *adata = [[NSData alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    adata = [adata base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
    return ret;
}

#pragma mark - WXApiDelegate
//发起支付请求回调
- (void)onReq:(BaseReq *)req {
    
}

//支付结果回调
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp*)resp;
        //response.errCode
//        WXSuccess           = 0,    /**< 成功    */
//        WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//        WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//        WXErrCodeSentFail   = -3,   /**< 发送失败    */
//        WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//        WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
        switch (response.errCode) {
            case WXSuccess:
                self.callback(FATExtensionCodeSuccess, nil);
                break;
                
            default:
                self.callback(FATExtensionCodeFailure, nil);
                break;
        }
    }
}


@end
