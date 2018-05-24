//
//  LEDataStoreManager.h
//  XWAPP
//
//  Created by hys on 2018/5/18.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEDataStoreManager : NSObject

+ (LEDataStoreManager *)shareInstance;

//首页栏目排序
- (NSArray *)getInUseChannelArray;
- (void)saveInUseChannelWithArray:(NSArray *)array;

//新闻搜索记录
- (NSArray *)getSearchRecordArray;
- (void)saveSearchRecordWithArray:(NSArray *)array;

@end
