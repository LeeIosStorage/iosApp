//
//  PhoneLogin.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"

typedef void(^LELoginSuccessBlock)(void);
typedef void(^LELoginFailureBlock)(NSString *errorMessage);
typedef void(^LELoginCancelBlock)(void);

@interface PhoneLogin : LESuperViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, copy) LELoginSuccessBlock loginSuccessBlock;
@property (nonatomic, copy) LELoginCancelBlock loginCancelBlock;
@property (nonatomic, copy) LELoginFailureBlock loginFailureBlock;

@end
