//
//  LEHotNewsModel.m
//  XWAPP
//
//  Created by hys on 2018/6/7.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEHotNewsModel.h"

@implementation LEHotNewsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsId"  : @"id",
             @"public_time" : @"publish_time"
             };
}

@end
