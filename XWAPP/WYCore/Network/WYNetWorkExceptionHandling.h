//
//  WYNetWorkExceptionHandling.h
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYNetworkHeader.h"

@interface WYNetWorkExceptionHandling : NSObject

+ (BOOL)judgeReuqestStatus:(WYRequestType)type URLString:(NSString *)URLString;

+ (void)showProgressHUDWith:(NSString *)message URLString:(NSString *)URLString;

@end
