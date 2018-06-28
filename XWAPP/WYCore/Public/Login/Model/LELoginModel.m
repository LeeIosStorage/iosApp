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
    return @{@"userID":@"id",
             @"headImgUrl":@"head_img_url",
             @"regTime":@"reg_time",
             @"wxNickname" : @"wechat",
             @"readDuration" : @"read_duration",
             @"todayGolds" : @"today_golds",
             @"totalGolds" : @"total_golds",
             @"invitationCode" : @"invitation_code",
             };
}

@end
