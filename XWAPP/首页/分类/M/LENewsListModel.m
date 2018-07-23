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
    return @{@"souce"  : @"source",
             @"favoriteId"  : @"fid",
             @"public_time" : @"createTime",
             @"commentCount" : @"commentsCount"
             };
}

- (NSArray *)cover{
    NSString *urlStr = [_imgUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    return [urlStr componentsSeparatedByString:@","];
}

@end
