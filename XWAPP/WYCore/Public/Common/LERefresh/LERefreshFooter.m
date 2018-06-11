//
//  LERefreshFooter.m
//  XWAPP
//
//  Created by hys on 2018/5/28.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LERefreshFooter.h"

//NSString *const LERefreshStateNoMoreDataText = @"已加载完";

@implementation LERefreshFooter

- (void)prepare{
    [super prepare];
    
    self.stateLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.stateLabel.font = HitoPFSCRegularOfSize(13);
    
    [self setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [self setTitle:LERefreshStateNoMoreDataText forState:MJRefreshStateNoMoreData];
}

@end
