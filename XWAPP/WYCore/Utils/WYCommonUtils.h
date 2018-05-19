//
//  WYCommonUtils.h
//  XWAPP
//
//  Created by hys on 2018/5/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYCommonUtils : NSObject

#pragma mark -
#pragma mark - Time
//时间格式化
+ (NSDate *)dateFromUSDateString:(NSString *)string;
//显示时间格式:刚刚>>几分钟前>>几小时前>>几天前>>具体时间
+ (NSString *)dateDiscriptionFromNowBk:(NSDate *)date;
//显示时间格式:MM/dd HH:mm
+ (NSString *)dateDiscriptionFromDate:(NSDate *)date;

#pragma mark -
#pragma mark - Other
//加载图片 默认背景颜色
+ (void)setImageWithURL:(NSURL *)url setImage:(UIImageView *)imageView setbitmapImage:(UIImage *)bitmapImage;

@end
