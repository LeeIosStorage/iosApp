//
//  LENewsTabBaseViewController.h
//  XWAPP
//
//  Created by hys on 2018/7/20.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"

@interface LENewsTabBaseViewController : LESuperViewController

@property (assign, nonatomic) NSInteger vcType;//0文章 1视频

@property (strong, nonatomic) NSString *userId;

@end
