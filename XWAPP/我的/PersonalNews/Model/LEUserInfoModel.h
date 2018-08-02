//
//  LEUserInfoModel.h
//  XWAPP
//
//  Created by hys on 2018/7/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEUserInfoModel : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *userHeadImg;
@property (strong, nonatomic) NSString *introduction;
@property (assign, nonatomic) int readCount;
@property (assign, nonatomic) int newsCount;
@property (assign, nonatomic) int attentionCount;
@property (assign, nonatomic) BOOL isAttention;

@end
