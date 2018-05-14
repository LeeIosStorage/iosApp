//
//  SearchCollecViewCell.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SearchCollecViewCell.h"

@implementation SearchCollecViewCell
- (IBAction)deleteAction:(UIButton *)sender {
    _click();
}

- (void)clickBtn:(Click)click {
    _click = click;
}

@end
