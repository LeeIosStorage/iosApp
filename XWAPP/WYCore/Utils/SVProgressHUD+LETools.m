//
//  SVProgressHUD+LETools.m
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SVProgressHUD+LETools.h"

@implementation SVProgressHUD (LETools)

+ (void)setCurrentDefaultStyle{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
}

+ (void)showCustomWithStatus:(NSString *)status{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:status];
}

+ (void)showCustomSuccessWithStatus:(NSString *)status{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showCustomErrorWithStatus:(NSString *)status{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)showCustomInfoWithStatus:(NSString *)status{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showInfoWithStatus:status];
}

+ (void)showCustomRequestError{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showErrorWithStatus:HitoFaiRequest];
}

@end
