//
//  LEPersonalHeaderView.h
//  XWAPP
//
//  Created by hys on 2018/7/20.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEPersonalHeaderView : UIView

@property (copy, nonatomic) void (^attentionClickBlock)(void);

- (void)updateViewWithData:(id)data;

@end
