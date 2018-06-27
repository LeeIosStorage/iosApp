//
//  LEGoldRecordModel.m
//  XWAPP
//
//  Created by hys on 2018/6/4.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEGoldRecordModel.h"

@implementation LEGoldRecordModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"rId"  : @"id",
             @"gold" : @"golds",
             @"date" : @"publish_time",
             @"title" : @"source_type",
             };
}

@end
