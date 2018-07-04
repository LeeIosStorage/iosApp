//
//  MineHeader.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/27.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "MineHeader.h"

@implementation MineHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = HitoActureHeight(70)/2;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.codeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self changeLB];
}


- (void)changeLB {
    if (HitoScreenW > 375) {
        _minImageBottom.constant = 21;
    } else {
        _minImageBottom.constant = 14;
    }
}


- (IBAction)leftTapAction:(UITapGestureRecognizer *)sender {
    if (_leftClick) {
        _leftClick();
    }
}
- (IBAction)centerTapAction:(UITapGestureRecognizer *)sender {
    if (_centerClick) {
        _centerClick();
    }
}

- (IBAction)codePasteAction:(id)sender{
    if (![LELoginUserManager invitationCode]) {
        return;
    }
    UIPasteboard *copyBoard = [UIPasteboard generalPasteboard];
    copyBoard.string = [LELoginUserManager invitationCode];
    [copyBoard setPersistent:YES];
    [SVProgressHUD showCustomInfoWithStatus:@"已成功复制邀请码"];
}

- (void)leftClickAction:(LeftClick)leftClick {
    _leftClick = leftClick;
}
- (void)centerClickAction:(CenterClick)centerClick {
    _centerClick = centerClick;
}


@end
