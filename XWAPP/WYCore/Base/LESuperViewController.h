//
//  LESuperViewController.h
//  XWAPP
//
//  Created by hys on 2018/5/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYNetWorkManager.h"
#import "LERefreshHeader.h"

@interface LESuperViewController : UIViewController

/** 登录成功后刷新页面
 *
 */
- (void)refreshViewWithObject:(id)object;

/** 请求类
 *  EX: self.networkManager
 */
- (WYNetWorkManager *)networkManager;

@end
