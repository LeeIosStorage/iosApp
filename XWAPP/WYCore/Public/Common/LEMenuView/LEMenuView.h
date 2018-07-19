//
//  LEMenuView.h
//  XWAPP
//
//  Created by hys on 2018/7/18.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEMenuView : UIView

@property (copy, nonatomic) void (^menuViewClickBlock)(NSInteger index);

- (void)show;

@end
