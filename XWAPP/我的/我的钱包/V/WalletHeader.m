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
    _rightBtn.selected = NO;
    _rightView.hidden = !_rightBtn.selected;
    sender.selected = !sender.selected;
    _leftView.hidden = NO;
    _leftBlock();
}

- (IBAction)rightAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    
    _leftBtn.selected = NO;
    _leftView.hidden = !_leftBtn.selected;
    
    sender.selected = !sender.selected;
    _rightView.hidden = NO;
    _rightBlock();
}

- (void)leftBlockAction:(LeftBtnAction)leftBlock {
    _leftBlock = leftBlock;
}

- (void)rightBlockAction:(RightBtnAction)rightBlock {
    _rightBlock = rightBlock;
}

@end
