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

- (NSArray *)getInUseChannelArray;
- (void)saveInUseChannelWithArray:(NSArray *)array;

@end
