//
//  LENewsCommentModel.m
//  XWAPP
//
//  Created by hys on 2018/5/19.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LENewsCommentModel.h"

@implementation LEReplyCommentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"commentId"  : @"commentId",
             @"date"  : @"createTime",
             @"favourNum" : @"likeCount",
             @"userName"  : @"nickName",
             @"avatarUrl" : @"userHeadImg",
             @"userId"    : @"userId",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"children"   : [LEReplyCommentModel class],
             };
}

@end

@implementation LENewsCommentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"commentId"  : @"commentId",
             @"date"  : @"createTime",
             @"favourNum" : @"likeCount",
             @"userName"  : @"nickName",
             @"avatarUrl" : @"userHeadImg",
             @"userId"    : @"userId",
             @"comments"  : @"children",
             @"newsId"  : @"newsId",
             @"newsUrl"  : @"newsImg",
             @"newsTitle"  : @"newsTitle",
             @"favour" : @"islike",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"comments"   : [LEReplyCommentModel class],
             };
}

@end
