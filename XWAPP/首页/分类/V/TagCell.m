//
//  TagCell.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "TagCell.h"

@implementation TagCell


- (IBAction)rightBtnAction:(UIButton *)sender {
    _rightBlock(sender);
}

- (void)rightAction:(RightAction)rightBlock {
    _rightBlock = rightBlock;
}

@end
