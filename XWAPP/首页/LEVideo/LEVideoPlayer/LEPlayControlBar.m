//
//  LEPlayControlBar.m
//  XWAPP
//
//  Created by hys on 2018/7/12.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEPlayControlBar.h"

@interface LEPlayControlBar ()

@end

@implementation LEPlayControlBar

#pragma mark -
#pragma mark - Lifecycle
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark -
#pragma mark - Private
- (void)setup{
//    self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.3];
    
    [WYCommonUtils addShadowWithView:self mode:1 size:CGSizeMake(HitoScreenH, 44)];
    
    [self addSubview:self.playTimeLabel];
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(13);
        make.bottom.equalTo(self).offset(-12);
    }];
    
    [self addSubview:self.fullScreenButton];
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-7);
        make.centerY.equalTo(self.playTimeLabel);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self addSubview:self.totalTimeLabel];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenButton.mas_left).offset(-12);
        make.centerY.equalTo(self.playTimeLabel);
    }];
    
    [self addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playTimeLabel.mas_right).offset(10);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.playTimeLabel);
        make.height.mas_equalTo(25);
    }];
    
}

- (void)showBottomBarWithIsHidden{
    
    if (self.hidden){
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.hidden = NO;
            self.alpha = 1;
        } completion:^(BOOL finished)
         {
         }];
    }else{
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.alpha = 0;
        }completion:^(BOOL finished){
            self.hidden = YES;
        }];
    }
}

- (void)fullScreenBtnClicked
{
    if (self.fullScreenBlock) {
        self.fullScreenBlock();
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (UILabel *)playTimeLabel{
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.textColor = [UIColor whiteColor];
        _playTimeLabel.font = [UIFont systemFontOfSize:13];
        _playTimeLabel.text = @"00:00";
    }
    return _playTimeLabel;
}

- (UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:13];
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenButton{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"le_player_fullScreen_iphone"] forState:UIControlStateNormal];
        [_fullScreenButton setImage:[UIImage imageNamed:@"le_player_window_iphone"] forState:UIControlStateSelected];
        [_fullScreenButton addTarget:self action:@selector(fullScreenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

- (LEVideoLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[LEVideoLoadingView alloc] init];
    }
    return _loadingView;
}

@end
