//
//  LEElementStyleBox.m
//  XWAPP
//
//  Created by hys on 2018/5/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEElementStyleBox.h"

@implementation LEElementStyleBox

+ (LEElementStyleBox *)createBox
{
    LEElementStyleBox *box = [[LEElementStyleBox alloc] init];
    return box;
}

- (void)setPropertyWithStyleDic:(NSDictionary *)attributes{
    
    NSArray *allKeys = attributes.allKeys;
    for (NSString *key in allKeys) {
        if ([key isEqualToString:@"data-size"]) {
            NSString *value = [attributes objectForKey:key];
            NSArray *array = [value componentsSeparatedByString:@","];
            if (array.count > 1) {
                self.width = [[array objectAtIndex:0] floatValue];
                self.height = [[array objectAtIndex:1] floatValue];
            }
        }
    }
    //第二种方式获取宽高
    if ([[attributes objectForKey:@"img_width"] floatValue] > 0 && [[attributes objectForKey:@"img_height"] floatValue] > 0) {
        self.width = [[attributes objectForKey:@"img_width"] floatValue];
        self.height = [[attributes objectForKey:@"img_height"] floatValue];
    }
    
}

@end
