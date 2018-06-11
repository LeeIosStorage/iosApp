//
//  SearchHeader.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SearchHeader.h"

@implementation SearchHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)rightBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _click();
}

- (void)clickBtn:(Click)click {
    _click = click;
}

@end
