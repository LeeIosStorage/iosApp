//
//  NSObject+ZZBDS.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "NSObject+ZZBDS.h"

@implementation NSObject (ZZBDS)

//判断手机号
- (BOOL)checkoutPhoneNum: (NSString *)phoneNum {
    NSString *regexStr = @"^1[3,8]\\d{9}|14[5,7,9]\\d{8}|15[^4]\\d{8}|17[^2,4,9]\\d{8}$";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) return NO;
    NSInteger count = [regular numberOfMatchesInString:phoneNum options:NSMatchingReportCompletion range:NSMakeRange(0, phoneNum.length)];
    if (count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)numberSuitScanf:(NSString*)number{
    
    if ([self checkoutPhoneNum:number]) {
        
        NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return numberString;
    }
    return number;
}

- (void)addAlertWithVC:(UIViewController *)alertVC title:(NSString *)title message:(NSString *)message {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LELog(@"点击了按钮1，进入按钮1的事件");
    }];

    [actionSheet addAction:action1];
    [alertVC presentViewController:actionSheet animated:YES completion:nil];
}


@end
