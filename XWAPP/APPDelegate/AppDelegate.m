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
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import "JPUSHService.h"
#import "LELinkerHandler.h"
#import "DetailController.h"
#import <UserNotifications/UserNotifications.h>
#import "LELoginAuthManager.h"
#import <Bugly/Bugly.h>
#import "Growing.h"

@interface AppDelegate ()
<
JPUSHRegisterDelegate
>
@property (nonatomic, strong) NSDictionary *launchOptions;

@property (nonatomic, assign) BOOL pushNotificationKey;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[LELoginAuthManager sharedInstance] getGlobalTaskConfigRequestSuccess:^(BOOL success) {
//
//    }];
    
    [[LELoginAuthManager sharedInstance] checkUpdateWithAppID:@""];
    
    [SVProgressHUD setCurrentDefaultStyle];
//    defaultNetworkPreRelease = @"api.hangzhouhaniu.com";
    [WYAPIGenerate sharedInstance].netWorkHost = defaultNetworkHost;
    
    _launchOptions = [NSDictionary dictionaryWithDictionary:launchOptions];
    
    // 三方SDK注册
    [self configUSharePlatforms];
    
    //检测网络
    [self monitorNetworking];
    
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"btn_back_nor"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"btn_back_nor"]];
    [UINavigationBar appearance].tintColor = HitoRGBA(102, 102, 102, 1);
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    
    [UINavigationBar appearance].topItem.title = @"";
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:HitoPFSCRegularOfSize(17)}];
    
    if (launchOptions) {
        //当程序处于关闭状态收到推送消息时，点击图标调用
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            self->_pushNotificationKey = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self handleReceiveRemoteNotification:pushNotificationKey];
            });
        }
    }
    
    return YES;
}

- (void)configUSharePlatforms
{
    // 腾讯Bugly
    [Bugly startWithAppId:kBuglyAppID];
    
    // GrowingIO统计平台 详情：https://www.growingio.com
    [Growing startWithAccountId:kGrowingIOAppID];
    // 开启Growing调试日志 可以开启日志
#ifdef DEBUG
    [Growing setEnableLog:NO];
#endif
    
    //友盟统计
//    [UMCommonLogManager setUpUMCommonLogManager];
//    [UMConfigure setLogEnabled:YES];
    [UMConfigure setEncryptEnabled:YES];
    [UMConfigure initWithAppkey:UMS_APPKEY channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMS_APPKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_ID appSecret:WX_Secret redirectURL:nil];

    [self registerAPService];
    
}

