//
//  WithdrawController.m
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "WithdrawController.h"

@interface WithdrawController ()

@end

@implementation WithdrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaStyle];
    [self setView];
}

- (void)setView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bottomView.layer.shadowOpacity = 0.8f;
    _bottomView.layer.shadowRadius = 4.0f;
    _bottomView.layer.shadowOffset = CGSizeMake(4,4);
    self.title = @"我要提现";
    
    [self.bottomView removeFromSuperview];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(56);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)zfbAction:(UIButton *)sender {
    _zfbBtn.layer.borderColor = HitoColorFromRGB(0xff4b41).CGColor;
    _wxBtn.layer.borderColor = HitoColorFromRGB(0xb5b5b5).CGColor;
    [_zfbIM setHighlighted:YES];
    [_wxIM setHighlighted:NO];
}

- (IBAction)wxAction:(UIButton *)sender {
    _wxBtn.layer.borderColor = HitoColorFromRGB(0xff4b41).CGColor;
    _zfbBtn.layer.borderColor = HitoColorFromRGB(0xb5b5b5).CGColor;
    [_wxIM setHighlighted:YES];
    [_zfbIM setHighlighted:NO];
}
- (IBAction)leftAction:(UIButton *)sender {
    _leftBtn.layer.borderColor = HitoColorFromRGB(0xff4b41).CGColor;
    _centerBtn.layer.borderColor = HitoColorFromRGB(0xb5b5b5).CGColor;
    _rightBtn.layer.borderColor = HitoColorFromRGB(0xb5b5b5).CGColor;

    [_leftIM setHighlighted:YES];
    [_centerIM setHighlighted:NO];
    [_rightIM setHighlighted:NO];
}

- (IBAction)centerAction:(UIButton *)sender {
    _centerBtn.layer.borderColor = HitoColorFromRGB(0xff4b41).CGColor;
    _leftBtn.layer.borderColor = HitoColorFromRGB(0xb5b5b5).CGColor;
    _rightBtn.layer.borderColor = HitoColorFromRGB(0xb5b5b5).CGColor;
    
    [_leftIM setHighlighted:NO];
    [_centerIM setHighlighted:YES];
    [_rightIM setHighlighted:NO];
}
- (IBAction)rightAction:(UIButton *)sender {
    _rightBtn.layer.borderColor = HitoColorFromRGB(0xff4b41).CGColor;
    _leftBtn.layer.borderColor = HitoColorFromRGB(0xb5b5b5).CGColor;
    _centerBtn.layer.borderColor = HitoColorFromRGB(0xb5b5b5).CGColor;
    
    [_leftIM setHighlighted:NO];
    [_centerIM setHighlighted:NO];
    [_rightIM setHighlighted:YES];
}
- (IBAction)withdrawAction:(UIButton *)sender {
}

@end
