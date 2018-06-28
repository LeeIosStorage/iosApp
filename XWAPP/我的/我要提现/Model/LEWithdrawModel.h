//
//  LEWithdrawModel.h
//  XWAPP
//
//  Created by hys on 2018/6/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEWithdrawModel : NSObject

@property (strong, nonatomic) NSString *wId;
@property (strong, nonatomic) NSString *money;

@property (assign, nonatomic) BOOL isSelected;

//方式
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *icon;
@property (assign, nonatomic) NSInteger way;

@end
