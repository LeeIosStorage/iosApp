//
//  YTCache.m
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#import "YTCache.h"

@implementation YTCache

+ (instancetype)sharedCache
{
    static YTCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[self alloc] init];
    });
    return cache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.commonCache = [YYCache cacheWithName:YTCache_Name];
        self.commonCache.memoryCache.didReceiveMemoryWarningBlock = ^(YYMemoryCache *cache){
            LELog(@"收到缓存警告====%lu",(unsigned long)cache.totalCost);
        };
    }
    return self;
}

@end
