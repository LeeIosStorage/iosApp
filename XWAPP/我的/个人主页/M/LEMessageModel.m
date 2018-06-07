//
//  LEMessageModel.m
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEMessageModel.h"

@implementation LEMessageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"messageId"  : @"id",
             };
}

@end
