//
//  LELoginAuthManager.h
//  XWAPP
//
//  Created by hys on 2018/5/31.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
#import "WYNetWorkManager.h"
#import "LETaskListModel.h"

typedef void(^LoginAuthBindingSuccessBlock)(BOOL success);

@interface LELoginAuthManager : NSObject

@property (strong, nonatomic) NSMutableArray *taskList;
@property (strong, nonatomic) NSDictionary *globalTaskConfig;

@property (assign, nonatomic) BOOL isInReviewVersion;

+ (LELoginAuthManager *)sharedInstance;

//微信授权绑定
- (void)socialAuthBinding:(UMSocialPlatformType)loginType presentingController:(UIViewController *)presentingController success:(LoginAuthBindingSuccessBlock)success;

//任务配置信息
- (void)getGlobalTaskConfigRequestSuccess:(LoginAuthBindingSuccessBlock)success;

//完成某个任务
- (void)updateUserTaskStateRequestWith:(NSString *)taskId success:(LoginAuthBindingSuccessBlock)success;

//刷新任务列表
- (void)refreshTaskInfoRequestSuccess:(WYRequestSuccessBlock)success failure:(WYRequestFailureBlock)failure;

//对应任务是否完后
- (BOOL)taskCompletedWithTaskType:(LETaskCenterType)taskType;
//新手任务是否都完成
- (BOOL)taskCompletedWithGreenHandTask;
//获取对应的任务信息
- (LETaskListModel *)getTaskWithTaskType:(LETaskCenterType)taskType;

- (void)checkUpdateWithAppID:(NSString *)appID;

@end
