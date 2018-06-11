//
//  LERefreshHeader.m
//  XWAPP
//
//  Created by hys on 2018/5/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LERefreshHeader.h"

@implementation LERefreshHeader

- (void)prepare{
    [super prepare];
    
    self.stateLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.stateLabel.font = HitoPFSCRegularOfSize(13);
    self.lastUpdatedTimeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.lastUpdatedTimeLabel.font = HitoPFSCRegularOfSize(13);
//    self.lastUpdatedTimeLabel.hidden = YES;
    
}

@end
