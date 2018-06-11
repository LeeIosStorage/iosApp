//
//  LENewsDetailModel.h
//  XWAPP
//
//  Created by hys on 2018/5/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LENewsListModel.h"

@interface LENewsDetailModel : NSObject

@property (strong, nonatomic) NSNumber *contentHeight;
@property (strong, nonatomic) NSMutableAttributedString *contentAttributedString;

@property (strong, nonatomic) YYTextLayout *textLayout;

@property (strong, nonatomic) LENewsListModel *info;

@end
