//
//  LEDetailUserInfoView.h
//  XWAPP
//
//  Created by hys on 2018/7/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEDetailUserInfoView : UIView

@property (copy, nonatomic) void (^avatarClickBlock)(void);
@property (copy, nonatomic) void (^attentionClickBlock)(void);

@property (strong, nonatomic) UIImageView *lineImageView;

- (void)updateViewWithData:(id)data;

@end
