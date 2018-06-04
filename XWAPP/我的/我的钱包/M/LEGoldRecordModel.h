//
//  LEGoldRecordModel.h
//  XWAPP
//
//  Created by hys on 2018/6/4.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEGoldRecordModel : NSObject

@property (strong, nonatomic) NSString *rId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *gold;
@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) int recordType;

@end
