//
//  LEPlayerTitleView.h
//  XWAPP
//
//  Created by hys on 2018/7/12.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotUpButton.h"

@interface LEPlayerTitleView : UIView

@property (copy, nonatomic) void (^cancelFullBlock)(void);

@property (strong, nonatomic) HotUpButton *cancelButton;
@property (strong, nonatomic) UILabel *titleLabel;

- (void)showViewWithIsHidden;

@end
