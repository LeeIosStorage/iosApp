//
//  WalletHeader.m
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "WalletHeader.h"

@implementation WalletHeader

- (IBAction)leftAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    _leftBlock();
}

- (IBAction)rightAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    _rightBlock();
}

- (void)leftBlockAction:(LeftBtnAction)leftBlock {
    _leftBlock = leftBlock;
}

- (void)rightBlockAction:(RightBtnAction)rightBlock {
    _rightBlock = rightBlock;
}

- (void)refreshUIWithIndex:(NSInteger)index{
    
    _leftView.hidden = YES;
    _rightView.hidden = YES;
    if (index == 1) {
        _rightView.hidden = NO;
        _rightBtn.selected = YES;
        _leftBtn.selected = NO;
    }else{
        _leftView.hidden = NO;
        _rightBtn.selected = NO;
        _leftBtn.selected = YES;
    }
}

@end
