//
//  LEPlayControlBar.h
//  XWAPP
//
//  Created by hys on 2018/7/12.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEVideoLoadingView.h"

typedef void(^FullScreenBlock)(void);

@interface LEPlayControlBar : UIView

@property (strong, nonatomic) UILabel *playTimeLabel;

@property (strong, nonatomic) UILabel *totalTimeLabel;

@property (strong, nonatomic) UIButton *fullScreenButton;

@property (strong, nonatomic) LEVideoLoadingView *loadingView;

@property (copy, nonatomic) FullScreenBlock fullScreenBlock;


- (void)showBottomBarWithIsHidden;

@end
