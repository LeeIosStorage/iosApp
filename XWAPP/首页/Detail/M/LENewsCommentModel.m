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
             };
}

@end

@implementation LENewsCommentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"commentId"  : @"id",
             };
}

@end
