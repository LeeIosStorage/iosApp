//
//  NSObject+ZZBDS.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface NSObject (ZZBDS)

- (BOOL)checkoutPhoneNum:(NSString *)phoneNum;


- (void)addAlertWithVC:(UIViewController *)alertVC title:(NSString *)title message:(NSString *)message;
@end
