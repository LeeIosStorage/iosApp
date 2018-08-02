//
//  LEVideoListViewController.h
//  XWAPP
//
//  Created by hys on 2018/7/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"

@interface LEVideoListViewController : LESuperViewController

@property (nonatomic, copy) NSString *tagTitle;
@property (nonatomic, copy) NSString *channelId;

/** 进入栏目刷新Data */
- (void)refreshData;
/** 点击tabBar主动刷新页面 */
- (void)tabBarSelectRefreshData;

@end
