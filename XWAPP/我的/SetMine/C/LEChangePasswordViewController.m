//
//  LEChangePasswordViewController.m
//  XWAPP
//
//  Created by hys on 2018/5/29.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEChangePasswordViewController.h"

@interface LEChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *affirmButton;

@end

@implementation LEChangePasswordViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSubViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)setupSubViews{
    
    [self setTitle:@"修改密码"];
    
    [self needTapGestureRecognizer];
    [self.codeTextField becomeFirstResponder];
    
    self.phoneTipLabel.text = [NSString stringWithFormat:@"当前手机号  %@",[self numberSuitScanf:[LELoginUserManager mobile]]];
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 19)];
    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 0, 19, 19)];
    codeImage.image = HitoImage(@"login_yanzheng");
    [codeView addSubview:codeImage];
    self.codeTextField.leftView = codeView;
    self.codeTextField.leftViewMode = UITextFieldViewModeAlways;
    NSString *placeholder = @"请输入短信验证码";
     self.codeTextField.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(14) color:[UIColor colorWithHexString:@"a9a9aa"]];
    
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 21)];
    UIImageView *passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 0, 21, 21)];
    passwordImage.image = HitoImage(@"login_mima");
    [passwordView addSubview:passwordImage];
    _passwordTextField.leftView = passwordView;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    placeholder = @"请输入密码，6-20位英文字母或数字";
    _passwordTextField.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(14) color:[UIColor colorWithHexString:@"a9a9aa"]];
    
}

#pragma mark -
#pragma mark - Request
- (void)getSmsCodeRequest{
    
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"SmsSend"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager mobile].length) [params setObject:[LELoginUserManager mobile] forKey:@"mobile"];
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
    
    [SVProgressHUD showCustomWithStatus:@"修改中..."];
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"ChangePwd"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager mobile].length) [params setObject:[LELoginUserManager mobile] forKey:@"mobile"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"uid"];
    [params setObject:_passwordTextField.text forKey:@"pwd"];
    [params setObject:_codeTextField.text forKey:@"code"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            
            return ;
        }
        
        [SVProgressHUD showCustomSuccessWithStatus:@"密码修改成功"];
        [WeakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark - IBActions

- (IBAction)codeAction:(JKCountDownButton *)sender {
    
    [self.view endEditing:YES];
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
}

- (IBAction)affirmAction:(id)sender {
    if (!_codeTextField.text || [_codeTextField.text isEqualToString:@""]) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入验证码"];
        return;
    }
    if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""]) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入新密码"];
        return;
    }
    if (_passwordTextField.text.length < 6 || _passwordTextField.text.length > 20) {
        [SVProgressHUD showCustomInfoWithStatus:@"密码格式不正确"];
        return;
    }
    [self.view endEditing:YES];
    [self affirmRequest];
}

@end
