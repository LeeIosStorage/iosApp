//
//  LENewsListModel.m
//  XWAPP
//
//  Created by hys on 2018/5/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LENewsListModel.h"

@implementation LENewsListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsId"  : @"id",
             @"favoriteId"  : @"fid",
             @"public_time" : @"publish_time",
             @"commentCount" : @"comments_count"
             };
}

@end
