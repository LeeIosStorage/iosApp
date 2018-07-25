//
//  LEHotNewsModel.h
//  XWAPP
//
//  Created by hys on 2018/6/7.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEHotNewsModel : NSObject

@property (nonatomic, strong) NSString *newsId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *public_time;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSArray *cover;

@property (nonatomic, assign) int typeId;//0图文1视频

@end
