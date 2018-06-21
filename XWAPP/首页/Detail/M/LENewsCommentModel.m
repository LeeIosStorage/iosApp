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
    return @{@"commentId"  : @"id",
             @"date"  : @"public_time",
             @"favourNum" : @"like_count",
             @"userName"  : @"nickname",
             @"avatarUrl" : @"head_img_url",
             @"userId"    : @"uid",
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
    return @{@"commentId"  : @"id",
             @"date"  : @"public_time",
             @"favourNum" : @"like_count",
             @"userName"  : @"nickname",
             @"avatarUrl" : @"head_img_url",
             @"userId"    : @"uid",
             @"comments"  : @"children",
             @"newsId"  : @"news_id",
             @"newsUrl"  : @"news_img",
             @"newsTitle"  : @"news_title",
             @"favour" : @"islike",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"comments"   : [LEReplyCommentModel class],
             };
}

@end
