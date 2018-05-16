//
//  LESuperViewController.h
//  XWAPP
//
//  Created by hys on 2018/5/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYNetWorkManager.h"

@interface LESuperViewController : UIViewController

/** 请求类
 *  EX: self.networkManager
 */
- (WYNetWorkManager *)networkManager;

@end
