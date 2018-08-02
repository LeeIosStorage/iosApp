//
//  LEUserInfoModel.m
//  XWAPP
//
//  Created by hys on 2018/7/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEUserInfoModel.h"

@implementation LEUserInfoModel

- (NSString *)userHeadImg{
    return [_userHeadImg stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

@end
