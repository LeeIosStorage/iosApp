//
//  TaskCenterController.h
//  XWAPP
//
//  Created by hys on 2018/5/8.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperTableViewController.h"

@interface TaskCenterController : LESuperTableViewController

HitoPropertyNSArray(dataArr);
@property (weak, nonatomic) IBOutlet UIView *daySuper;
@property (weak, nonatomic) IBOutlet UIButton *qiandaoBtn;

@property (weak, nonatomic) IBOutlet UIImageView *boxIM;
@property (weak, nonatomic) IBOutlet UILabel *centerLB;
@property (weak, nonatomic) IBOutlet UILabel *topLB;
@property (weak, nonatomic) IBOutlet UIImageView *bottomIM;
@property (weak, nonatomic) IBOutlet UILabel *bottomLB;
@property (weak, nonatomic) IBOutlet UIView *boxView;

/** 点击tabBar主动刷新页面 */
- (void)tabBarSelectRefreshData;

@end
