//
//  ForgetPassWord.m
//  XWAPP
//
//  Created by hys on 2018/5/8.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "ForgetPassWord.h"

@interface ForgetPassWord ()

@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;

@end

@implementation ForgetPassWord

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setVC];
}

#pragma mark - setVC
- (void)setVC {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self needTapGestureRecognizer];
    
    UIView *phone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
    UIImageView *leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(13, 0, 20, 20)];
    leftImage.image =[UIImage imageNamed:@"login_phone"];
    [phone addSubview:leftImage];
    _foneTF.leftView = phone;
    _foneTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 19)];
    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 0, 19, 19)];
    codeImage.image = HitoImage(@"login_yanzheng");
    [codeView addSubview:codeImage];
    _codeTF.leftView = codeView;
    _codeTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *passWordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 21)];
    UIImageView *passWordImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 0, 21, 21)];
    passWordImage.image = HitoImage(@"login_mima");
    [passWordView addSubview:passWordImage];
    _passWordTF.leftView = passWordView;
    _passWordTF.leftViewMode = UITextFieldViewModeAlways;
    
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
    
    _foneTF.text = [LELoginUserManager mobile];
}

- (void)tap:(UITapGestureRecognizer *)sender {
    _passWordTF.secureTextEntry = !_passWordTF.secureTextEntry;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCodeAction:(JKCountDownButton *)sender {
    if ([self checkoutPhoneNum:_foneTF.text]) {
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
        [self addAlertWithVC:self title:@"警告" message:@"请输入正确的手机号"];
    }
}
- (IBAction)dismissAction:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
//回收键盘
- (void)resign {
    [_foneTF resignFirstResponder];
    [_codeTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
}

//检验
- (BOOL)checkPhoneCodeAndPW {
    if (![self checkoutPhoneNum:_foneTF.text]) {
        [self addAlertWithVC:self title:@"警告" message:@"请输入正确的手机号"];
        return NO;
    }
    
    if (!_codeTF.text || [_codeTF.text isEqualToString:@""]) {
        [self addAlertWithVC:self title:@"警告" message:@"请输入验证码"];
        return NO;
    }
    
    if (!_passWordTF.text || [_passWordTF.text isEqualToString:@""]) {
        [self addAlertWithVC:self title:@"警告" message:@"请输入密码"];
        return NO;
    }
    if (_passWordTF.text.length < 6 || _passWordTF.text.length > 20) {
        [self addAlertWithVC:self title:@"警告" message:@"密码格式不正确"];
        return NO;
    }
    return YES;
}

- (IBAction)loginAction:(UIButton *)sender {
    [self resign];
    if ([self checkPhoneCodeAndPW]) {
        [self affirmRequest];
    }
}

#pragma mark -
#pragma mark - Request
- (void)getSmsCodeRequest{
    
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"SmsSend" urlHost:defaultNetworkHost];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_foneTF.text forKey:@"mobile"];
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

- (void)affirmRequest{
    
    [SVProgressHUD showCustomWithStatus:@"设置中..."];
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"ChangePwd"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_foneTF.text forKey:@"mobile"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"uid"];
    [params setObject:_passWordTF.text forKey:@"pwd"];
    [params setObject:_codeTF.text forKey:@"code"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:@"密码设置成功"];
        [WeakSelf dismissAction:nil];
//        [WeakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

@end
