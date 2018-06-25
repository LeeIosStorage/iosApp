//
//  LEWithdrawItemView.h
//  XWAPP
//
//  Created by hys on 2018/6/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEWithdrawModel.h"

@interface LEWithdrawItemView : UIView

@property (strong, nonatomic) UIButton *clickButton;

- (void)updateItemViewData:(LEWithdrawModel *)model;

@end
