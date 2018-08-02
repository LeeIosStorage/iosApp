//
//  SVProgressHUD+LETools.h
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (LETools)

/**
 *  本项目使用SVProgressHUD的风格
 */
+ (void)setCurrentDefaultStyle;

/**
 *  加载中状态
 *
 *  @param status 提示语
 */
+ (void)showCustomWithStatus:(NSString *)status;

/**
 *  进度条
 *
 *  @param status 提示语
 */
+ (void)showCustomProgress:(float)progress status:(NSString*)status;

/**
 *  成功提示
 *
 *  @param status 提示语
 */
+ (void)showCustomSuccessWithStatus:(NSString *)status;

/**
 *  失败提示
 *
 *  @param status 提示语
 */
+ (void)showCustomErrorWithStatus:(NSString *)status;

/**
 *  普通信息提示!
 *
 *  @param status 提示语
 */
+ (void)showCustomInfoWithStatus:(NSString *)status;

/**
 *  请求失败统一提示
 *
 */
+ (void)showCustomRequestError;

@end
