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

@interface PhoneLogin ()

@end

@implementation PhoneLogin

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
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
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
    [params setObject:@"0" forKey:@"isFastLogin"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:HitoLoginSucTitle];
        
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
    }];
    
}

@end
