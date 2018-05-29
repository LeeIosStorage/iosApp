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
#import "LERefreshFooter.h"

@interface LESuperViewController : UIViewController

@property (strong, nonatomic) NSString *customTitle;

/** 登录成功后刷新页面
 *
 */
- (void)refreshViewWithObject:(id)object;

/** 需要点击消除输入框
 *
 */
- (void)needTapGestureRecognizer;

/** 请求类
 *  EX: self.networkManager
 */
- (WYNetWorkManager *)networkManager;

@end
