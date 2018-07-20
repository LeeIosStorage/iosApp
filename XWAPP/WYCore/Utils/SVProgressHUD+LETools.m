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
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setImageViewSize:CGSizeMake(17, 17)];
    
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:HitoRGBA(0,0,0,0.7)];
    [SVProgressHUD resetOffsetFromCenter];
}

+ (void)showCustomWithStatus:(NSString *)status{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD resetOffsetFromCenter];
    [SVProgressHUD showWithStatus:status];
}

+ (void)showCustomProgress:(float)progress status:(NSString*)status{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD resetOffsetFromCenter];
    [SVProgressHUD showProgress:progress status:status];
}

+ (void)showCustomSuccessWithStatus:(NSString *)status{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD resetOffsetFromCenter];
//    [SVProgressHUD setSuccessImage:nil];
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showCustomErrorWithStatus:(NSString *)status{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD resetOffsetFromCenter];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)showCustomInfoWithStatus:(NSString *)status{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setInfoImage:nil];
//    UIOffset offset = UIOffsetZero;
//    offset.vertical = HitoScreenH/2-100;
//    [SVProgressHUD setOffsetFromCenter:offset];
    [SVProgressHUD showInfoWithStatus:status];
}

+ (void)showCustomRequestError{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD resetOffsetFromCenter];
    [SVProgressHUD showErrorWithStatus:HitoFaiRequest];
}

@end
