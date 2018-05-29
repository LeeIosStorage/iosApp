//
//  PassWordLogin.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/3.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "PassWordLogin.h"
#import "LEWebViewController.h"

@interface PassWordLogin ()

@end

@implementation PassWordLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setVC];
}


#pragma mark - setVC
- (void)setVC {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
    UIImageView *leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(13, 0, 20, 20)];
    leftImage.image =[UIImage imageNamed:@"login_phone"];
    [leftView addSubview:leftImage];
    
    _phoneTF.leftView = leftView;
    _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    NSString *placeholder = @"请输入手机号";
    _phoneTF.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(14) color:[UIColor colorWithHexString:@"a9a9aa"]];

    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 21)];
    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 0, 21, 21)];
    codeImage.image = HitoImage(@"login_mima");
    [codeView addSubview:codeImage];
    _passWordTF.leftView = codeView;
    _passWordTF.leftViewMode = UITextFieldViewModeAlways;
    placeholder = @"请输入6-20位密码";
    _passWordTF.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(14) color:[UIColor colorWithHexString:@"a9a9aa"]];


    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 20)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    line.backgroundColor = HitoColorFromRGB(0Xd9d9d9);
    [rightView addSubview:line];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 74, 20)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = HitoPFSCRegularOfSize(12);
    lb.textColor = HitoColorFromRGB(0X666666);
    lb.text = @"显示密码";
    [rightView addSubview:lb];
    _passWordTF.rightView = rightView;
    _passWordTF.rightViewMode = UITextFieldViewModeAlways;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [rightView addGestureRecognizer:tap];

}

- (void)tap:(UITapGestureRecognizer *)sender {
    _passWordTF.secureTextEntry = !_passWordTF.secureTextEntry;
}

#pragma mark -
#pragma mark - Request
- (void)loginRequest{
    
    [SVProgressHUD showCustomWithStatus:@"登录中..."];
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"Login"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_phoneTF.text.length) [params setObject:_phoneTF.text forKey:@"mobile"];
    [params setObject:_passWordTF.text forKey:@"pwd"];
    [params setObject:@"0" forKey:@"isFastLogin"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
            return ;
        }
        if ([dataObject isKindOfClass:[NSDictionary class]]) {
            [LELoginUserManager setUserID:dataObject[@"uid"]];
            id token = dataObject[@"token"];
            if ([token isKindOfClass:[NSString class]]) {
                NSData *data = [token dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                id tokenObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if ([tokenObject isKindOfClass:[NSDictionary class]]) {
                    [LELoginUserManager setAuthToken:tokenObject[@"access_token"]];
                }
            }
            [WeakSelf refreshUserInfoRequest];
        }
        
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
    }];
    
}

- (void)refreshUserInfoRequest{
    
    [LELoginUserManager refreshUserInfoRequestSuccess:^(BOOL isSuccess, NSString *message) {
        
        if (isSuccess) {
            if (self.loginSuccessBlock) {
                self.loginSuccessBlock();
            }
            [SVProgressHUD showCustomSuccessWithStatus:HitoLoginSucTitle];
        }else{
            //            self.loginFailureBlock(nil);
            [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
        }
    }];
}

#pragma mark - bthAction
- (IBAction)dismissAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

#pragma mark - action

- (IBAction)duigouAction:(UIButton *)sender {
    
}

- (IBAction)xieyi:(UIButton *)sender {
    [self resign];
    LEWebViewController *webVc = [[LEWebViewController alloc] initWithURLString:kAppPrivacyProtocolURL];
    [self.navigationController pushViewController:webVc animated:YES];
}

- (IBAction)loginAction:(UIButton *)sender {
    [self resign];
    if ([self checkPhoneAndPassWord]) {
        [self loginRequest];
    }
}
- (IBAction)forgetAction:(UIButton *)sender {
    _forgetPW();
}

- (IBAction)changeAction:(UIButton *)sender {
    [self.view removeFromSuperview];
}


- (void)forgetPWBlock:(ForgetPW)forgetPW {
    _forgetPW = forgetPW;
}
#pragma mark - judge



#pragma mark - UITextFieldDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resign];
}

- (BOOL)checkPhoneAndPassWord {
    if (![self checkoutPhoneNum:_phoneTF.text]) {
        [self addAlertWithVC:self title:nil message:@"请输入正确的手机号"];
        return NO;
    }
    if (!_passWordTF.text || [_passWordTF.text isEqualToString:@""]) {
        [self addAlertWithVC:self title:nil message:@"请输入密码"];
        return NO;
    }
    return YES;
}

#pragma mark - 回收键盘

- (void)resign {
    [_phoneTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
}


@end
