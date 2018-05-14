//
//  ForgetPassWord.m
//  XWAPP
//
//  Created by hys on 2018/5/8.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "ForgetPassWord.h"

@interface ForgetPassWord ()

@end

@implementation ForgetPassWord

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setVC];
}

#pragma mark - setVC
- (void)setVC {
    UIView *phone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    UIImageView *leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 24, 24)];
    leftImage.image =[UIImage imageNamed:@"login_phone"];
    [phone addSubview:leftImage];
    _foneTF.leftView = phone;
    _foneTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 24, 24)];
    codeImage.image = HitoImage(@"login_yanzheng");
    [codeView addSubview:codeImage];
    _codeTF.leftView = codeView;
    _codeTF.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *passWordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    UIImageView *passWordImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 24, 24)];
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
    lb.font = HitoPFSCMediumOfSize(12);
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCodeAction:(JKCountDownButton *)sender {
    if ([self checkoutPhoneNum:_foneTF.text]) {
        sender.enabled = NO;
        [sender startCountDownWithSecond:60];
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
            return title;
        }];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return @"点击重新获取";
            
        }];
    } else {
        //提醒
        [self addAlertWithVC:self title:@"警告" message:@"请输入正确的手机号"];
    }
}
- (IBAction)dismissAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        //
    }
}

@end
