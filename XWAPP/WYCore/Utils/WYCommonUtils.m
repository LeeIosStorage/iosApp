//
//  WYCommonUtils.m
//  XWAPP
//
//  Created by hys on 2018/5/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "WYCommonUtils.h"
#import "UIImageView+WebCache.h"
#import "UIImage+LEAdd.h"

#define DAY_SECOND 60*60*24

@implementation WYCommonUtils

+ (CGSize)sizeWithAttributedText:(NSString *)text lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font width:(float)width{
    
    NSUInteger length = [text length];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    [attrString addAttributes:attributes range:NSMakeRange(0, length)];
    //NSStringDrawingUsesFontLeading 不需要这个属性
    CGSize textSize = [attrString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return textSize;
}

+ (NSAttributedString *)getAttributedStringWithString:(NSString*)string lineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment{
    NSUInteger length = [string length];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = lineSpacing;
    style.alignment = alignment;
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    return attrString;
}

#pragma mark -
#pragma mark - 富文本
+(NSMutableAttributedString *)stringToColorAndFontAttributeString:(NSString *)text range:(NSRange)range font:(UIFont *)font color:(UIColor *)color{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    if (color) {
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:range];
    }
    if (font) {
        [attStr addAttribute:NSFontAttributeName
                       value:font
                       range:range];
    }
    if (color && font) {
        NSDictionary *attributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:color};
        [attStr addAttributes:attributes range:range];
    }
    return attStr;
}

#pragma mark -
#pragma mark - Time
static NSDateFormatter *s_dateFormatterOFUS = nil;
static bool dateFormatterOFUSInvalid;
+ (NSDate *)dateFromUSDateString:(NSString *)string{
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    @synchronized(self){
        if (s_dateFormatterOFUS == nil || dateFormatterOFUSInvalid) {
            s_dateFormatterOFUS = [[NSDateFormatter alloc] init];
            [s_dateFormatterOFUS setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [s_dateFormatterOFUS setLocale:usLocale];
            dateFormatterOFUSInvalid = NO;
        }
    }
    
    NSDateFormatter *dateFormatter = s_dateFormatterOFUS;
    NSDate *date = nil;
    @synchronized(dateFormatter){
        @try{
            date = [dateFormatter dateFromString:string];
        }
        @catch (NSException *exception){
            dateFormatterOFUSInvalid = YES;
        }
    }
    return date;
}

+ (NSString *)dateDiscriptionFromNowBk:(NSDate *)date{
    NSString *timestamp = nil;
    NSDate *nowDate = [NSDate date];
    if (date == nil) {
        return @"";
    }
    int distance = [nowDate timeIntervalSinceDate:date];
    if (distance < 0) {
        distance = 0;
    }
    NSCalendar *calender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    
//    NSDateComponents *tempComps = [calender components:unitFlags fromDate:nowDate toDate:date options:NSCalendarWrapComponents];
    
    if (distance > 0) {
        if (distance < 60) {
            timestamp = [NSString stringWithFormat:@"刚刚"];
        }else if (distance < 60*60) {
            timestamp = [NSString stringWithFormat:@"%d%@",distance/60,@"分钟前"];
        }else if (distance < DAY_SECOND){
            timestamp = [NSString stringWithFormat:@"%d%@",distance/(60*60),@"小时前"];
        }else if (distance < DAY_SECOND*9){
            timestamp = [NSString stringWithFormat:@"%d%@",distance/(DAY_SECOND),@"天前"];
        }else{
            if (comps.year == compsNow.year) {
                timestamp = [NSString stringWithFormat:@"%d月%d日", (int)comps.month, (int)comps.day];
            }else{
                timestamp = [NSString stringWithFormat:@"%04d.%02d.%02d %02d:%02d", (int)comps.year, (int)comps.month, (int)comps.day, (int)comps.hour, (int)comps.minute];
            }
        }
    }else{
        timestamp = [NSString stringWithFormat:@"%04d.%02d.%02d %02d:%02d", (int)comps.year, (int)comps.month, (int)comps.day, (int)comps.hour, (int)comps.minute];
    }
    
    return timestamp;
}

+ (NSString*)dateDiscriptionFromDate:(NSDate*)date{
    NSString *_timestamp = nil;
    NSDate* nowDate = [NSDate date];
    if (date == nil) {
        return @"";
    }
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    
    if (comps.year == compsNow.year){
        _timestamp = [NSString stringWithFormat:@"%02d/%02d %02d:%02d", (int)comps.month, (int)comps.day, (int)comps.hour, (int)comps.minute];
    } else {
        _timestamp = [NSString stringWithFormat:@"%04d/%02d/%02d %02d:%02d", (int)comps.year, (int)comps.month, (int)comps.day, (int)comps.hour, (int)comps.minute];
    }
    
    return _timestamp;
}

+ (NSString*)dateYearToSecondDiscriptionFromDate:(NSDate*)date{
    NSString *_timestamp = nil;
    if (date == nil) {
        return @"";
    }
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    
    _timestamp = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d", (int)comps.year, (int)comps.month, (int)comps.day, (int)comps.hour, (int)comps.minute,(int)comps.second];
    
    return _timestamp;
}

+ (int)getAgeWithBirthdayDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *birth = [dateFormatter stringFromDate:date];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSLog(@"currentDate %@ birthDay %@",currentDateStr,birth);
    NSTimeInterval time = [currentDate timeIntervalSinceDate:birthDay];
    int age = ((int)time)/(3600*24*365);
    NSLog(@"year %d",age);
    return age;
}

