//
//  MineController.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/27.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LESuperViewController.h"

@class MineNaView;

@interface MineController : LESuperViewController

HitoPropertyNSMutableArray(secondArr);
HitoPropertyNSMutableArray(fourArr);
HitoPropertyNSMutableArray(imageArr);

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MineNaView *naView;

/** 点击tabBar主动刷新页面 */
- (void)tabBarSelectRefreshData;

@end
