//
//  PhoneLogin.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "PhoneLogin.h"
#import "PassWordLogin.h"
#import "ForgetPassWord.h"
#import "LEWebViewController.h"
#import "AppDelegate.h"

@interface PhoneLogin ()

@end

@implementation PhoneLogin

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setVC];
}

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
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 19)];
    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 0, 19, 19)];
    codeImage.image = HitoImage(@"login_yanzheng");
    [codeView addSubview:codeImage];
    _codeTF.leftView = codeView;
    _codeTF.leftViewMode = UITextFieldViewModeAlways;
    placeholder = @"请输入短信验证码";
    _codeTF.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(14) color:[UIColor colorWithHexString:@"a9a9aa"]];
    
    _phoneTF.text = [LELoginUserManager mobile];
    
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 20)];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
//    line.backgroundColor = HitoColorFromRGB(0Xd9d9d9);
//    [rightView addSubview:line];
//    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 74, 20)];
//    lb.textAlignment = NSTextAlignmentCenter;
//    lb.font = HitoPFSCRegularOfSize(12);
//    lb.textColor = HitoColorFromRGB(0X666666);
//    lb.text = @"显示密码";
//    [rightView addSubview:lb];
//    _codeTF.rightView = rightView;
//    _codeTF.rightViewMode = UITextFieldViewModeAlways;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    [rightView addGestureRecognizer:tap];
    
    
}

- (void)tap:(UITapGestureRecognizer *)sender {
    _codeTF.secureTextEntry = !_codeTF.secureTextEntry;
    [self resigBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}


- (IBAction)duigou:(UIButton *)sender {
//    [self resigBoard];
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [_loginBtn setBackgroundColor:HitoColorFromRGB(0Xff4b41)];
//        _loginBtn.userInteractionEnabled = YES;
//    } else {
//        [_loginBtn setBackgroundColor:HitoColorFromRGB(0Xc0c0c0)];
//        _loginBtn.userInteractionEnabled = NO;
//    }
}

- (IBAction)uerProtocol:(UIButton *)sender {
    [self resigBoard];
    LEWebViewController *webVc = [[LEWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@/%@",[WYAPIGenerate sharedInstance].baseWebUrl,kAppPrivacyProtocolURLPath]];
    [self.navigationController pushViewController:webVc animated:YES];
}
- (IBAction)login:(UIButton *)sender {
    [self resigBoard];
    if ([self checkPhoneAndCode]) {
        [self loginRequest];
    }
}
- (IBAction)change:(UIButton *)sender {
    [self resigBoard];
    PassWordLogin *passWord = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PassWordLogin"];
    passWord.view.frame = self.view.frame;
    
    HitoWeakSelf;
    [passWord forgetPWBlock:^{
        ForgetPassWord *forgetPW = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgetPassWord"];
        forgetPW.view.frame = WeakSelf.view.frame;
        [WeakSelf.view addSubview:forgetPW.view];
        [WeakSelf addChildViewController:forgetPW];
    }];
    
    passWord.loginSuccessBlock = ^{
        if (WeakSelf.loginSuccessBlock) {
            WeakSelf.loginSuccessBlock();
        }
    };
    
    [self.view addSubview:passWord.view];
    [self addChildViewController:passWord];
}




- (IBAction)getCode:(JKCountDownButton *)sender {
    if ([self checkoutPhoneNum:_phoneTF.text]) {
        
        [self resigBoard];
        sender.enabled = NO;
        [sender startCountDownWithSecond:60];
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"%zd秒",second];
            return title;
        }];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return @"点击重新获取";
        }];
        [self getSmsCodeRequest];
        
    } else {
        //提醒
        [self addAlertWithVC:self title:nil message:@"请输入正确的手机号"];
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resigBoard];
}

#pragma mark - 回收键盘

- (void)resigBoard {
    [_phoneTF resignFirstResponder];
    [_codeTF resignFirstResponder];
}


- (BOOL)checkPhoneAndCode {
    if (![self checkoutPhoneNum:_phoneTF.text]) {
        [self addAlertWithVC:self title:nil message:@"请输入正确的手机号"];
        return NO;
    }
    if (!_codeTF.text || [_codeTF.text isEqualToString:@""]) {
        [self addAlertWithVC:self title:nil message:@"请输入验证码"];
        return NO;
    }
    
    return YES;
}


#pragma mark -
#pragma mark - Request
- (void)getSmsCodeRequest{
    
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"SmsSend"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_phoneTF.text.length) [params setObject:_phoneTF.text forKey:@"mobile"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [WeakSelf.codeBtn stopCountDown];
            [SVProgressHUD showCustomErrorWithStatus:@"发送失败"];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:@"发送成功"];
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf.codeBtn stopCountDown];
        [SVProgressHUD showCustomErrorWithStatus:@"发送失败"];
    }];
    
}

- (void)loginRequest{
    
    [SVProgressHUD showCustomWithStatus:@"登录中..."];
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"Login"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_phoneTF.text.length) [params setObject:_phoneTF.text forKey:@"mobile"];
    [params setObject:_codeTF.text forKey:@"pwd"];
    [params setObject:@"1" forKey:@"isFastLogin"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSDictionary class]]) {
            [LELoginUserManager setUserID:dataObject[@"uid"]];
            
            [MobClick event:@"__register" attributes:@{@"userid":dataObject[@"uid"]}];
                                                       
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
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate resetJPushTagsAndAlias];
        }
        
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
    }];
    
}

- (void)refreshUserInfoRequest{
    //@"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiMTM4MDM4MzM0NjYiLCJuYmYiOiIxNTI2OTgwMDQzIiwiZXhwIjoiMTUyNzA2NjQ0MyJ9.P40TcqhlIjTRCeLt9DF45U2RO9x0KMocmk0hpCS-0O4"
    
    [LELoginUserManager refreshUserInfoRequestSuccess:^(BOOL isSuccess, NSString *message) {
        
        if (isSuccess) {
            self.loginSuccessBlock();
            [SVProgressHUD showCustomSuccessWithStatus:HitoLoginSucTitle];
        }else{
//            self.loginFailureBlock(nil);
            [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
        }
    }];
}

@end
