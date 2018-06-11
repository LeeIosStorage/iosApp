//
//  YTCache.h
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YTCache_Name @"WYCache"

@interface YTCache : NSObject

/**
 公共缓存
 */
@property (strong, nonatomic) YYCache *commonCache;

+ (instancetype)sharedCache;

@end
