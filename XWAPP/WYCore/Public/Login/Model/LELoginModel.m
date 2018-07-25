//
//  LELoginModel.m
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LELoginModel.h"

@implementation LELoginModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID":@"userId",
             @"headImgUrl":@"userHeadImg",
             @"nickname":@"nickName",
             @"regTime":@"reg_time",
             @"wxNickname" : @"wechat",
             @"readDuration" : @"read_duration",
             @"todayGolds" : @"today_golds",
             @"totalGolds" : @"total_golds",
//             @"invitationCode" : @"invitation_code",
             };
}

- (NSString *)headImgUrl{
    return [_headImgUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

@end
