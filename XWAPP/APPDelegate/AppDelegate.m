//
//  AppDelegate.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WYShareManager.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self configUSharePlatforms];
//    [self confitUShareSettings];
//    // Override point for customization after application launch.
//    return YES;
//}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // UMConfigure 通用设置，请参考SDKs集成做统一初始化。
    // 以下仅列出U-Share初始化部分
    
    [SVProgressHUD setCurrentDefaultStyle];
    
    [WYAPIGenerate sharedInstance].netWorkHost = defaultNetworkHost;//defaultNetworkHost defaultNetworkHostTest
    
    // U-Share 平台设置
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    // Custom code
    
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"btn_back_nor"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"btn_back_nor"]];
    [UINavigationBar appearance].tintColor = HitoRGBA(102, 102, 102, 1);
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    
    [UINavigationBar appearance].topItem.title = @"";
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:HitoPFSCRegularOfSize(17)}];
    
    return YES;
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMS_APPKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_ID appSecret:WX_Secret redirectURL:nil];
    
}

- (BOOL)handleOpenURL:(NSURL *)url {
    LELog(@"query=%@,scheme=%@,host=%@", url.query, url.scheme, url.host);
    NSString *scheme = [url scheme];
    
    //三方登录
    BOOL isUMSocial = ([[url absoluteString] hasPrefix:[NSString stringWithFormat:@"tencent%@://qzapp",QQ_ID]] || [[url absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://oauth",WX_ID]]);
    if (isUMSocial) {
//        _isUMSocialLogin = NO;
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    
    if ([scheme hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:[WYShareManager shareInstance]];
    }
    if ([scheme hasPrefix:@"wb"]) {
        return [WeiboSDK handleOpenURL:url delegate:[WYShareManager shareInstance]];
    }
    if ([scheme hasPrefix:@"tencent"]) {
        return [QQApiInterface handleOpenURL:url delegate:[WYShareManager shareInstance]];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    LELog(@"openURL url=%@, sourceApplication=%@, annotation=%@", url, sourceApplication, annotation);
    return [self handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
