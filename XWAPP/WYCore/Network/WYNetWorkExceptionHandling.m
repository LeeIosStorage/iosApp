//
//  WYNetWorkExceptionHandling.m
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#import "WYNetWorkExceptionHandling.h"

@implementation WYNetWorkExceptionHandling

+ (BOOL)judgeReuqestStatus:(WYRequestType)type URLString:(NSString *)URLString
{
    switch (type) {
            case WYRequestTypeSuccess:
            return YES;
            break;
            case WYRequestTypeTokenInvalid:
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
        if (type == WYRequestTypeTokenInvalid) {
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
    });
}

@end
