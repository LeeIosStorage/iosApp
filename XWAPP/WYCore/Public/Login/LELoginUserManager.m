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
#import "LELoginAuthManager.h"

NSString *const kUserInfoUserID = @"kUserInfoUserID";
NSString *const kUserInfoNickname = @"kUserInfoNickname";
NSString *const kUserInfoAvatar = @"kUserInfoAvatar";
NSString *const kUserInfoMobile = @"kUserInfoMobile";
NSString *const kUserInfoSex = @"kUserInfoSex";
NSString *const kUserInfoAge = @"kUserInfoAge";
NSString *const kUserInfoRegTime = @"kUserInfoRegTime";
NSString *const kUserInfoIntro = @"kUserInfoIntro";
NSString *const kUserInfoAnnouncementNum = @"kUserInfoAnnouncementNum";
NSString *const kUserInfoNoticeNum = @"kUserInfoNoticeNum";
NSString *const kUserInfoWxNickname = @"kUserInfoWxNickname";
NSString *const kUserInfoOccupation = @"kUserInfoOccupation";
NSString *const kUserInfoEducation = @"kUserInfoEducation";
NSString *const kUserInfoReadDuration = @"kUserInfoReadDuration";
NSString *const kUserInfoInvitationCode = @"kUserInfoInvitationCode";
NSString *const kUserInfoTodayGolds = @"kUserInfoTodayGolds";
NSString *const kUserInfoTotalGolds = @"kUserInfoTotalGolds";
NSString *const kUserInfoBalance = @"kUserInfoBalance";
NSString *const kUserInfoIncome = @"kUserInfoIncome";

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

+ (NSString *)introduction{
    return [self objectFromUserDefaultsKey:kUserInfoIntro];
}
+ (void)setIntroduction:(NSString *)introduction{
    [self saveToUserDefaultsObject:introduction forKey:kUserInfoIntro];
}

+ (int)announcementNum{
    return [[self objectFromUserDefaultsKey:kUserInfoAnnouncementNum] intValue];
}
+ (void)setAnnouncementNum:(int)announcementNum{
    [self saveToUserDefaultsObject:[NSNumber numberWithInt:announcementNum] forKey:kUserInfoAnnouncementNum];
}

+ (int)noticeNum{
    return [[self objectFromUserDefaultsKey:kUserInfoNoticeNum] intValue];
}
+ (void)setNoticeNum:(int)noticeNum{
    [self saveToUserDefaultsObject:[NSNumber numberWithInt:noticeNum] forKey:kUserInfoNoticeNum];
}

+ (NSString *)wxNickname{
    return [self objectFromUserDefaultsKey:kUserInfoWxNickname];
}
+ (void)setWxNickname:(NSString *)wxNickname{
    [self saveToUserDefaultsObject:wxNickname forKey:kUserInfoWxNickname];
}

+ (NSString *)occupation{
    return [self objectFromUserDefaultsKey:kUserInfoOccupation];
}
+ (void)setOccupation:(NSString *)occupation{
    [self saveToUserDefaultsObject:occupation forKey:kUserInfoOccupation];
}

+ (NSString *)education{
    return [self objectFromUserDefaultsKey:kUserInfoEducation];
}
+ (void)setEducation:(NSString *)education{
    [self saveToUserDefaultsObject:education forKey:kUserInfoEducation];
}

+ (NSString *)invitationCode{
    return [self objectFromUserDefaultsKey:kUserInfoInvitationCode];
}
+ (void)setInvitationCode:(NSString *)invitationCode{
    [self saveToUserDefaultsObject:invitationCode forKey:kUserInfoInvitationCode];
}

+ (double)readDuration{
    return [[self objectFromUserDefaultsKey:kUserInfoReadDuration] doubleValue];
}
+ (void)setReadDuration:(double)readDuration{
    [self saveToUserDefaultsObject:[NSNumber numberWithDouble:readDuration] forKey:kUserInfoReadDuration];
}

+ (double)balance{
    return [[self objectFromUserDefaultsKey:kUserInfoBalance] doubleValue];
}
+ (void)setBalance:(double)balance{
    [self saveToUserDefaultsObject:[NSNumber numberWithDouble:balance] forKey:kUserInfoBalance];
}

+ (double)income{
    return [[self objectFromUserDefaultsKey:kUserInfoIncome] doubleValue];
}
+ (void)setIncome:(double)income{
    [self saveToUserDefaultsObject:[NSNumber numberWithDouble:income] forKey:kUserInfoIncome];
}

+ (NSInteger)todayGolds{
    return [[self objectFromUserDefaultsKey:kUserInfoTodayGolds] integerValue];
}
+ (void)setTodayGolds:(NSInteger)todayGolds{
    [self saveToUserDefaultsObject:[NSNumber numberWithInteger:todayGolds] forKey:kUserInfoTodayGolds];
}

+ (NSInteger)totalGolds{
    return [[self objectFromUserDefaultsKey:kUserInfoTotalGolds] integerValue];
}
+ (void)setTotalGolds:(NSInteger)totalGolds{
    [self saveToUserDefaultsObject:[NSNumber numberWithInteger:totalGolds] forKey:kUserInfoTotalGolds];
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
        [WeakSelf updateUserInfoWithLoginModel:loginModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUILoginNotificationKey object:nil];
        
//        [[LELoginAuthManager sharedInstance] getGlobalTaskConfigRequestSuccess:^(BOOL success) {
//
//        }];
        
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
    [LELoginUserManager setIntroduction:loginModel.introduction];
    [LELoginUserManager setAnnouncementNum:loginModel.announcementNum];
    [LELoginUserManager setNoticeNum:loginModel.noticeNum];
    [LELoginUserManager setWxNickname:loginModel.wxNickname];
    [LELoginUserManager setOccupation:loginModel.occupation];
    [LELoginUserManager setEducation:loginModel.education];
    [LELoginUserManager setInvitationCode:loginModel.invitationCode];
    [LELoginUserManager setReadDuration:loginModel.readDuration];
    [LELoginUserManager setBalance:loginModel.balance];
    [LELoginUserManager setIncome:loginModel.income];
    [LELoginUserManager setTodayGolds:loginModel.todayGolds];
    [LELoginUserManager setTotalGolds:loginModel.totalGolds];
    
}

+ (void)clearUserInfo{
    
    [LELoginUserManager setUserID:nil];
    [LELoginUserManager setAuthToken:nil];
    [LELoginUserManager setNickName:nil];
    [LELoginUserManager setMobile:nil];
    [LELoginUserManager setHeadImgUrl:nil];
    [LELoginUserManager setSex:nil];
    [LELoginUserManager setAge:nil];
    [LELoginUserManager setWxNickname:nil];
    [LELoginUserManager setOccupation:nil];
    [LELoginUserManager setEducation:nil];
    [LELoginUserManager setInvitationCode:nil];
    [LELoginUserManager setIntroduction:nil];
    [LELoginUserManager setAnnouncementNum:0];
    [LELoginUserManager setNoticeNum:0];
    [LELoginUserManager setReadDuration:0];
    [LELoginUserManager setBalance:0.0];
    [LELoginUserManager setIncome:0.0];
    [LELoginUserManager setTodayGolds:0];
    [LELoginUserManager setTotalGolds:0];
}

#pragma mark -
#pragma mark - login status
+ (BOOL)hasAccoutLoggedin{
    return [self userID] && [self authToken];
}

@end
