//
//  LEEarningRankModel.m
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEEarningRankModel.h"

@implementation LEEarningRankModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"rId"  : @"id",
             @"userId" : @"uid",
             @"apprenticeCount" : @"tudi_num",
             };
}

@end
