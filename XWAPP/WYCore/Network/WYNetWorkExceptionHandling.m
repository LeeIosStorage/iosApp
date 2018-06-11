//
//  WYNetWorkExceptionHandling.m
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#import "WYNetWorkExceptionHandling.h"
#import "LELoginManager.h"
#import "LESuperViewController.h"

@implementation WYNetWorkExceptionHandling

+ (BOOL)judgeReuqestStatus:(WYRequestType)type URLString:(NSString *)URLString
{
    switch (type) {
            case WYRequestTypeSuccess:
            return YES;
            break;
            case WYRequestTypeUnauthorized:
            [SVProgressHUD showCustomErrorWithStatus:@"登录失效,请重新登录."];
            [WYNetWorkExceptionHandling reLogin:URLString requestType:type];
            break;
            case WYRequestTypeNotLogin:
            [WYNetWorkExceptionHandling reLogin:URLString requestType:type];

            break;
        default:
            
            break;
    }
    return YES;
}

+ (void)reLogin:(NSString *)URLString requestType:(WYRequestType)type{
    
    BOOL isNeedGotoLogin = YES;
    NSURL *realUrl = [NSURL URLWithString:URLString];
    NSString *urlPath = [realUrl path];
    if ([urlPath isEqualToString:@"/msg/typeCount"] || [urlPath isEqualToString:@"/my/statistics"] || [urlPath isEqualToString:@"/statistics/userCoin"] ||[urlPath isEqualToString:@"/statistics/todayIncome"]) {
        isNeedGotoLogin = NO;
    }
    
    if (isNeedGotoLogin) {
        if (type == WYRequestTypeUnauthorized) {
            [WYNetWorkExceptionHandling delayLogin];
        }else if (type == WYRequestTypeNotLogin){
            //未登录,需要登录
            
        }
    }
}

+ (void)delayLogin{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //延迟登录
        [self resetLogin];
    });
}

+ (void)resetLogin{
    
    __weak UIViewController *currentVC = [WYNetWorkExceptionHandling getCurrentVC];
    [[LELoginManager sharedInstance] showLoginViewControllerFromPresentViewController:currentVC showCancelButton:YES success:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUILoginNotificationKey object:nil];
        if ([currentVC isKindOfClass:[LESuperViewController class]]) {
            LESuperViewController *superVc = (LESuperViewController *)currentVC;
            [superVc refreshViewWithObject:nil];
        }
        
    } failure:^(NSString *errorMessage) {
        
    } cancel:^{
        
    }];
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        NSInteger index = ((UITabBarController *)nextResponder).selectedIndex;
        UINavigationController *nav = [(UITabBarController *)nextResponder viewControllers][index];
        nextResponder = [nav.viewControllers lastObject];
    }
    result = nextResponder;
    
    return result;
}

@end
