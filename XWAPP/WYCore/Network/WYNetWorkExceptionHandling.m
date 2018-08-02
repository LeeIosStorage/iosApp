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
            [WYNetWorkExceptionHandling reLogin:URLString requestType:type];
            break;
            case WYRequestTypeUnauthorized2:
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

//show错误信息
+ (void)showProgressHUDWith:(NSString *)message URLString:(NSString *)URLString{
    BOOL isShow = YES;
    NSURL *realUrl = [NSURL URLWithString:URLString];
    NSString *urlPath = [realUrl path];
    if ([urlPath isEqualToString:@"/api/user/UpdateUserTaskState"] || [urlPath isEqualToString:@"/api/user/GetGlobalTaskConfig"] || [urlPath isEqualToString:@"/api/user/SaveReadLog"] || [urlPath isEqualToString:@"/api/news/GetAutoCompletedTags"]) {
        isShow = NO;
    }
    if (isShow) {
        [SVProgressHUD showCustomInfoWithStatus:message];
    }
}
// Token失效 处理
+ (void)reLogin:(NSString *)URLString requestType:(WYRequestType)type{
    
    BOOL isNeedGotoLogin = YES;
    NSURL *realUrl = [NSURL URLWithString:URLString];
    NSString *urlPath = [realUrl path];
    if ([urlPath isEqualToString:@"/api/user/CheckFavoriteNews"] || [urlPath isEqualToString:@"/api/user/UpdateUserTaskState"] || [urlPath isEqualToString:@"/api/user/GetGlobalTaskConfig"]) {
        isNeedGotoLogin = NO;
    }
    
    if (isNeedGotoLogin) {
        if (type == WYRequestTypeUnauthorized || type == WYRequestTypeUnauthorized2) {
            [SVProgressHUD showCustomErrorWithStatus:@"登录失效,请重新登录."];
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
    
    __weak UIViewController *currentVC = [WYCommonUtils getCurrentVC];
    [[LELoginManager sharedInstance] showLoginViewControllerFromPresentViewController:[WYCommonUtils getCurrentVC] showCancelButton:YES success:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUILoginNotificationKey object:nil];
        if ([currentVC isKindOfClass:[LESuperViewController class]]) {
            LESuperViewController *superVc = (LESuperViewController *)currentVC;
            [superVc refreshViewWithObject:nil];
        }
        
    } failure:^(NSString *errorMessage) {
        
    } cancel:^{
        
    }];
}

@end
