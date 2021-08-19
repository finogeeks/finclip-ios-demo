//
//  FINClientHelper.m
//  demo
//
//  Created by Haley on 2020/12/17.
//  Copyright © 2020 finogeeks. All rights reserved.
//

#import "FINDemoClientHelper.h"
#import "FINCustomMenuModel.h"

static FINDemoClientHelper *instance = nil;

@implementation FINDemoClientHelper

+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
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

#pragma mark - FATAppletDelegate
- (void)forwardAppletWithInfo:(NSDictionary *)contentInfo completion:(void (^)(FATExtensionCode, NSDictionary *))completion
{
    NSLog(@"小程序信息:%@", contentInfo);
    
    // 1.如果你需要将小程序转发到自己app的聊天室，那么就根据contentInfo封装成自己IM消息，然后发送。
    
    // 2.如果你需要将小程序转发到自己app的朋友圈，那么就根据contentInfo，组装信息发送给后台。
}

/// 小程序灰度扩展参数
/// @param appletId 小程序id
- (NSDictionary *)grayExtensionWithAppletId:(NSString *)appletId
{
    if ([appletId isEqualToString:@"5facb3a52dcbff00017469bd"]) {
        return @{@"phone":@(1234567890)};
    }
    
    if ([appletId isEqualToString:@"5fa214a29a6a7900019b5cc1"]) {
        return @{@"token":@"xxxxxtoken"};
    }
    
    return @{@"key1":@"value1"};
}

#pragma mark - more menu
/// 更多按钮中自定义的菜单，会在页面弹出菜单时调用该api
/// @param appletInfo 小程序信息
/// @param path 页面路径
- (NSArray<id<FATAppletMenuProtocol>> *)customMenusInApplet:(FATAppletInfo *)appletInfo atPath:(NSString *)path
{
    NSString *appletId = appletInfo.appId;
    if ([appletId isEqualToString:@"5facb3a52dcbff00017469bd"]) {
        FINCustomMenuModel *favModel1 = [[FINCustomMenuModel alloc] init];
        favModel1.menuId = @"1001";
        favModel1.menuTitle = @"客服";
        favModel1.menuIconImage = [UIImage imageNamed:@"minipro_list_service"];
        
        return @[favModel1];
    }
    
    if ([appletId isEqualToString:@"5fa214a29a6a7900019b5cc1"]) {
        FINCustomMenuModel *favModel2 = [[FINCustomMenuModel alloc] init];
        favModel2.menuId = @"1002";
        favModel2.menuTitle = @"收藏";
        favModel2.menuIconImage = [UIImage imageNamed:@"minipro_list_collect"];

        return @[favModel2];
    }
    
    FINCustomMenuModel *favModel1 = [[FINCustomMenuModel alloc] init];
    favModel1.menuId = @"1003";
    favModel1.menuTitle = @"客服";
    favModel1.menuIconImage = [UIImage imageNamed:@"minipro_list_service"];

    FINCustomMenuModel *favModel2 = [[FINCustomMenuModel alloc] init];
    favModel2.menuId = @"1004";
    favModel2.menuTitle = @"收藏";
    favModel2.menuIconImage = [UIImage imageNamed:@"minipro_list_collect"];

    return @[favModel1, favModel2];
}

/// 点击自定义菜单时，会触发的事件
/// @param customMenu 自定义菜单对象
/// @param appletInfo 小程序信息
/// @param path 当前页面路径
- (void)customMenu:(id<FATAppletMenuProtocol>)customMenu inApplet:(FATAppletInfo *)appletInfo didClickAtPath:(NSString *)path
{
    NSLog(@"自定义按钮被点击");
    if ([customMenu.menuId isEqual:@"1001"]) {
        NSLog(@"客服按钮被点击");
        return;
    }
    
    if ([customMenu.menuId isEqual:@"1002"]) {
        NSLog(@"收藏按钮被点击");
        // 1.获取用户id
//        NSString *userId = @"";
//
//        // 2.获取小程序id
//        NSString *appletId = appletInfo.appId;
//
//        NSDictionary *param = @{@"userId":userId,@"appletId":appletId};
        // 3.调用网络接口
//        [FINNetworkClient postParam:param completion:];
        
        return;
    }
}

@end
