//
//  LEDataStoreManager.m
//  XWAPP
//
//  Created by hys on 2018/5/18.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEDataStoreManager.h"
#import "PathHelper.h"
#import "LEChannelModel.h"

@implementation LEDataStoreManager

static LEDataStoreManager *_instance = nil;
+ (LEDataStoreManager *)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

//无关用户
- (NSString *)getStorePath:(NSString *)name{
//    NSString *fileName = [NSString stringWithFormat:@"%@/%@",HitoDataFileCatalog,name];
    NSString *filePath = [PathHelper documentDirectoryPathWithName:HitoDataFileCatalog];
    return filePath;
}

- (NSArray *)getInUseChannelArray{
    
    NSString* path = [[self getStorePath:nil] stringByAppendingPathComponent:@"inUseChannel.data"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    if (!data) {
        return nil;
    }
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *modelArray = [NSArray modelArrayWithClass:[LEChannelModel class] json:jsonObject];
    return modelArray;
}

- (void)saveInUseChannelWithArray:(NSArray *)array{
    
    NSMutableArray *cacheChannel = [[NSMutableArray alloc] initWithArray:array];
    NSData *data = [cacheChannel modelToJSONData];
    
    NSString* path = [[self getStorePath:nil] stringByAppendingPathComponent:@"inUseChannel.data"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL b = [data writeToFile:path atomically:NO];
//        NSLog(@"保存:%d",b);
    });
    
}

@end
