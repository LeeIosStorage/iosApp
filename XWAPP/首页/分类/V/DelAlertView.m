//
//  DelAlertView.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "DelAlertView.h"

@interface DelAlertView ()

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation DelAlertView


- (void)awakeFromNib{
    [super awakeFromNib];
    _titleLB.text = [NSString stringWithFormat:@"选择理由，精准屏蔽"];
}


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
    if (self.delAlertViewShieldClickBlock) {
        NSMutableArray *reasons = [NSMutableArray arrayWithCapacity:0];
        if (self.leftButton.selected) {
            [reasons addObject:@"1"];
        }
        if (self.rightButton.selected) {
            [reasons addObject:@"2"];
        }
        self.delAlertViewShieldClickBlock(reasons);
    }
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
