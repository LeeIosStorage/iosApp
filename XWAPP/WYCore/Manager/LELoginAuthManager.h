//
//  LELoginAuthManager.h
//  XWAPP
//
//  Created by hys on 2018/5/31.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

typedef void(^LoginAuthBindingSuccessBlock)(BOOL success);

@interface LELoginAuthManager : NSObject

+ (LELoginAuthManager *)sharedInstance;

//微信授权绑定
- (void)socialAuthBinding:(UMSocialPlatformType)loginType presentingController:(UIViewController *)presentingController success:(LoginAuthBindingSuccessBlock)success;

@end
