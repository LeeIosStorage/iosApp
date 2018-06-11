//
//  LEElementStyleBox.h
//  XWAPP
//
//  Created by hys on 2018/5/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEElementStyleBox : NSObject

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

+ (LEElementStyleBox *)createBox;

- (void)setPropertyWithStyleDic:(NSDictionary *)attributes;

@end
