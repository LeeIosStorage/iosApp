//
//  MineHeader.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/27.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "MineHeader.h"

@implementation MineHeader



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
    _leftClick();
}
- (IBAction)centerTapAction:(UITapGestureRecognizer *)sender {
    _centerClick();
}

- (void)leftClickAction:(LeftClick)leftClick {
    _leftClick = leftClick;
}
- (void)centerClickAction:(CenterClick)centerClick {
    _centerClick = centerClick;
}


@end
