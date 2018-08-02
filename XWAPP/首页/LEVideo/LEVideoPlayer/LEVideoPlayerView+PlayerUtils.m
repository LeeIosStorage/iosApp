//
//  LEVideoPlayerView+PlayerUtils.m
//  XWAPP
//
//  Created by hys on 2018/7/13.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEVideoPlayerView.h"

@implementation LEVideoPlayerView (PlayerUtils)

- (NSString *)convertTime:(CGFloat)second
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:GTMzone];
    
    if (second / 3600 >= 1) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"mm:ss"];
    }
    
    NSString *showtimeNew = [dateFormatter stringFromDate:d];
    return showtimeNew;
}

@end
