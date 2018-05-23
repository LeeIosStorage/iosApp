//
//  LELoginManager.h
//  XWAPP
//
//  Created by hys on 2018/5/22.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneLogin.h"

@interface LELoginManager : NSObject

@property (assign, nonatomic) BOOL isShowLogin;

+ (LELoginManager *)sharedInstance;

- (void)showLoginViewControllerFromPresentViewController:(UIViewController *)fromViewController
                                        showCancelButton:(BOOL)showCancel
                                                 success:(LELoginSuccessBlock)success
                                                 failure:(LELoginFailureBlock)failure
                                                  cancel:(LELoginCancelBlock)cancel;

- (BOOL)needUserLogin:(UIViewController *)fromViewController;

@end
