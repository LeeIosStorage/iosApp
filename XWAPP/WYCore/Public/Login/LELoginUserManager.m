//
//  LELoginUserManager.m
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LELoginUserManager.h"
#import "LELoginModel.h"

NSString *const kUserInfoUserID = @"kUserInfoUserID";
NSString *const kUserInfoNickname = @"kUserInfoNickname";
NSString *const kUserInfoAvatar = @"kUserInfoAvatar";

NSString *const kUserInfoAuthToken = @"kUserInfoAuthToken";

@implementation LELoginUserManager

#pragma mark -
#pragma mark - User Base info
+ (NSString *)userID{
    return [self objectFromUserDefaultsKey:kUserInfoUserID];
}

+ (void)setUserID:(NSString *)userID{
    [self saveToUserDefaultsObject:userID forKey:kUserInfoUserID];
}

+ (NSString *)authToken{
    return [self objectFromUserDefaultsKey:kUserInfoAuthToken];
}

+ (void)setAuthToken:(NSString *)authToken{
    [self saveToUserDefaultsObject:authToken forKey:kUserInfoAuthToken];
}

#pragma mark -
#pragma mark - Common Method

+ (id)objectFromUserDefaultsKey:(NSString *)key{
    
    NSUserDefaults *originalDefaults = [NSUserDefaults standardUserDefaults];
    id object = [originalDefaults objectForKey:key];
    
    return object;
}

+ (void)saveToUserDefaultsObject:(id)object forKey:(NSString *)key {
    NSUserDefaults *originalDefaults = [NSUserDefaults standardUserDefaults];
    [originalDefaults setObject:object forKey:key];
    [originalDefaults synchronize];
}

+ (void)updateUserInfoWithLoginModel:(LELoginModel *)loginModel{
    
    [LELoginUserManager setUserID:loginModel.userID];
}

+ (void)clearUserInfo{
    
    [LELoginUserManager setUserID:nil];
}

@end
