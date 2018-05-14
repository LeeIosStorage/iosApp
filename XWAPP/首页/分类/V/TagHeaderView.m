//
//  TagHeaderView.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "TagHeaderView.h"

@implementation TagHeaderView

- (void)action:(BtnBlock)btnBlock {
    _btnBlock = btnBlock;
}

- (IBAction)editBtn:(UIButton *)sender {
    _btnBlock(sender);
}

@end
