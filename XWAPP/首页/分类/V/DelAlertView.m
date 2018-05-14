//
//  DelAlertView.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "DelAlertView.h"



@implementation DelAlertView





- (IBAction)rightBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _count++;
        sender.layer.borderColor = [UIColor clearColor].CGColor;
        sender.backgroundColor = HitoRGBA(255, 75, 65, 1);
    } else {
        _count--;
        sender.backgroundColor = [UIColor clearColor];
        sender.layer.borderColor = HitoRGBA(153, 153, 153, 1).CGColor;

    }
    _titleLB.text = [NSString stringWithFormat:@"已经选中%zd项", _count];


}

- (IBAction)bottomBtnAction:(UIButton *)sender {
}

- (IBAction)leftBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _count++;
        sender.layer.borderColor = [UIColor clearColor].CGColor;
        sender.backgroundColor = HitoRGBA(255, 75, 65, 1);
    } else {
        _count--;
        sender.backgroundColor = [UIColor clearColor];
        sender.layer.borderColor = HitoRGBA(153, 153, 153, 1).CGColor;

    }
    _titleLB.text = [NSString stringWithFormat:@"已经选中%zd项", _count];
}
@end
