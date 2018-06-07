//
//  LEEarningRankModel.h
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEEarningRankModel : NSObject

@property (strong, nonatomic) NSString *rId;
@property (strong, nonatomic) NSString *userId;
@property (assign, nonatomic) int apprenticeCount;
@property (strong, nonatomic) NSString *money;

@end
