//
//  LEPlayerStatusView.h
//  XWAPP
//
//  Created by hys on 2018/7/13.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PlayButtonClickedBlock)(UIButton *);

typedef NS_ENUM(NSInteger, PlayStatus) {
    LEplayStatus_loading = 0,
    LEplayStatus_pause ,
    LEplayStatus_playing ,
    LEplayStatus_end,
};

@interface LEPlayerStatusView : UIView

@property (nonatomic, assign) PlayStatus            playStatus;

@property (nonatomic, strong) UIButton *playbutton;

@property (nonatomic, copy) PlayButtonClickedBlock  playButtonClickedBlock;

- (void)showViewWithIsHidden;

@end
