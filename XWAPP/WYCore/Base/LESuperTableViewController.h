//
//  LESuperTableViewController.h
//  XWAPP
//
//  Created by hys on 2018/5/28.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYNetWorkManager.h"

@interface LESuperTableViewController : UITableViewController

/** 请求类
 *  EX: self.networkManager
 */
- (WYNetWorkManager *)networkManager;

@end
