//
//  PassWordLogin.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/3.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"
#import "PhoneLogin.h"

typedef void(^ForgetPW)(void);

@interface PassWordLogin : LESuperViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (nonatomic, copy) ForgetPW forgetPW;

@property (copy, nonatomic) LELoginSuccessBlock         loginSuccessBlock;

- (void)forgetPWBlock:(ForgetPW)forgetPW;
@end
