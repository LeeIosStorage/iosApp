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

- (NSString *)avatarUrl{
    return [_avatarUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
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
             @"newsUrl"  : @"imgUrl",
             @"newsTitle"  : @"title",
             @"favour" : @"islike",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"comments"   : [LEReplyCommentModel class],
             };
}

- (NSString *)avatarUrl{
    return [_avatarUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

- (NSArray *)cover{
    NSString *urlStr = [_newsUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    return [urlStr componentsSeparatedByString:@","];
}

@end