- (BOOL)handleOpenURL:(NSURL *)url {
    LELog(@"query=%@,scheme=%@,host=%@", url.query, url.scheme, url.host);
    NSString *scheme = [url scheme];
    
    if ([Growing handleUrl:url]) // 请务必确保该函数被调用
    {
        return YES;
    }
    
    //三方登录
    BOOL isUMSocial = ([[url absoluteString] hasPrefix:[NSString stringWithFormat:@"tencent%@://qzapp",QQ_ID]] || [[url absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://oauth",WX_ID]]);
    if (isUMSocial) {
//        _isUMSocialLogin = NO;
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
//    [TencentOAuth CanHandleOpenURL:url]
    
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
    
//    [application setApplicationIconBadgeNumber:0];
    
    [self resetBageNumber];
    [JPUSHService resetBadge];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
//    [application setApplicationIconBadgeNumber:0];
//    [application cancelAllLocalNotifications];
//    [JPUSHService resetBadge];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    LELog(@"收到通知:%@", userInfo);
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if (state == UIApplicationStateInactive) {
        //在后台 点击图标调用
        [self handleReceiveRemoteNotification:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
//    [JPUSHService handleRemoteNotification:userInfo];
    LELog(@"收到通知:%@", userInfo);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //在前台
        if ([userInfo objectForKey:@"aps"]) {
            [self handleReceiveWithApplicationStateActive:userInfo];
        }
    }else {
        //在后台
//        [self handleReceiveRemoteNotification:userInfo];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

//不在appIcon上显示推送数量，但是在系统通知栏保留推送通知的方法
-(void)resetBageNumber{
    if(HitoiOS11){
        /*
         iOS 11后，直接设置badgeNumber = -1就生效了
         */
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    }else{
        UILocalNotification *clearEpisodeNotification = [[UILocalNotification alloc] init];
        clearEpisodeNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(0.3)];
        clearEpisodeNotification.timeZone = [NSTimeZone defaultTimeZone];
        clearEpisodeNotification.applicationIconBadgeNumber = -1;
        [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark - JPUSH
- (void)registerAPService{
    //JPush注册
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSString *advertisingId = [WYCommonUtils UUIDString];
    [JPUSHService setupWithOption:_launchOptions appKey:JPUSH_APPKEY
                          channel:JPUSH_CHANNLE apsForProduction:APS_FOR_PRODUCTION advertisingIdentifier:advertisingId];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetJPushTagsAndAlias) name:kJPFNetworkDidLoginNotification object:nil];
}

- (void)resetJPushTagsAndAlias{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
    NSString *alias = nil;
    NSString *testPrefix = @"";
    if (![[WYAPIGenerate sharedInstance].netWorkHost isEqualToString:defaultNetworkHost]) {
        testPrefix = @"test_"; //配置测试环境推送
    }
    if ([LELoginUserManager userID]) {
        alias = [NSString stringWithFormat:@"%@member_%@",testPrefix,[LELoginUserManager userID]];
    }
    NSMutableSet *mSet = [NSMutableSet setWithObject:[NSString stringWithFormat:@"%@members",testPrefix]];
    mSet = [NSMutableSet setWithSet:[JPUSHService filterValidTags:mSet]];
    
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        LELog(@"setAlias iResCode:%ld iAlias:%@ seq%ld",iResCode,iAlias,seq);
    } seq:0];
    [JPUSHService setTags:mSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        LELog(@"setTags iResCode:%ld iTags:%@ seq%ld",iResCode,iTags,seq);
    } seq:1];
}

- (void)handleReceiveWithApplicationStateActive:(NSDictionary *)userInfo{
    
    if (![[userInfo objectForKey:@"lecategory"] isEqualToString:@"news"]) {
        return;
    }
    NSString *message = [NSString stringWithFormat:@"%@>>>",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"推送要闻" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    HitoWeakSelf;
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [WeakSelf handleReceiveRemoteNotification:userInfo];
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)handleReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    if ([userInfo objectForKey:@"lecategory"]) {
        NSString *wyHref = [NSString stringWithFormat:@"lecategory://%@?objId=%@",[userInfo objectForKey:@"lecategory"],[userInfo objectForKey:@"leobject"]];
        UIViewController *pushVc = [LELinkerHandler handleDealWithHref:wyHref From:nil];
        DetailController *newsDetailVc = nil;
        if ([pushVc isKindOfClass:[DetailController class]]) {
            newsDetailVc = (DetailController *)pushVc;
            newsDetailVc.isFromPush = YES;
        }
        if (newsDetailVc) {
            UIViewController *superViewController = [WYCommonUtils getCurrentVC];
            [superViewController.navigationController pushViewController:newsDetailVc animated:YES];
        }
    }
}

#pragma mark -
#pragma mark - JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0)){

    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 本地通知
    }
    completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler: (void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if (state == UIApplicationStateInactive && !_pushNotificationKey) {
            [self handleReceiveRemoteNotification:userInfo];
        }else{
            _pushNotificationKey = NO;
        }
        
    }else {
        // 本地通知
    }
    completionHandler();
}

#pragma mark -
#pragma mark - ------------- 监测网络状态 -------------
- (void)monitorNetworking
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                LELog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                LELog(@"网络不可用");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMonitorNetworkingNotificationKey object:@"1" userInfo:nil];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMonitorNetworkingNotificationKey object:@"2" userInfo:nil];
            }
                break;
            default:
                break;
        }
//        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
//            NSLog(@"有网");
//        }else{
//            NSLog(@"没网");
//        }
    }];
}

@end
