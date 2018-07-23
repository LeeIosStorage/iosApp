//
//  LECustomNavBar.h
//  XWAPP
//
//  Created by hys on 2018/7/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotUpButton.h"

@interface LECustomNavBar : UIView

@property (copy, nonatomic) void (^backClickBlock)(void);

@property (strong, nonatomic) HotUpButton *backButton;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *lineImageView;

@end
