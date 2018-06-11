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
    
    NSString *filePath = [[PathHelper documentDirectoryPathWithName:HitoDataFileCatalog] stringByAppendingPathComponent:name];
    return filePath;
}

//栏目排序
- (NSArray *)getInUseChannelArray{
    
    NSString* path = [self getStorePath:@"inUseChannel.data"];
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
    
    NSString* path = [self getStorePath:@"inUseChannel.data"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:path atomically:NO];
    });
    
}

//搜索记录
- (NSArray *)getSearchRecordArray{
    NSString *path = [self getStorePath:@"newsSearchRecord.xml"];
    NSArray *recordArray = [[NSArray alloc] initWithContentsOfFile:path];
    return recordArray;
}

- (void)saveSearchRecordWithArray:(NSArray *)array{
    
    NSMutableArray *recordArray = [NSMutableArray arrayWithArray:array];
    if (!recordArray) {
        recordArray = [NSMutableArray array];
    }
//    BOOL isAdd = YES;
//    for (NSString *obj in recordArray) {
//        if ([obj isEqualToString:content]) {
//            isAdd = NO;
//            break;
//        }
//    }
//    if (!isAdd) {
//        [recordArray removeObject:content];
//    }
//    [recordArray insertObject:content atIndex:0];
    
    NSString *path = [self getStorePath:@"newsSearchRecord.xml"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [recordArray writeToFile:path atomically:NO];
    });
    
}

@end
