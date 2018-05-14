//
//  UITableViewController+SetTBStyle.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "UITableViewController+SetTBStyle.h"

@implementation UITableViewController (SetTBStyle)

- (void)setStyle {
    self.tableView.tableFooterView = [UIView new];
    [[UITableViewHeaderFooterView appearance] setTintColor:HitoColorFromRGB(0Xf1f1f1)];
}

@end
