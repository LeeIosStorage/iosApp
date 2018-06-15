//
//  LETaskListModel.m
//  XWAPP
//
//  Created by hys on 2018/6/1.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LETaskListModel.h"

@implementation LETaskListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"taskId"  : @"t_id",
             @"taskTitle" : @"t_name",
             @"taskStatus" : @"t_is_completed",
             @"type" : @"t_type",
             @"coin" : @"t_value",
             @"coinType" : @"t_value_type",
             };
}

- (LETaskCenterType)taskType{
    NSString *taskId = [self.taskId description];
    if ([taskId isEqualToString:@"1"]) {
        return LETaskCenterTypeGreenHandRead;
    }else if ([taskId isEqualToString:@"2"]){
        return LETaskCenterTypeBindingWeixin;
    }else if ([taskId isEqualToString:@"3"]){
        return LETaskCenterTypeInvitationCode;
    }else if ([taskId isEqualToString:@"4"]){
        return LETaskCenterTypeInvitationRecruit;
    }else if ([taskId isEqualToString:@"5"]){
        return LETaskCenterTypeShowIncome;
    }else if ([taskId isEqualToString:@"6"]){
        return LETaskCenterTypeWakeApprentice;
    }else if ([taskId isEqualToString:@"7"]){
        return LETaskCenterTypeShareTimeline;
    }else if ([taskId isEqualToString:@"8"]){
        return LETaskCenterTypeReadInformation;
    }else if ([taskId isEqualToString:@"9"]){
        return LETaskCenterTypeHighComment;
    }else if ([taskId isEqualToString:@"10"]){
        return LETaskCenterTypeReadPushInformation;
    }else if ([taskId isEqualToString:@"11"]){
        return LETaskCenterTypeQuestionnaire;
    }
    return LETaskCenterTypeNone;
}

@end
