//
//  LELoginUserManager.h
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LELoginModel;

@interface LELoginUserManager : NSObject

#pragma mark -
#pragma mark - User Base info
+ (NSString *)userID;
+ (void)setUserID:(NSString *)userID;

/**
 *  用户登录后授权令牌
 *
 *  @return token
 */
+ (NSString *)authToken;
+ (void)setAuthToken:(NSString *)authToken;

#pragma mark -
#pragma mark - Common Method
/**
 *  刷新用户数据
 */
+ (void)updateUserInfoWithLoginModel:(LELoginModel *)loginModel;

+ (void)clearUserInfo;

@end
