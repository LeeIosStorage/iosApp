//
//  LELoginUserManager.m
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LELoginUserManager.h"
#import "LELoginModel.h"
#import "WYNetWorkManager.h"

NSString *const kUserInfoUserID = @"kUserInfoUserID";
NSString *const kUserInfoNickname = @"kUserInfoNickname";
NSString *const kUserInfoAvatar = @"kUserInfoAvatar";
NSString *const kUserInfoMobile = @"kUserInfoMobile";
NSString *const kUserInfoSex = @"kUserInfoSex";
NSString *const kUserInfoAge = @"kUserInfoAge";
NSString *const kUserInfoRegTime = @"kUserInfoRegTime";

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

+ (NSString *)nickName{
    return [self objectFromUserDefaultsKey:kUserInfoNickname];
}

+ (void)setNickName:(NSString *)nickName{
    [self saveToUserDefaultsObject:nickName forKey:kUserInfoNickname];
}

+ (NSString *)headImgUrl{
    return [self objectFromUserDefaultsKey:kUserInfoAvatar];
}

+ (void)setHeadImgUrl:(NSString *)headImgUrl{
    [self saveToUserDefaultsObject:headImgUrl forKey:kUserInfoAvatar];
}

+ (NSString *)mobile{
    return [self objectFromUserDefaultsKey:kUserInfoMobile];
}

+ (void)setMobile:(NSString *)mobile{
    [self saveToUserDefaultsObject:mobile forKey:kUserInfoMobile];
}

+ (NSString *)sex{
    return [self objectFromUserDefaultsKey:kUserInfoSex];
}
+ (void)setSex:(NSString *)sex{
    [self saveToUserDefaultsObject:sex forKey:kUserInfoSex];
}

+ (NSString *)age{
    return [self objectFromUserDefaultsKey:kUserInfoAge];
}
+ (void)setAge:(NSString *)age{
    [self saveToUserDefaultsObject:age forKey:kUserInfoAge];
}

+ (NSString *)regTime{
    return [self objectFromUserDefaultsKey:kUserInfoRegTime];
}
+ (void)setRegTime:(NSString *)regTime{
    [self saveToUserDefaultsObject:regTime forKey:kUserInfoRegTime];
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

+ (void)refreshUserInfoRequestSuccess:(LELoginUserInfoBlock)success{
    
    WYNetWorkManager *netWorkManager = [[WYNetWorkManager alloc] init];
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([self userID]) [params setObject:[self userID] forKey:@"uid"];
    requesUrl = [NSString stringWithFormat:@"%@uid=%@",requesUrl,[self userID]];
    [netWorkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            if (success) {
                success(NO,message);
            }
            return;
        }
        
        LELoginModel *loginModel = [LELoginModel modelWithJSON:dataObject];
        loginModel.headImgUrl = @"http://p1.qzone.la/upload/20150102/a3zs6l69.jpg";
        [WeakSelf updateUserInfoWithLoginModel:loginModel];
        
        if (success) {
            success(YES,dataObject);
        }
        
    } failure:^(id responseObject, NSError *error) {
        if (success) {
            success(NO,@"");
        }
    }];
    
}

+ (void)updateUserInfoWithLoginModel:(LELoginModel *)loginModel{
    
//    [LELoginUserManager setUserID:loginModel.userID];
    [LELoginUserManager setNickName:loginModel.nickname];
    [LELoginUserManager setMobile:loginModel.mobile];
    [LELoginUserManager setHeadImgUrl:loginModel.headImgUrl];
    [LELoginUserManager setSex:loginModel.sex];
    [LELoginUserManager setAge:loginModel.age];
    
}

+ (void)clearUserInfo{
    
    [LELoginUserManager setUserID:nil];
}

#pragma mark -
#pragma mark - login status
+ (BOOL)hasAccoutLoggedin{
    return [self userID] && [self authToken];
}

@end
