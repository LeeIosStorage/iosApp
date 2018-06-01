//
//  LETaskListModel.h
//  XWAPP
//
//  Created by hys on 2018/6/1.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LETaskCenterType) {
    LETaskCenterTypeNone                 = 0,
    LETaskCenterTypeGreenHandRead        = 1,         //新手阅读
    LETaskCenterTypeBindingWeixin        = 2,         //绑定微信
    LETaskCenterTypeInvitationCode       = 3,         //邀请码得红包
    LETaskCenterTypeInvitationRecruit    = 4,         //邀请收徒
    LETaskCenterTypeShowIncome           = 5,         //晒收入
    LETaskCenterTypeWakeApprentice       = 6,         //唤醒徒弟
    LETaskCenterTypeShareTimeline        = 7,         //分享朋友圈
    LETaskCenterTypeReadInformation      = 8,         //阅读资讯
    LETaskCenterTypeHighComment          = 9,         //优质评论
    LETaskCenterTypeReadPushInformation  = 10,        //阅读推送资讯
    LETaskCenterTypeQuestionnaire        = 11,        //问卷调查
};

@interface LETaskListModel : NSObject

@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *taskTitle;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, assign) LETaskCenterType taskType;
@property (nonatomic, assign) NSInteger taskStatus;

@property (nonatomic, strong) NSString *coin;
@property (nonatomic, assign) NSInteger coinType;

@end
