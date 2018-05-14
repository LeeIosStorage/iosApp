//
//  PassWordLogin.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/3.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "PassWordLogin.h"

@interface PassWordLogin ()

@end

@implementation PassWordLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setVC];
}


#pragma mark - setVC
- (void)setVC {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    UIImageView *leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 24, 24)];
    leftImage.image =[UIImage imageNamed:@"login_phone"];
    [leftView addSubview:leftImage];
    
    _phoneTF.leftView = leftView;
    _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 24, 24)];
    codeImage.image = HitoImage(@"login_mima");
    [codeView addSubview:codeImage];
    _passWordTF.leftView = codeView;
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
}

- (IBAction)loginAction:(UIButton *)sender {
    [self resign];
    if ([self checkPhoneAndPassWord]) {
        //
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
    if ([self checkoutPhoneNum:_phoneTF.text]) {
        [self addAlertWithVC:self title:@"警告" message:@"请输入正确的手机号"];
        return NO;
    }
    if (!_passWordTF.text || [_passWordTF.text isEqualToString:@""]) {
        [self addAlertWithVC:self title:@"警告" message:@"请输入密码"];
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
