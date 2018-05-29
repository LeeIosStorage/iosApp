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
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"comments"   : [LEReplyCommentModel class],
             };
}

@end
