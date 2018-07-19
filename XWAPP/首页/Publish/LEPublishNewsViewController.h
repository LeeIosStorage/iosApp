//
//  LEPublishNewsViewController.h
//  XWAPP
//
//  Created by hys on 2018/7/18.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"

typedef enum : NSUInteger {
    LEPublishNewsVcTypePhoto = 0,        // 发布图片
    LEPublishNewsVcTypeVideo = 1,        // 发布视频
} LEPublishNewsVcType;

@interface LEPublishNewsViewController : LESuperViewController

@property (nonatomic, assign) LEPublishNewsVcType vcType;

@end