+ (NSString *)secondChangToDateString:(NSString *)dateStr {
    
    if (dateStr.length == 0) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    int hour = (int)time/(60*60);
    int minute = (time/60)%60;
    int second = time%60;
    
    NSString *ts = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute,second];
    return ts;
}

#pragma mark -
#pragma mark - Other
+ (void)setImageWithURL:(NSURL *)url setImage:(UIImageView *)imageView setbitmapImage:(UIImage *)bitmapImage{
    if (![url isEqual:[NSNull null]]) {
        
        __block BOOL isBig = NO;
        [imageView sd_setImageWithURL:url placeholderImage:bitmapImage options:SDWebImageRetryFailed  progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
            if(expectedSize / 1024 > 400) {
                //如果图片过大,处理一下
                isBig = YES;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!isBig) {
                if (image && cacheType == SDImageCacheTypeNone) {
                    imageView.alpha = 0.0;
                    [UIView transitionWithView:imageView
                                      duration:1.0
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        [imageView setImage:image];
                                        imageView.alpha = 1.0;
                                    } completion:NULL];
                }
            } else {
                imageView.alpha = 0.0;
                [UIView transitionWithView:imageView
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    if(image.images.count >= 2) {
                                        [imageView setImage:image];
                                    } else {
                                        //UIImage *image = [self ima];
                                        [imageView setImage:[image imageCompressForTargetSize:imageView.size]];
                                    }
                                    
                                    imageView.alpha = 1.0;
                                } completion:NULL];
                
            }
        }];
    }else{
        [imageView sd_setImageWithURL:nil];
        [imageView setImage:bitmapImage];
    }
}

#pragma mark -
#pragma mark - 动画
//👍
+ (void)popOutsideWithDuration:(NSTimeInterval)duration view:(UIView *)view{
    
    view.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            view.transform = CGAffineTransformMakeScale(1.7f, 1.7f); // 放大
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            view.transform = CGAffineTransformMakeScale(0.8f, 0.8f); // 放小
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            view.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
        }];
    } completion:nil];
}

+ (void)popInsideWithDuration:(NSTimeInterval)duration view:(UIView *)view{
    
    view.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations: ^{
            view.transform = CGAffineTransformMakeScale(0.7f, 0.7f); // 放小
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations: ^{
            view.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
        }];
    } completion:nil];
}

@end
