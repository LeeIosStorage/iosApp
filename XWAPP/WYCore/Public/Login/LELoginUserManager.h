//
//  LELoginUserManager.h
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LELoginModel;

typedef void(^LELoginUserInfoBlock)(BOOL isSuccess, NSString *message);

@interface LELoginUserManager : NSObject

#pragma mark -
#pragma mark - User Base info
+ (NSString *)userID;
+ (void)setUserID:(NSString *)userID;

+ (NSString *)nickName;
+ (void)setNickName:(NSString *)nickName;

+ (NSString *)headImgUrl;
+ (void)setHeadImgUrl:(NSString *)headImgUrl;

+ (NSString *)mobile;
+ (void)setMobile:(NSString *)mobile;

+ (NSString *)sex;
+ (void)setSex:(NSString *)sex;

+ (NSString *)age;
+ (void)setAge:(NSString *)age;

+ (NSString *)regTime;
+ (void)setRegTime:(NSString *)regTime;

+ (NSString *)wxNickname;
+ (void)setWxNickname:(NSString *)wxNickname;

/**
 *  用户登录后授权令牌
 *
 *  @return token
 */
+ (NSString *)authToken;
+ (void)setAuthToken:(NSString *)authToken;

#pragma mark -
#pragma mark - Common Method
//请求服务器用户信息
+ (void)refreshUserInfoRequestSuccess:(LELoginUserInfoBlock)success;
/**
 *  刷新用户数据
 */
+ (void)updateUserInfoWithLoginModel:(LELoginModel *)loginModel;

+ (void)clearUserInfo;

#pragma mark -
#pragma mark - login status
+ (BOOL)hasAccoutLoggedin;

@end
