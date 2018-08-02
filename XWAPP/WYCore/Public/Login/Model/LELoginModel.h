//
//  LELoginModel.h
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEBaseModel.h"

@interface LELoginModel : LEBaseModel

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *headImgUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *birthdayDate;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *regTime;
@property (strong, nonatomic) NSString *introduction;
@property (assign, nonatomic) int announcementNum;
@property (assign, nonatomic) int noticeNum;

@property (strong, nonatomic) NSString *occupation;
@property (strong, nonatomic) NSString *education;
@property (strong, nonatomic) NSString *wxNickname;

@property (strong, nonatomic) NSString *invitationCode;
@property (assign, nonatomic) double readDuration;
@property (assign, nonatomic) double balance;
@property (assign, nonatomic) double income;
@property (assign, nonatomic) NSInteger todayGolds;
@property (assign, nonatomic) NSInteger totalGolds;

@end
