//
//  WYCommonUtils.h
//  XWAPP
//
//  Created by hys on 2018/5/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LENewsListCellTypeNormal   = 0,        // 默认的样式(首页)
    LENewsListCellTypePersonal = 1,        // 个人主页样式
} LENewsListCellType;

@interface WYCommonUtils : NSObject

/*! @brief 单纯获取text的Width (Height固定的)
 *
 *  @param  text: 文本
 *  @param  font: 字体
 *  @param  lineBreakMode: lineBreakMode 默认为NSLineBreakByWordWrapping = 0
 *  @return text的Width
 */
+ (float)widthWithText:(NSString *)text font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *  根据固定的Width 计算 AttributedString 的Size
 *
 *  @param text        文本
 *  @param lineSpacing 行高（对应getAttributedStringWithString:lineSpacing:alignment:）
 *  @param font        自定义字体
 *  @param width       固定的Width
 *
 *  @return text的Size
 */
+ (CGSize)sizeWithAttributedText:(NSString *)text lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font width:(float)width;
/**
 *  NSString转为NSAttributedString
 *
 *  @param string      NSString
 *  @param lineSpacing 行高（对应sizeWithAttributedText:lineSpacing:font:width方法）
 *  @param alignment   NSTextAlignment
 *
 *  @return NSAttributedString
 */
+ (NSAttributedString *)getAttributedStringWithString:(NSString*)string lineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment;

#pragma mark -
#pragma mark - 富文本
//颜色 字体
+(NSMutableAttributedString *)stringToColorAndFontAttributeString:(NSString *)text range:(NSRange)range font:(UIFont *)font color:(UIColor *)color;

#pragma mark -
#pragma mark - Time
//时间格式化
+ (NSDate *)dateFromUSDateString:(NSString *)string;
//显示时间格式:刚刚>>几分钟前>>几小时前>>几天前>>具体时间
+ (NSString *)dateDiscriptionFromNowBk:(NSDate *)date;
//显示时间格式:MM/dd HH:mm
+ (NSString *)dateDiscriptionFromDate:(NSDate *)date;
//显示时间格式:yyyy-MM-dd HH:mm:ss
+ (NSString*)dateYearToSecondDiscriptionFromDate:(NSDate*)date;
//显示时间格式:HH:mm
+ (NSString*)dateHourToMinuteDiscriptionFromDate:(NSDate*)date;
//显示格式:今天,昨天
+ (NSString*)dateDayToDayDiscriptionFromDate:(NSDate*)date;
//年龄
+ (int)getAgeWithBirthdayDate:(NSDate *)date;
//倒计时 dateStr:秒数
+ (NSString *)secondChangToDateString:(NSString *)dateStr;
//date转时间戳
+(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;

#pragma mark -
#pragma mark - Other
//加载图片 默认背景颜色
+ (void)setImageWithURL:(NSURL *)url setImage:(UIImageView *)imageView setbitmapImage:(UIImage *)bitmapImage;
//圆角图片
+ (void)setImageWithURL:(NSURL *)url setImageView:(UIImageView *)imageView setbitmapImage:(UIImage *)bitmapImage radius:(CGFloat)radius;

//url的Param
+(NSDictionary *)getParamDictFromUrl:(NSURL *)url;

+(NSString *)numberFormatWithNum:(int)num;

#pragma mark -
#pragma mark - 动画
//👍
+ (void)popOutsideWithDuration:(NSTimeInterval)duration view:(UIView *)view;
//👎
+ (void)popInsideWithDuration:(NSTimeInterval)duration view:(UIView *)view;
//添加阴影 mode=1从下往上渐变
+ (void)addShadowWithView:(UIView *)view mode:(NSInteger)mode size:(CGSize)size;

#pragma mark - string 比较
+ (BOOL)isEqualWithUserId:(NSString *)uid;

#pragma mark - 设备标识
+ (NSString *)UUIDString;

#pragma mark - common
+ (UIViewController *)getCurrentVC;

@end
