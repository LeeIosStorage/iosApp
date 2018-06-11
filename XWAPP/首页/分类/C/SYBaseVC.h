//
//  SYBaseVC.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"

@interface SYBaseVC : LESuperViewController

@property (nonatomic, copy) NSString *tagTitle;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)refreshData;
/** 点击tabBar主动刷新页面 */
- (void)tabBarSelectRefreshData;

@end
