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
    return @{@"public_time" : @"createTime"
             };
}

- (NSArray *)cover{
    NSString *urlStr = [_imgUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    return [urlStr componentsSeparatedByString:@","];
}

@end
