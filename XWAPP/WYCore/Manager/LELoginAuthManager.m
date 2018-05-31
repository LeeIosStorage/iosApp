//
//  LELoginAuthManager.m
//  XWAPP
//
//  Created by hys on 2018/5/31.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LELoginAuthManager.h"
#import "WXApi.h"
#import "LELoginUserManager.h"

@implementation LELoginAuthManager

static LELoginAuthManager *_instance = nil;
+ (LELoginAuthManager *)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)socialAuthBinding:(UMSocialPlatformType)loginType presentingController:(UIViewController *)presentingController success:(LoginAuthBindingSuccessBlock)success{
    
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showCustomInfoWithStatus:@"请安装微信."];
        return;
    }
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:loginType currentViewController:presentingController completion:^(id result, NSError *error) {
        if (error) {
            
            NSString *message = @"授权失败";
            NSDictionary *info = nil;
            info = [NSDictionary dictionaryWithObject:message forKey:@"error"];
            [SVProgressHUD showCustomInfoWithStatus:message];
            if (success) {
                success(NO);
            }
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            if (resp.name) {
                [info setObject:resp.name forKey:@"username"];
            }
            if (resp.uid) {
                [info setObject:resp.uid forKey:@"openId"];
            }
            if (resp.accessToken) {
                [info setObject:resp.accessToken forKey:@"accessToken"];
            }
            if (resp.iconurl) {
                [info setObject:resp.iconurl forKey:@"avatar"];
            }
            if (resp.unionId) {
                [info setObject:resp.unionId forKey:@"unionId"];
            }
        
            [LELoginUserManager setWxNickname:resp.name];
            
            if (success) {
                success(YES);
            }
        }
    }];
}

@end
